import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'delivery_final_review_page.dart'; // make sure this page exists

class DeliveryCustomerDetailPage extends StatefulWidget {
  // ======================
  // Data from Booking Page
  // ======================
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

  // Cargo info
  final String cargoType; // Loose items / Pallets
  final int weight;       // if Loose items
  final int pallets;      // if Pallets

  const DeliveryCustomerDetailPage({
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
  State<DeliveryCustomerDetailPage> createState() =>
      _DeliveryCustomerDetailPageState();
}

class _DeliveryCustomerDetailPageState
    extends State<DeliveryCustomerDetailPage> {
  // ======================
  // Sender Details
  // ======================
  final senderNameController = TextEditingController();
  final senderPhoneController = TextEditingController();
  final senderEmailController = TextEditingController();
  final senderCompanyController = TextEditingController();
  bool senderBusiness = false;

  // ======================
  // Receiver Details
  // ======================
  final receiverNameController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final receiverEmailController = TextEditingController();

  // ======================
  // Legal Declaration
  // ======================
  bool legalConfirmed = false;

  // ======================
  // Special Notes
  // ======================
  final notesController = TextEditingController();

  @override
  void dispose() {
    senderNameController.dispose();
    senderPhoneController.dispose();
    senderEmailController.dispose();
    senderCompanyController.dispose();
    receiverNameController.dispose();
    receiverPhoneController.dispose();
    receiverEmailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  bool get canProceed =>
      senderNameController.text.isNotEmpty &&
      senderPhoneController.text.isNotEmpty &&
      receiverNameController.text.isNotEmpty &&
      receiverPhoneController.text.isNotEmpty &&
      legalConfirmed;

  void proceedToFinalReview() {
    if (!canProceed) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DeliveryFinalReviewPage(
          // Booking details
          pickupAddress: widget.pickupAddress,
          dropAddress: widget.dropAddress,
          vanType: widget.vanType,
          deliveryOption: widget.deliveryOption,
          fragile: widget.fragile,
          notes: widget.notes,
          totalMiles: widget.totalMiles,
          estimatedPrice: widget.estimatedPrice,
          deliveryTimeLabel: widget.deliveryTimeLabel,
         
          dropLatLng: widget.dropLatLng,
          // Cargo info
          cargoType: widget.cargoType,
          weight: widget.weight,
          pallets: widget.pallets,
          // Sender & Receiver
          senderName: senderNameController.text,
          senderPhone: senderPhoneController.text,
          senderEmail: senderEmailController.text.isEmpty
              ? "N/A"
              : senderEmailController.text,
          senderCompany: senderCompanyController.text.isEmpty
              ? "N/A"
              : senderCompanyController.text,
          senderBusiness: senderBusiness,
          receiverName: receiverNameController.text,
          receiverPhone: receiverPhoneController.text,
          receiverEmail: receiverEmailController.text.isEmpty
              ? "N/A"
              : receiverEmailController.text,
          // Legal + Notes
          legalConfirmed: legalConfirmed,
          customerNotes: notesController.text.isEmpty
              ? "None"
              : notesController.text,
             
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// ======================
            /// Cargo Summary (READ ONLY)
            /// ======================
            const Text("Cargo Summary", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            Text("Cargo Type: ${widget.cargoType}"),
            if (widget.cargoType == "Loose items") Text("Weight: ${widget.weight} kg"),
            if (widget.cargoType == "Pallets") Text("Number of Pallets: ${widget.pallets}"),
            Text("Fragile: ${widget.fragile ? "Yes" : "No"}"),
            const SizedBox(height: 20),

            /// ======================
            /// Sender Details
            /// ======================
            const Text("Sender Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            TextField(
              controller: senderNameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senderPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senderEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Address (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senderCompanyController,
              decoration: const InputDecoration(
                labelText: "Company Name (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: senderBusiness,
                  onChanged: (v) => setState(() => senderBusiness = v ?? false),
                ),
                const Text("Business Shipment"),
              ],
            ),
            const SizedBox(height: 20),

            /// ======================
            /// Receiver Details
            /// ======================
            const Text("Receiver Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            TextField(
              controller: receiverNameController,
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: receiverPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Mobile Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: receiverEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email Address (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            /// ======================
            /// Legal Declaration
            /// ======================
            const Text("Legal Declaration", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            const Text(
              "I confirm that this delivery complies with all laws and regulations. I accept full responsibility for the contents.",
              style: TextStyle(fontSize: 12),
            ),
            Row(
              children: [
                Checkbox(
                  value: legalConfirmed,
                  onChanged: (v) => setState(() => legalConfirmed = v ?? false),
                ),
                const Text("I agree"),
              ],
            ),
            const SizedBox(height: 20),

            /// ======================
            /// Optional Notes
            /// ======================
            const Text("Delivery Instructions (Optional)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 5),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Notes / Instructions",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),

            /// ======================
            /// Continue Button
            /// ======================
            ElevatedButton(
              onPressed: canProceed ? proceedToFinalReview : null,
              child: const Text("Continue to Final Review"),
            ),
          ],
        ),
      ),
    );
  }
}
