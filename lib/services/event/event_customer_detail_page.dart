import 'package:flutter/material.dart';
import 'event_final_review_page.dart';

class EventCustomerDetailPage extends StatefulWidget {
  final String pickup;
  final String drop;
  final String bus;
  final DateTime date;
  final TimeOfDay time;
  final double fare;

  const EventCustomerDetailPage({
    super.key,
    required this.pickup,
    required this.drop,
    required this.bus,
    required this.date,
    required this.time,
    required this.fare,
  });

  @override
  State<EventCustomerDetailPage> createState() =>
      _EventCustomerDetailPageState();
}

class _EventCustomerDetailPageState extends State<EventCustomerDetailPage> {
  // Sender Details
  final senderNameController = TextEditingController();
  final senderPhoneController = TextEditingController();
  final senderEmailController = TextEditingController();
  final senderCompanyController = TextEditingController();
  bool senderBusiness = false;

  // Receiver Details
  final receiverNameController = TextEditingController();
  final receiverPhoneController = TextEditingController();
  final receiverEmailController = TextEditingController();

  // Legal Declaration
  bool legalConfirmed = false;

  // Customer Notes
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
        builder: (_) => EventFinalReviewPage(
          pickup: widget.pickup,
          drop: widget.drop,
          bus: widget.bus,
          date: widget.date,
          time: widget.time,
          fare: widget.fare,
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
            const Text(
              "Sender Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senderNameController,
              decoration: const InputDecoration(
                  labelText: "Full Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senderPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: "Mobile Number", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senderEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: "Email (Optional)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: senderCompanyController,
              decoration: const InputDecoration(
                  labelText: "Company (Optional)", border: OutlineInputBorder()),
            ),
            Row(
              children: [
                Checkbox(
                    value: senderBusiness,
                    onChanged: (v) => setState(() => senderBusiness = v ?? false)),
                const Text("Business Booking"),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Receiver Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: receiverNameController,
              decoration: const InputDecoration(
                  labelText: "Full Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: receiverPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  labelText: "Mobile Number", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: receiverEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: "Email (Optional)", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),

            const Text(
              "Legal Declaration",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Row(
              children: [
                Checkbox(
                    value: legalConfirmed,
                    onChanged: (v) => setState(() => legalConfirmed = v ?? false)),
                const Expanded(
                    child: Text(
                        "I confirm that this booking complies with all laws and regulations.")),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              "Additional Notes / Instructions (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: "Notes", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),

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
