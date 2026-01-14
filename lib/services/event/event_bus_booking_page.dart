import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services_api/geocoding_service.dart';
import 'event_booking_confirmation_page.dart';

/// ======================
/// VEHICLES
/// ======================
const Map<String, String> busTypes = {
  "Mini Bus": "8–16 passengers",
  "Midi Coach": "17–35 passengers",
  "Full Coach": "36–53 passengers",
};

/// ======================
/// TRIP TYPE
/// ======================
enum TripType { single, returnTrip, multiStop }

class EventBusBookingPage extends StatefulWidget {
  const EventBusBookingPage({super.key});

  @override
  State<EventBusBookingPage> createState() => _EventBusBookingPageState();
}

class _EventBusBookingPageState extends State<EventBusBookingPage> {
  final pickupController = TextEditingController();
  final dropController = TextEditingController();

  TripType selectedTrip = TripType.single;
  List<TextEditingController> extraStops = [];

  String? selectedBus;

  double? tripMiles;
  bool isLoading = false;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  int durationHours = 1;

  /// ======================
  /// DISTANCE
  /// ======================
  Future<double?> calculateDistance(String from, String to) async {
    final o = await GeocodingService.getCoordinates(from);
    final d = await GeocodingService.getCoordinates(to);

    if (o == null || d == null) return null;

    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${o.longitude},${o.latitude};${d.longitude},${d.latitude}?overview=false');

    final res = await http.get(url);
    final data = jsonDecode(res.body);

    if (data['code'] != 'Ok') return null;

    final meters = data['routes'][0]['distance'];
    return meters / 1609.34;
  }

  /// ======================
  /// SHOW FARE
  /// ======================
  Future<void> handleShowFare() async {
    if (pickupController.text.isEmpty ||
        dropController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter pickup & drop")),
      );
      return;
    }

    setState(() => isLoading = true);

    final miles = await calculateDistance(
        pickupController.text, dropController.text);

    if (miles == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid address")));
      return;
    }

    setState(() {
      tripMiles = miles;
      isLoading = false;
      selectedBus = null;
    });
  }

  /// ======================
  /// FARE FORMULA
  /// ======================
  double calculateFare() {
    if (tripMiles == null) return 0;

    double base = 40;
    double mileRate = 2;
    double timeRate = 0.20;

    double distanceCost = tripMiles! * mileRate;
    double timeCost = durationHours * 60 * timeRate;

    double total = base + distanceCost + timeCost;

    if (selectedTrip == TripType.returnTrip) {
      total += tripMiles! * 1.5;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Bus Booking")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// TRIP TYPE
            Row(
              children: TripType.values.map((t) {
                final selected = selectedTrip == t;
                final label = t == TripType.single
                    ? "One Way"
                    : t == TripType.returnTrip
                        ? "Return"
                        : "Multi";

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTrip = t),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selected ? Colors.blue : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            /// ADDRESSES
            TextField(
              controller: pickupController,
              decoration: const InputDecoration(
                  labelText: "Pickup",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dropController,
              decoration: const InputDecoration(
                  labelText: "Drop",
                  border: OutlineInputBorder()),
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: handleShowFare,
              child: const Text("Show Fare"),
            ),

            if (isLoading)
              const Center(child: CircularProgressIndicator()),

            if (tripMiles != null) ...[
              const SizedBox(height: 15),
              Text(
                "Distance: ${tripMiles!.toStringAsFixed(2)} miles",
                style:
                    const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              /// BUS TYPES
              const Text("Select Bus",
                  style:
                      TextStyle(fontWeight: FontWeight.bold)),
              ...busTypes.entries.map((e) => Card(
                    child: RadioListTile(
                      value: e.key,
                      groupValue: selectedBus,
                      onChanged: (v) =>
                          setState(() => selectedBus = v),
                      title: Text("${e.key} (${e.value})"),
                    ),
                  )),

              const SizedBox(height: 10),

              /// DURATION
              Row(
                children: [
                  const Text("Duration (hours)"),
                  IconButton(
                      onPressed: () => setState(() =>
                          durationHours =
                              durationHours > 1
                                  ? durationHours - 1
                                  : 1),
                      icon: const Icon(Icons.remove)),
                  Text(durationHours.toString()),
                  IconButton(
                      onPressed: () =>
                          setState(() => durationHours++),
                      icon: const Icon(Icons.add)),
                ],
              ),

              const SizedBox(height: 15),

              Text(
                "Estimated Fare: £${calculateFare().toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],

            const SizedBox(height: 20),

            /// DATE TIME
            ElevatedButton(
              onPressed: () async {
                final d = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate:
                        DateTime.now().add(const Duration(days: 365)));
                if (d != null) setState(() => selectedDate = d);
              },
              child: Text(selectedDate == null
                  ? "Select Date"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
            ),

            ElevatedButton(
              onPressed: () async {
                final t = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now());
                if (t != null) setState(() => selectedTime = t);
              },
              child: Text(selectedTime == null
                  ? "Select Time"
                  : selectedTime!.format(context)),
            ),

            const SizedBox(height: 20),

            /// PROCEED
            if (selectedBus != null)
  ElevatedButton(
    onPressed: () {
      if (selectedDate == null || selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select date and time")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EventBookingConfirmationPage(
            pickup: pickupController.text,
            drop: dropController.text,
            bus: selectedBus!,
            date: selectedDate!,
            time: selectedTime!,
            fare: calculateFare(),
          ),
        ),
      );
    },
    child: const Text("Continue"),
  ),

          ],
        ),
      ),
    );
  }
}
