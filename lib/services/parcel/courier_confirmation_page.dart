import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/osm_map.dart';
import 'courier_customer_details_page.dart';

class CourierConfirmationPage extends StatelessWidget {
  final String pickupAddress;
  final List<String> dropAddresses;
  final String tripType;
  final String deliveryType;
  final int weight;
  final bool fragile;
  final double totalMiles;
  final double price;
  final List<LatLng> dropLatLngs;
  final LatLng pickupLatLng;
  final String deliveryTimeLabel; // Delivery time

  const CourierConfirmationPage({
    super.key,
    required this.pickupAddress,
    required this.dropAddresses,
    required this.tripType,
    required this.deliveryType,
    required this.weight,
    required this.fragile,
    required this.totalMiles,
    required this.price,
    required this.dropLatLngs,
    required this.pickupLatLng,
    required this.deliveryTimeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courier Final Review"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionTitle("Parcel Details"),
            const SizedBox(height: 10),
            InfoRow(label: "Trip Type", value: tripType),
            InfoRow(label: "Delivery Type", value: deliveryType),
            InfoRow(label: "Weight", value: "$weight kg"),
            InfoRow(label: "Fragile", value: fragile ? "Yes" : "No"),
            InfoRow(label: "Delivery Time", value: deliveryTimeLabel),

            const SizedBox(height: 25),
            const SectionTitle("Addresses"),
            const SizedBox(height: 10),
            InfoRow(label: "Pickup", value: pickupAddress),
            const SizedBox(height: 6),
            ...dropAddresses.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: InfoRow(
                  label: entry.key == 0
                      ? "Drop"
                      : "Additional Drop ${entry.key + 1}",
                  value: entry.value,
                ),
              ),
            ),

            const SizedBox(height: 25),
            const SectionTitle("Distance & Price"),
            const SizedBox(height: 10),
            InfoRow(
              label: "Total Distance",
              value: "${totalMiles.toStringAsFixed(2)} miles",
            ),
            InfoRow(
              label: "Total Price",
              value: "£${price.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 25),

            /// MAP PREVIEW
            if (dropLatLngs.isNotEmpty)
              SizedBox(
                height: 220,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: OsmMap(
                    center: pickupLatLng,
                    markers: [pickupLatLng, ...dropLatLngs],
                  ),
                ),
              ),

            const SizedBox(height: 35),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // Navigate to CourierCustomerDetailsPage with required maps
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourierCustomerDetailsPage(
                      journeySummary: {
                        "Trip Type": tripType,
                        "Delivery Type": deliveryType,
                        "Weight": "$weight kg",
                        "Fragile": fragile ? "Yes" : "No",
                        "Delivery Time": deliveryTimeLabel,
                      },
                      serviceDetails: {
                        "Pickup": pickupAddress,
                        ...dropAddresses.asMap().map((i, v) =>
                            MapEntry(i == 0 ? "Drop" : "Additional Drop ${i + 1}", v)),
                      },
                      priceDetails: {
                        "Distance": "${totalMiles.toStringAsFixed(2)} miles",
                        "Price": "£${price.toStringAsFixed(2)}",
                      },
                    ),
                  ),
                );
              },
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ======================
/// Helper Widgets
/// ======================
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            "$label:",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
