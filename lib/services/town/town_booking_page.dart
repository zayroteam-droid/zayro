import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../services_api/geocoding_service.dart';
import '../../widgets/osm_map.dart';
import '../town/town_confirmation_page.dart';

/// ======================
/// VEHICLES & FARES
/// ======================
const List<String> vehicles = ["Standard", "Executive", "SUV"];
const Map<String, double> vehiclePerMile = {
  "Standard": 2.0,
  "Executive": 3.0,
  "SUV": 4.0,
};

const double waitingTimeFree = 5.0; // minutes free
const double waitingPerMinute = 1.0;

/// ======================
/// TRIP TYPES
/// ======================
enum TripType { single, returnTrip, multiStop }

/// ======================
/// PAGE
/// ======================
class TownBookingPage extends StatefulWidget {
  const TownBookingPage({super.key});

  @override
  State<TownBookingPage> createState() => _TownBookingPageState();
}

class _TownBookingPageState extends State<TownBookingPage> {
  final pickupController = TextEditingController();
  final dropController = TextEditingController();

  TripType selectedTrip = TripType.single;
  Map<String, dynamic> additionalStops = {};

  double? tripMiles;
  String? selectedVehicle;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  bool isLoading = false;

  bool get canShowVehicles => tripMiles != null;

  @override
  void dispose() {
    pickupController.dispose();
    dropController.dispose();
    super.dispose();
  }

  /// ======================
  /// DISTANCE (OSRM)
  /// ======================
  Future<double?> calculateDistance(String origin, String destination) async {
    final originCoord = await GeocodingService.getCoordinates(origin);
    final destCoord = await GeocodingService.getCoordinates(destination);

    if (originCoord == null || destCoord == null) return null;

    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${originCoord.longitude},${originCoord.latitude};${destCoord.longitude},${destCoord.latitude}?overview=false');
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (data['code'] != 'Ok') return null;

    final meters = data['routes'][0]['distance'];
    final miles = meters / 1609.34;
    return miles;
  }

  /// ======================
  /// SHOW FARES
  /// ======================
  Future<void> handleShowFares() async {
    if (pickupController.text.isEmpty || dropController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter pickup and drop")));
      return;
    }

    setState(() => isLoading = true);

    final miles =
        await calculateDistance(pickupController.text, dropController.text);

    if (miles == null) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Invalid address")));
      return;
    }

    setState(() {
      tripMiles = miles;
      selectedVehicle = null;
      isLoading = false;
    });
  }

  /// ======================
  /// FARE CALCULATION (NO TERMINAL CHARGE)
  /// ======================
  double getFare(String vehicle) {
    if (tripMiles == null) return 0.0;

    double perMile = vehiclePerMile[vehicle]!;

    // Droylsden city center adjustment
    if (!pickupController.text.contains("Droylsden")) perMile += 1.0;

    double fare = perMile * tripMiles!;

    // Return trip discount
    if (selectedTrip == TripType.returnTrip) fare *= 1.8; // slightly cheaper

    return fare;
  }

  /// ======================
  /// UI
  /// ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Town Ride / Local Transfer")),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// TRIP TYPE SELECTOR
                  const SectionTitle("Trip Type"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: TripType.values.map((type) {
                      final isSelected = selectedTrip == type;
                      final label = type == TripType.single
                          ? "Single"
                          : type == TripType.returnTrip
                              ? "Return"
                              : "Multi";
                      final color = type == TripType.single
                          ? Colors.blue
                          : type == TripType.returnTrip
                              ? Colors.green
                              : Colors.orange;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedTrip = type),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? color : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  /// PICKUP & DROP
                  const SectionTitle("Journey Details"),
                  const SizedBox(height: 5),
                  TextField(
                    controller: pickupController,
                    decoration: const InputDecoration(
                        labelText: "Pickup Address / Postcode",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: dropController,
                    decoration: const InputDecoration(
                        labelText: "Drop Address / Postcode",
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: handleShowFares,
                    child: const Text("Show Fares"),
                  ),
                  const SizedBox(height: 20),

                  if (isLoading) const Center(child: CircularProgressIndicator()),

                  if (tripMiles != null)
                    Text(
                      "Distance: ${tripMiles!.toStringAsFixed(2)} miles",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                  const SizedBox(height: 20),

                  if (pickupController.text.isNotEmpty &&
                      dropController.text.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: OsmMap(
                        center: awaitGeocode(pickupController.text),
                        markers: [
                          awaitGeocode(pickupController.text),
                          awaitGeocode(dropController.text)
                        ],
                      ),
                    ),

                  const SizedBox(height: 30),

                  /// DATE & TIME
                  const SectionTitle("Date & Time"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: tripMiles == null
                        ? null
                        : () async {
                            final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate:
                                    DateTime.now().add(const Duration(days: 365)));
                            if (picked != null) setState(() => selectedDate = picked);
                          },
                    child: Text(selectedDate == null
                        ? "Select Date"
                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: tripMiles == null
                        ? null
                        : () async {
                            final picked = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (picked != null) setState(() => selectedTime = picked);
                          },
                    child: Text(selectedTime == null
                        ? "Select Time"
                        : selectedTime!.format(context)),
                  ),

                  const SizedBox(height: 30),

                  /// VEHICLES
                  if (canShowVehicles) ...[
                    const SectionTitle("Choose Your Vehicle"),
                    const SizedBox(height: 10),
                    ...vehicles.map((v) => Card(
                          child: RadioListTile<String>(
                            value: v,
                            groupValue: selectedVehicle,
                            title: Row(
                              children: [
                                Icon(
                                  v == "Standard"
                                      ? Icons.directions_car
                                      : v == "Executive"
                                          ? Icons.airline_seat_recline_extra
                                          : Icons.directions_bus,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$v — £${getFare(v).toStringAsFixed(2)}"),
                                    Text(
                                      v == "Standard"
                                          ? "4 Passengers"
                                          : v == "Executive"
                                              ? "4 Passengers"
                                              : "6 Passengers",
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onChanged: (val) {
                              setState(() => selectedVehicle = val);
                            },
                          ),
                        )),
                  ],

                  const SizedBox(height: 20),

                  /// PROCEED BUTTON
                  if (selectedVehicle != null)
                    ElevatedButton(
                      onPressed: () {
                        if (selectedDate == null || selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please select date and time")),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookingConfirmationPage(
                              pickupAddress: pickupController.text,
                              dropAddress: dropController.text,
                              date: selectedDate!,
                              time: selectedTime!,
                              vehicle: selectedVehicle!,
                              fare: getFare(selectedVehicle!),
                            ),
                          ),
                        );
                      },
                      child: const Text("Price estimate"),
                    ),
                ],
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }

  LatLng awaitGeocode(String address) {
    // Quick helper to convert address to LatLng synchronously (for OsmMap)
    return LatLng(53.456, -2.234); // placeholder
  }
}

/// ======================
/// SECTION TITLE & FOOTER
/// ======================
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});
  @override
  Widget build(BuildContext context) =>
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey.shade200,
        child: const Text("© 2025 ZAYRO • Secure • Reliable • Fast",
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      );
}