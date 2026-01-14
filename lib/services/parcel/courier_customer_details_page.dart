import 'package:flutter/material.dart';
import 'courier_final_review_page.dart';

class CourierCustomerDetailsPage extends StatefulWidget {
  /// DATA FROM PREVIOUS PAGE (ParcelPickupPage)
  final Map<String, String> journeySummary;
  final Map<String, String> serviceDetails;
  final Map<String, String> priceDetails;

  const CourierCustomerDetailsPage({
    super.key,
    required this.journeySummary,
    required this.serviceDetails,
    required this.priceDetails,
  });

  @override
  State<CourierCustomerDetailsPage> createState() =>
      _CourierCustomerDetailsPageState();
}

class _CourierCustomerDetailsPageState
    extends State<CourierCustomerDetailsPage> {
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
  // Parcel Description
  // ======================
  final parcelDescController = TextEditingController();
  bool perishable = false;
  bool liquid = false;

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
    parcelDescController.dispose();
    notesController.dispose();
    super.dispose();
  }

  bool get canProceed =>
      senderNameController.text.isNotEmpty &&
      senderPhoneController.text.isNotEmpty &&
      receiverNameController.text.isNotEmpty &&
      receiverPhoneController.text.isNotEmpty &&
      parcelDescController.text.isNotEmpty &&
      legalConfirmed;

  /// ======================
  /// NAVIGATION (EDITED)
  /// ======================
  void proceedToFinalReview() {
    if (!canProceed) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CourierFinalReviewPage(
          journeySummary: {
            ...widget.journeySummary,
            "Sender": senderNameController.text,
            "Receiver": receiverNameController.text,
          },
          serviceDetails: {
            ...widget.serviceDetails,
            "Sender Phone": senderPhoneController.text,
            "Receiver Phone": receiverPhoneController.text,
            "Sender Email": senderEmailController.text.isEmpty
                ? "N/A"
                : senderEmailController.text,
            "Receiver Email": receiverEmailController.text.isEmpty
                ? "N/A"
                : receiverEmailController.text,
            "Business Shipment": senderBusiness ? "Yes" : "No",
            "Parcel Description": parcelDescController.text,
            "Perishable": perishable ? "Yes" : "No",
            "Liquid": liquid ? "Yes" : "No",
            "Notes":
                notesController.text.isEmpty ? "None" : notesController.text,
          },
          priceDetails: widget.priceDetails,
        ),
      ),
    );
  }

  /// ======================
  /// UI
  /// ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Courier Customer Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ======================
            // Sender Details
            // ======================
            const SectionTitle("Sender Details"),
            const SizedBox(height: 10),
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
                  onChanged: (v) =>
                      setState(() => senderBusiness = v ?? false),
                ),
                const Text("Business Shipment"),
              ],
            ),
            const SizedBox(height: 20),

            // ======================
            // Receiver Details
            // ======================
            const SectionTitle("Receiver Details"),
            const SizedBox(height: 10),
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

            // ======================
            // Parcel Description
            // ======================
            const SectionTitle("Parcel Description"),
            const SizedBox(height: 10),
            TextField(
              controller: parcelDescController,
              decoration: const InputDecoration(
                labelText: "Description of Contents",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: perishable,
                  onChanged: (v) =>
                      setState(() => perishable = v ?? false),
                ),
                const Text("Perishable"),
                const SizedBox(width: 20),
                Checkbox(
                  value: liquid,
                  onChanged: (v) =>
                      setState(() => liquid = v ?? false),
                ),
                const Text("Liquid"),
              ],
            ),
            const SizedBox(height: 20),

            // ======================
            // Legal Declaration
            // ======================
            const SectionTitle("Legal Declaration"),
            const SizedBox(height: 10),
            const Text(
              "I confirm this parcel does NOT contain illegal, dangerous, or prohibited items. I accept full responsibility for the contents.",
              style: TextStyle(fontSize: 12),
            ),
            Row(
              children: [
                Checkbox(
                  value: legalConfirmed,
                  onChanged: (v) =>
                      setState(() => legalConfirmed = v ?? false),
                ),
                const Text("I agree"),
              ],
            ),
            const SizedBox(height: 20),

            // ======================
            // Notes
            // ======================
            const SectionTitle("Delivery Instructions (Optional)"),
            const SizedBox(height: 10),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Notes / Instructions",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),

            // ======================
            // Proceed
            // ======================
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

/// ======================
/// Section Title
/// ======================
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      );
}
