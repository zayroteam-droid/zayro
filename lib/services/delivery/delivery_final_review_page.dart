import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../booking/payment_page.dart';

class DeliveryFinalReviewPage extends StatefulWidget {
  // ======================
  // Full data from Customer Detail Page
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

  // Cargo info
  final String cargoType;
  final int weight;
  final int pallets;

  // Customer details
  final String senderName;
  final String senderPhone;
  final String senderEmail;
  final String senderCompany;
  final bool senderBusiness;

  final String receiverName;
  final String receiverPhone;
  final String receiverEmail;

  final bool legalConfirmed;
  final String customerNotes;

  
  final LatLng dropLatLng;

  const DeliveryFinalReviewPage({
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
    required this.cargoType,
    required this.weight,
    required this.pallets,
    required this.senderName,
    required this.senderPhone,
    required this.senderEmail,
    required this.senderCompany,
    required this.senderBusiness,
    required this.receiverName,
    required this.receiverPhone,
    required this.receiverEmail,
    required this.legalConfirmed,
    required this.customerNotes,
   
    required this.dropLatLng,   // ✅ Added
  });

  @override
  State<DeliveryFinalReviewPage> createState() =>
      _DeliveryFinalReviewPageState();
}

class _DeliveryFinalReviewPageState extends State<DeliveryFinalReviewPage> {
  bool confirmDetails = false;
  bool acceptResponsibility = false;
  bool legalDeclaration = false;

  bool get canContinue =>
      confirmDetails && acceptResponsibility && legalDeclaration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Delivery Final Review & Confirmation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please review your delivery booking details carefully before proceeding.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _sectionTitle("Journey Summary"),
            _infoRow("Pickup Address", widget.pickupAddress),
            _infoRow("Drop Address", widget.dropAddress),
            _infoRow("Van Type", widget.vanType),
            _infoRow("Delivery Option", widget.deliveryOption),
            _infoRow("Delivery Time", widget.deliveryTimeLabel),
            const SizedBox(height: 20),

            _sectionTitle("Cargo Details"),
            _infoRow("Cargo Type", widget.cargoType),
            if (widget.cargoType == "Loose items")
              _infoRow("Weight", "${widget.weight} kg"),
            if (widget.cargoType == "Pallets")
              _infoRow("Pallets", widget.pallets.toString()),
            _infoRow("Fragile", widget.fragile ? "Yes" : "No"),
            _infoRow("Notes", widget.notes.isNotEmpty ? widget.notes : "-"),
            const SizedBox(height: 20),

            _sectionTitle("Sender Details"),
            _infoRow("Name", widget.senderName),
            _infoRow("Phone", widget.senderPhone),
            _infoRow("Email", widget.senderEmail),
            _infoRow("Company", widget.senderCompany),
            _infoRow("Business Shipment", widget.senderBusiness ? "Yes" : "No"),
            const SizedBox(height: 20),

            _sectionTitle("Receiver Details"),
            _infoRow("Name", widget.receiverName),
            _infoRow("Phone", widget.receiverPhone),
            _infoRow("Email", widget.receiverEmail),
            const SizedBox(height: 20),

            _sectionTitle("Price & Distance"),
            _infoRow("Distance", "${widget.totalMiles.toStringAsFixed(2)} miles"),
            _infoRow("Estimated Price", "£${widget.estimatedPrice.toStringAsFixed(2)}"),
            const SizedBox(height: 20),

            _sectionTitle("Confirmation & Declarations"),
            _checkboxTile(
              value: confirmDetails,
              onChanged: (v) => setState(() => confirmDetails = v ?? false),
              text: "I confirm that all delivery booking details shown above are accurate.",
            ),
            _checkboxTile(
              value: acceptResponsibility,
              onChanged: (v) => setState(() => acceptResponsibility = v ?? false),
              text: "I accept responsibility for providing accurate delivery information.",
            ),
            _checkboxTile(
              value: legalDeclaration,
              onChanged: (v) => setState(() => legalDeclaration = v ?? false),
              text: "I confirm this delivery booking complies with all laws and regulations.",
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canContinue
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentPage(
                              serviceType: "Delivery",
                              journeySummary: {
                                "Pickup": widget.pickupAddress,
                                "Drop": widget.dropAddress,
                                "Van Type": widget.vanType,
                                "Delivery Option": widget.deliveryOption,
                                "Delivery Time": widget.deliveryTimeLabel,
                              },
                              serviceDetails: {
                                "Cargo Type": widget.cargoType,
                                "Weight": widget.weight.toString(),
                                "Pallets": widget.pallets.toString(),
                                "Fragile": widget.fragile ? "Yes" : "No",
                                "Notes": widget.notes.isNotEmpty ? widget.notes : "-",
                                "Sender Name": widget.senderName,
                                "Sender Phone": widget.senderPhone,
                                "Sender Email": widget.senderEmail,
                                "Sender Company": widget.senderCompany,
                                "Business Shipment": widget.senderBusiness ? "Yes" : "No",
                                "Receiver Name": widget.receiverName,
                                "Receiver Phone": widget.receiverPhone,
                                "Receiver Email": widget.receiverEmail,
                                "Legal Confirmed": widget.legalConfirmed ? "Yes" : "No",
                                "Customer Notes": widget.customerNotes,
                              },
                              priceDetails: {
                                "Distance": "${widget.totalMiles.toStringAsFixed(2)} miles",
                                "Estimated Price": "£${widget.estimatedPrice.toStringAsFixed(2)}",
                              },
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text("Confirm & Continue to Payment"),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                "You will not be charged until payment is completed.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _infoRow(String label, String value, {bool isBold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(
                "$label:",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          ],
        ),
      );

  Widget _checkboxTile({
    required bool value,
    required Function(bool?) onChanged,
    required String text,
  }) =>
      CheckboxListTile(
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(text),
      );
}
