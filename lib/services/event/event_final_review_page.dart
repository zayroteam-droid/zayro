import 'package:flutter/material.dart';
import '../../booking/payment_page.dart';

class EventFinalReviewPage extends StatefulWidget {
  final String pickup;
  final String drop;
  final String bus;
  final DateTime date;
  final TimeOfDay time;
  final double fare;

  // Customer Details
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

  const EventFinalReviewPage({
    super.key,
    required this.pickup,
    required this.drop,
    required this.bus,
    required this.date,
    required this.time,
    required this.fare,
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
  });

  @override
  State<EventFinalReviewPage> createState() => _EventFinalReviewPageState();
}

class _EventFinalReviewPageState extends State<EventFinalReviewPage> {
  bool confirmDetails = false;
  bool acceptResponsibility = false;
  bool legalDeclaration = false;

  bool get canContinue =>
      confirmDetails && acceptResponsibility && legalDeclaration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Booking Final Review")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please review your event booking details carefully before proceeding.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _sectionTitle("Journey Summary"),
            _infoRow("Pickup Address", widget.pickup),
            _infoRow("Drop Address", widget.drop),
            _infoRow("Bus Type", widget.bus),
            _infoRow("Date", "${widget.date.day}/${widget.date.month}/${widget.date.year}"),
            _infoRow("Time", widget.time.format(context)),
            const SizedBox(height: 20),

            _sectionTitle("Fare Estimate"),
            _infoRow("Total Fare", "£${widget.fare.toStringAsFixed(2)}"),
            const SizedBox(height: 20),

            _sectionTitle("Sender Details"),
            _infoRow("Name", widget.senderName),
            _infoRow("Phone", widget.senderPhone),
            _infoRow("Email", widget.senderEmail),
            _infoRow("Company", widget.senderCompany),
            _infoRow("Business Booking", widget.senderBusiness ? "Yes" : "No"),
            const SizedBox(height: 20),

            _sectionTitle("Receiver Details"),
            _infoRow("Name", widget.receiverName),
            _infoRow("Phone", widget.receiverPhone),
            _infoRow("Email", widget.receiverEmail),
            const SizedBox(height: 20),

            _sectionTitle("Additional Notes"),
            Text(widget.customerNotes.isNotEmpty ? widget.customerNotes : "-", style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 20),

            _sectionTitle("Confirmation & Declarations"),
            _checkboxTile(
              value: confirmDetails,
              onChanged: (v) => setState(() => confirmDetails = v ?? false),
              text: "I confirm that all booking details shown above are accurate.",
            ),
            _checkboxTile(
              value: acceptResponsibility,
              onChanged: (v) => setState(() => acceptResponsibility = v ?? false),
              text: "I accept responsibility for providing accurate booking information.",
            ),
            _checkboxTile(
              value: legalDeclaration,
              onChanged: (v) => setState(() => legalDeclaration = v ?? false),
              text: "I confirm this booking complies with all laws and regulations.",
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
                              serviceType: "Event Booking",
                              journeySummary: {
                                "Pickup": widget.pickup,
                                "Drop": widget.drop,
                                "Bus Type": widget.bus,
                                "Date": "${widget.date.day}/${widget.date.month}/${widget.date.year}",
                                "Time": widget.time.format(context),
                              },
                              serviceDetails: {
                                "Sender Name": widget.senderName,
                                "Sender Phone": widget.senderPhone,
                                "Sender Email": widget.senderEmail,
                                "Sender Company": widget.senderCompany,
                                "Business Booking": widget.senderBusiness ? "Yes" : "No",
                                "Receiver Name": widget.receiverName,
                                "Receiver Phone": widget.receiverPhone,
                                "Receiver Email": widget.receiverEmail,
                                "Customer Notes": widget.customerNotes.isNotEmpty ? widget.customerNotes : "-",
                                "Legal Confirmed": widget.legalConfirmed ? "Yes" : "No",
                              },
                              priceDetails: {
                                "Fare": "£${widget.fare.toStringAsFixed(2)}",
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
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
