import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../widgets/osm_map.dart';
import 'delivery_customer_detail_page.dart'; // same folder import

class DeliveryConfirmationPage extends StatelessWidget {
  final String pickupAddress;
  final String dropAddress;
  final String vanType;
  final String deliveryOption;
  final bool fragile;
  final String notes;
  final double totalMiles;
  final double estimatedPrice;
  final String deliveryTimeLabel;
  final LatLng pickupLatLng;
  final LatLng dropLatLng;

  // NEW PARAMETERS
  final String cargoType; // "loose" or "pallet"
  final int weight; // used if cargoType == "loose"
  final int pallets; // used if cargoType == "pallet"

  const DeliveryConfirmationPage({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.vanType,
    required this.deliveryOption,
    required this.fragile,
    required this.notes,
    required this.totalMiles,
    required this.estimatedPrice,
    required this.deliveryTimeLabel,
    required this.pickupLatLng,
    required this.dropLatLng,
    required this.cargoType,
    required this.weight,
    required this.pallets,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Confirmation")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text("Pickup & Drop", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text("Pickup: $pickupAddress"),
            Text("Drop: $dropAddress"),
            const SizedBox(height: 20),

            const Text("Van & Delivery Option", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text("Van Type: $vanType"),
            Text("Delivery Option: $deliveryOption"),
            const SizedBox(height: 20),

            const Text("Cargo Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text("Fragile: ${fragile ? 'Yes' : 'No'}"),
            Text("Cargo Type: $cargoType"),
            if (cargoType == "loose") Text("Weight: $weight kg"),
            if (cargoType == "pallet") Text("Pallets: $pallets"),
            Text("Notes: ${notes.isNotEmpty ? notes : '-'}"),
            const SizedBox(height: 20),

            const Text("Delivery Time", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text("Selected Time: $deliveryTimeLabel"),
            const SizedBox(height: 20),

            const Text("Pricing & Distance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text("Estimated Distance: ${totalMiles.toStringAsFixed(2)} miles"),
            Text("Estimated Price: £${estimatedPrice.toStringAsFixed(2)}"),
            const SizedBox(height: 20),

            /// MAP PREVIEW
            SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: OsmMap(
                  center: pickupLatLng,
                  markers: [pickupLatLng, dropLatLng],
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// CONTINUE TO CUSTOMER DETAIL PAGE
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeliveryCustomerDetailPage(
                      pickupAddress: pickupAddress,
                      dropAddress: dropAddress,
                      vanType: vanType,
                      deliveryOption: deliveryOption,
                      fragile: fragile,
                      notes: notes,
                      totalMiles: totalMiles,
                      estimatedPrice: estimatedPrice,
                      deliveryTimeLabel: deliveryTimeLabel,
                      pickupLatLng: pickupLatLng,
                      dropLatLng: dropLatLng,
                      // Pass the new parameters
                      cargoType: cargoType,
                      weight: weight,
                      pallets: pallets,
                    ),
                  ),
                );
              },
              child: const Text("Continue to Customer Details"),
            ),
          ],
        ),
      ),
    );
  }
}
