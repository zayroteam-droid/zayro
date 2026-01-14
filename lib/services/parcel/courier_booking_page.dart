import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services_api/geocoding_service.dart';
import '../../widgets/osm_map.dart';
import 'package:latlong2/latlong.dart';
import 'courier_confirmation_page.dart';

/// ======================
/// GLOBAL PRICES
/// ======================
const double basePerMileNextDay = 1.30;
const double perMileNextDayOver20 = 1.10;
const double basePerMileExpress = 1.50;
const double perMileExpressOver20 = 1.20;
const double fragilePerMile = 0.20;
const double extraKgFee = 2.0;
const int maxKg = 30;

/// ======================
/// PAGE
/// ======================
class ParcelPickupPage extends StatefulWidget {
  const ParcelPickupPage({super.key});

  @override
  State<ParcelPickupPage> createState() => _ParcelPickupPageState();
}

enum TripType { single, returnTrip, multiDrop }
enum DeliveryType { nextDay, express }
enum DeliveryTimeType { asap, scheduled }

class _ParcelPickupPageState extends State<ParcelPickupPage> {
  TripType selectedTrip = TripType.single;
  DeliveryType selectedDelivery = DeliveryType.nextDay;

  final pickupController = TextEditingController();
  final dropControllers = [TextEditingController()]; // at least 1 drop
  final weightController = TextEditingController();
  bool fragile = false;
  bool isLoading = false;

  List<LatLng> dropLatLngs = [];
  LatLng? pickupLatLng;
  double? totalMiles;

  /// Delivery time
  DeliveryTimeType selectedTime = DeliveryTimeType.asap;
  TimeOfDay? scheduledTime;

  /// ======================
  /// OSRM Distance Calculation
  /// ======================
  Future<double> calculateDistance(List<LatLng> points) async {
    if (points.length < 2) return 0.0;
    double sumMiles = 0.0;

    for (int i = 0; i < points.length - 1; i++) {
      final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${points[i].longitude},${points[i].latitude};'
        '${points[i + 1].longitude},${points[i + 1].latitude}?overview=false',
      );
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      if (data['code'] != 'Ok') continue;
      final meters = data['routes'][0]['distance'];
      sumMiles += meters / 1609.34;
    }
    return sumMiles;
  }

  /// ======================
  /// Handle Calculate Price
  /// ======================
  Future<void> handleCalculate() async {
    if (pickupController.text.isEmpty ||
        dropControllers.any((c) => c.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter pickup and all drop addresses")),
      );
      return;
    }

    setState(() => isLoading = true);

    // get coordinates
    pickupLatLng = await GeocodingService.getCoordinates(pickupController.text);
    dropLatLngs = [];
    for (var c in dropControllers) {
      final latLng = await GeocodingService.getCoordinates(c.text);
      if (latLng == null) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid address")),
        );
        return;
      }
      dropLatLngs.add(latLng);
    }

    // assemble points based on trip type
    List<LatLng> routePoints = [pickupLatLng!, ...dropLatLngs];
    if (selectedTrip == TripType.returnTrip) {
      routePoints.add(pickupLatLng!);
    }

    totalMiles = await calculateDistance(routePoints);

    setState(() => isLoading = false);
  }

  /// ======================
  /// Calculate Price
  /// ======================
  double getPrice() {
    if (totalMiles == null) return 0.0;

    double perMile = 0.0;
    if (selectedDelivery == DeliveryType.nextDay) {
      perMile = totalMiles! > 20 ? perMileNextDayOver20 : basePerMileNextDay;
    } else {
      perMile = totalMiles! > 20 ? perMileExpressOver20 : basePerMileExpress;
    }

    if (fragile) perMile += fragilePerMile;

    int weight = int.tryParse(weightController.text) ?? 0;
    double extraWeight = 0.0;
    if (weight > 10) {
      extraWeight = (weight - 10) * extraKgFee;
    }

    return totalMiles! * perMile + extraWeight;
  }

  /// ======================
  /// UI
  /// ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parcel Pick & Drop")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Trip Type Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                tripButton("Single", TripType.single, Colors.blue),
                tripButton("Return", TripType.returnTrip, Colors.green),
                tripButton("Multi-drop", TripType.multiDrop, Colors.orange),
              ],
            ),
            const SizedBox(height: 20),

            /// Pickup Address
            TextField(
              controller: pickupController,
              decoration: const InputDecoration(
                labelText: "Pickup Address / Postcode",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            /// Drop(s)
            ...dropControllers.asMap().entries.map(
              (entry) => Column(
                children: [
                  TextField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: entry.key == 0 ? "Drop Address / Postcode" : "Additional Drop",
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            if (selectedTrip == TripType.multiDrop)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      dropControllers.add(TextEditingController());
                    });
                  },
                  child: const Text("Add another drop"),
                ),
              ),
            const SizedBox(height: 20),

            /// Delivery Type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                deliveryButton("Next Day", DeliveryType.nextDay, Colors.purple),
                deliveryButton("Express", DeliveryType.express, Colors.red),
              ],
            ),
            const SizedBox(height: 20),

            /// Weight & Fragile
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weight (kg, max 30kg)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: fragile,
                  onChanged: (v) => setState(() => fragile = v ?? false),
                ),
                const Text("Fragile"),
              ],
            ),
            const SizedBox(height: 20),

            /// Calculate Price & Show Route
            ElevatedButton(
              onPressed: isLoading ? null : handleCalculate,
              child: const Text("Calculate Price & Show Route"),
            ),
            const SizedBox(height: 20),

            /// Show Price & Map
            if (totalMiles != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Distance: ${totalMiles!.toStringAsFixed(2)} miles\nPrice: £${getPrice().toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (pickupLatLng != null && dropLatLngs.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: OsmMap(
                        center: pickupLatLng,
                        markers: [pickupLatLng!, ...dropLatLngs],
                      ),
                    ),
                ],
              ),

            const SizedBox(height: 20),

            /// ======================
            /// Delivery Time Selection
            /// ======================
            const Text("Delivery Time", style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text("ASAP"),
              value: DeliveryTimeType.asap,
              groupValue: selectedTime,
              onChanged: (value) {
                setState(() {
                  selectedTime = value!;
                  scheduledTime = null;
                });
              },
            ),
            RadioListTile(
              title: const Text("Schedule for later"),
              value: DeliveryTimeType.scheduled,
              groupValue: selectedTime,
              onChanged: (value) {
                setState(() => selectedTime = value!);
              },
            ),
            if (selectedTime == DeliveryTimeType.scheduled)
              ListTile(
                title: Text(
                  scheduledTime == null ? "Select time" : scheduledTime!.format(context),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) setState(() => scheduledTime = time);
                },
              ),
            const SizedBox(height: 15),

            /// ======================
            /// Estimate Price / Continue Button
            /// ======================
            ElevatedButton(
              onPressed: totalMiles == null || pickupLatLng == null || dropLatLngs.isEmpty
                  ? null
                  : () {
                     Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CourierConfirmationPage(
      pickupAddress: pickupController.text,
      dropAddresses: dropControllers.map((c) => c.text).toList(),
      tripType: selectedTrip.toString().split('.').last,
      deliveryType: selectedDelivery.toString().split('.').last,
      weight: int.tryParse(weightController.text) ?? 0,
      fragile: fragile,
      totalMiles: totalMiles ?? 0.0,
      price: getPrice(),
      pickupLatLng: pickupLatLng!,
      dropLatLngs: dropLatLngs,
      deliveryTimeLabel: selectedTime == DeliveryTimeType.asap
          ? "ASAP"
          : scheduledTime != null
              ? scheduledTime!.format(context)
              : "Scheduled",
    ),
  ),
);

                    },
              child: const Text("Estimate Price / Continue"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// ======================
  /// UI Helpers
  /// ======================
  Widget tripButton(String label, TripType type, Color color) {
    bool selected = selectedTrip == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? color : Colors.grey.shade300,
      ),
      onPressed: () => setState(() {
        selectedTrip = type;
        if (type == TripType.single && dropControllers.length > 1) {
          dropControllers.removeRange(1, dropControllers.length);
        }
      }),
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }

  Widget deliveryButton(String label, DeliveryType type, Color color) {
    bool selected = selectedDelivery == type;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? color : Colors.grey.shade300,
      ),
      onPressed: () => setState(() => selectedDelivery = type),
      child: Text(
        label,
        style: TextStyle(color: selected ? Colors.white : Colors.black),
      ),
    );
  }
}
