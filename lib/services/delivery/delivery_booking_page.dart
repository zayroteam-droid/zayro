import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services_api/geocoding_service.dart';
import '../../widgets/osm_map.dart';
import '../delivery/delivery_confirmation_page.dart';
import 'package:latlong2/latlong.dart';

enum VanType { small, medium, large }
enum DeliveryOption { sameDay, nextDay }
enum DeliveryTimeType { asap, scheduled }
enum CargoType { loose, pallet }

class DeliveryBookingPage extends StatefulWidget {
  const DeliveryBookingPage({super.key});

  @override
  State<DeliveryBookingPage> createState() => _DeliveryBookingPageState();
}

class _DeliveryBookingPageState extends State<DeliveryBookingPage> {
  VanType selectedVan = VanType.small;
  DeliveryOption selectedOption = DeliveryOption.sameDay;
  DeliveryTimeType selectedTime = DeliveryTimeType.asap;
  CargoType selectedCargo = CargoType.loose;
  TimeOfDay? scheduledTime;

  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final notesController = TextEditingController();
  final weightController = TextEditingController();
  final palletController = TextEditingController();
  bool fragile = false;
  bool isLoading = false;

  LatLng? pickupLatLng;
  LatLng? dropLatLng;
  double? totalMiles;
  double? estimatedPrice;

  /// ======================
  /// OSRM Distance Calculation
  /// ======================
  Future<double> calculateDistance(LatLng start, LatLng end) async {
    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=false');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    if (data['code'] != 'Ok') return 0.0;
    final meters = data['routes'][0]['distance'];
    return meters / 1609.34;
  }

  /// ======================
  /// Calculate price & distance
  /// ======================
  Future<void> handleCalculate() async {
    if (pickupController.text.isEmpty || dropController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter pickup and drop addresses")),
      );
      return;
    }

    // Validate Cargo input
    if (selectedCargo == CargoType.loose) {
      int weight = int.tryParse(weightController.text) ?? 0;
      int maxWeight = selectedVan == VanType.small ? 30 : 100; // adjust as needed
      if (weight <= 0 || weight > maxWeight) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enter valid weight (max $maxWeight kg)")),
        );
        return;
      }
    } else if (selectedCargo == CargoType.pallet) {
      int pallets = int.tryParse(palletController.text) ?? 0;
      int maxPallets = selectedVan == VanType.small ? 2 : selectedVan == VanType.medium ? 5 : 10;
      if (pallets <= 0 || pallets > maxPallets) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Enter valid number of pallets (max $maxPallets)")),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    final pickup = await GeocodingService.getCoordinates(pickupController.text);
    final drop = await GeocodingService.getCoordinates(dropController.text);

    if (!mounted) return;

    if (pickup == null || drop == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid address")),
      );
      return;
    }

    pickupLatLng = pickup;
    dropLatLng = drop;

    totalMiles = await calculateDistance(pickupLatLng!, dropLatLng!);

    double perMile = selectedOption == DeliveryOption.sameDay ? 1.50 : 1.30;
    if (fragile) perMile += 0.20;

    // Price by cargo type
    double cargoFee = 0.0;
    if (selectedCargo == CargoType.loose) {
      int weight = int.tryParse(weightController.text) ?? 0;
      cargoFee = weight * 0.50; // 50p per kg
    } else {
      int pallets = int.tryParse(palletController.text) ?? 0;
      cargoFee = pallets * 5.0; // example £5 per pallet
    }

    estimatedPrice = totalMiles! * perMile + cargoFee;

    setState(() => isLoading = false);
  }

  /// ======================
  /// Navigate to Delivery Confirmation
  /// ======================
  void goToConfirmation() {
    if (pickupController.text.isEmpty || dropController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter pickup and drop addresses first")),
      );
      return;
    }

    if (totalMiles == null || estimatedPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please calculate price first")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeliveryConfirmationPage(
          pickupAddress: pickupController.text,
          dropAddress: dropController.text,
          vanType: selectedVan.name,
          deliveryOption:
              selectedOption == DeliveryOption.sameDay ? "Same Day" : "Next Day",
          fragile: fragile,
          notes: notesController.text,
          cargoType: selectedCargo.name,
          weight: selectedCargo == CargoType.loose ? int.tryParse(weightController.text) ?? 0 : 0,
          pallets: selectedCargo == CargoType.pallet ? int.tryParse(palletController.text) ?? 0 : 0,
          totalMiles: totalMiles!,
          estimatedPrice: estimatedPrice!,
          deliveryTimeLabel: selectedTime == DeliveryTimeType.asap
              ? "ASAP"
              : scheduledTime != null
                  ? scheduledTime!.format(context)
                  : "Scheduled",
          pickupLatLng: pickupLatLng!,
          dropLatLng: dropLatLng!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Booking")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pickup & Drop
            TextField(
              controller: pickupController,
              decoration: const InputDecoration(
                labelText: "Pickup Address / Postcode",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: dropController,
              decoration: const InputDecoration(
                labelText: "Drop Address / Postcode",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Van Type
            const Text("Select Van Type:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                vanButton("Small Van", VanType.small),
                vanButton("Medium Van", VanType.medium),
                vanButton("Large Van", VanType.large),
              ],
            ),
            const SizedBox(height: 20),

            // Cargo Type
            const Text("Cargo Type:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                cargoButton("Loose Items", CargoType.loose),
                cargoButton("Palletised Goods", CargoType.pallet),
              ],
            ),
            const SizedBox(height: 10),

            if (selectedCargo == CargoType.loose)
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Weight (kg)",
                  border: OutlineInputBorder(),
                ),
              ),
            if (selectedCargo == CargoType.pallet)
              TextField(
                controller: palletController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Number of Pallets",
                  border: OutlineInputBorder(),
                ),
              ),

            const SizedBox(height: 20),

            // Delivery Option
            const Text("Delivery Option:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                optionButton("Same Day", DeliveryOption.sameDay, Colors.blue),
                optionButton("Next Day", DeliveryOption.nextDay, Colors.orange),
              ],
            ),
            const SizedBox(height: 20),

            // Fragile
            Row(
              children: [
                Checkbox(value: fragile, onChanged: (v) => setState(() => fragile = v ?? false)),
                const Text("Fragile Items"),
              ],
            ),
            const SizedBox(height: 10),

            // Notes
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Notes / Instructions",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Calculate Price
            ElevatedButton(
              onPressed: isLoading ? null : handleCalculate,
              child: const Text("Calculate Price & Show Route"),
            ),
            const SizedBox(height: 20),

            // Show Distance & Price
            if (totalMiles != null && estimatedPrice != null)
              Text(
                "Estimated Distance: ${totalMiles!.toStringAsFixed(2)} miles\nEstimated Price: £${estimatedPrice!.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            if (pickupLatLng != null && dropLatLng != null)
              SizedBox(
                height: 200,
                child: OsmMap(
                  center: pickupLatLng!,
                  markers: [pickupLatLng!, dropLatLng!],
                ),
              ),
            const SizedBox(height: 20),

            // Delivery Time
            const Text("Delivery Time:", style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile<DeliveryTimeType>(
              title: const Text("ASAP"),
              value: DeliveryTimeType.asap,
              groupValue: selectedTime,
              onChanged: (value) => setState(() {
                selectedTime = value!;
                scheduledTime = null;
              }),
            ),
            RadioListTile<DeliveryTimeType>(
              title: const Text("Schedule for later"),
              value: DeliveryTimeType.scheduled,
              groupValue: selectedTime,
              onChanged: (value) => setState(() => selectedTime = value!),
            ),
            if (selectedTime == DeliveryTimeType.scheduled)
              ListTile(
                title: Text(scheduledTime == null ? "Select time" : scheduledTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) setState(() => scheduledTime = time);
                },
              ),
            const SizedBox(height: 20),

            // Continue to Confirmation
            ElevatedButton(
              onPressed: goToConfirmation,
              child: const Text("Continue to Confirmation"),
            ),
          ],
        ),
      ),
    );
  }

  // ======================
  // Helper Buttons
  // ======================

  Widget vanButton(String label, VanType type) {
    bool selected = selectedVan == type;

    IconData icon;
    switch (type) {
      case VanType.small:
        icon = Icons.local_shipping;
        break;
      case VanType.medium:
        icon = Icons.airport_shuttle;
        break;
      case VanType.large:
        icon = Icons.fire_truck;
        break;
    }

    return GestureDetector(
      onTap: () => setState(() => selectedVan = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [BoxShadow(color: Colors.greenAccent.withOpacity(0.5), blurRadius: 5)]
              : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: selected ? Colors.white : Colors.black),
            const SizedBox(height: 5),
            Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget cargoButton(String label, CargoType type) {
    bool selected = selectedCargo == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.teal : Colors.grey.shade300,
      ),
      onPressed: () => setState(() => selectedCargo = type),
      child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black)),
    );
  }

  Widget optionButton(String label, DeliveryOption type, Color color) {
    bool selected = selectedOption == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? color : Colors.grey.shade300,
      ),
      onPressed: () => setState(() => selectedOption = type),
      child: Text(label, style: TextStyle(color: selected ? Colors.white : Colors.black)),
    );
  }
}
