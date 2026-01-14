import 'package:flutter/material.dart';
import '../../booking/payment_page.dart';

class CourierFinalReviewPage extends StatefulWidget {
  final Map<String, String> journeySummary;
  final Map<String, String> serviceDetails;
  final Map<String, String> priceDetails;

  const CourierFinalReviewPage({
    super.key,
    required this.journeySummary,
    required this.serviceDetails,
    required this.priceDetails,
  });

  @override
  State<CourierFinalReviewPage> createState() => _CourierFinalReviewPageState();
}

class _CourierFinalReviewPageState extends State<CourierFinalReviewPage> {
  bool confirmDetails = false;
  bool acceptResponsibility = false;
  bool legalDeclaration = false;

  bool get canContinue =>
      confirmDetails && acceptResponsibility && legalDeclaration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Courier Final Review & Confirmation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Please review your courier booking details carefully before proceeding.",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _sectionTitle("Journey Summary"),
            ...widget.journeySummary.entries
                .map((e) => _infoRow(e.key, e.value)),
            const SizedBox(height: 20),

            _sectionTitle("Courier Details"),
            ...widget.serviceDetails.entries
                .map((e) => _infoRow(e.key, e.value)),
            const SizedBox(height: 20),

            _sectionTitle("Price Summary"),
            ...widget.priceDetails.entries.map(
              (e) => _infoRow(
                e.key,
                e.value,
                isBold: e.key.toLowerCase() == "total",
              ),
            ),
            const SizedBox(height: 30),

            _sectionTitle("Confirmation & Declarations"),
            _checkboxTile(
              value: confirmDetails,
              onChanged: (v) =>
                  setState(() => confirmDetails = v ?? false),
              text:
                  "I confirm that all courier booking details shown above are accurate.",
            ),
            _checkboxTile(
              value: acceptResponsibility,
              onChanged: (v) =>
                  setState(() => acceptResponsibility = v ?? false),
              text:
                  "I accept responsibility for providing accurate parcel information.",
            ),
            _checkboxTile(
              value: legalDeclaration,
              onChanged: (v) =>
                  setState(() => legalDeclaration = v ?? false),
              text:
                  "I confirm this courier booking complies with all laws and regulations.",
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
                              serviceType: "Courier",
                              journeySummary: widget.journeySummary,
                              serviceDetails: widget.serviceDetails,
                              priceDetails: widget.priceDetails,
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

  /// ======================
  /// Helpers (IDENTICAL)
  /// ======================

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

  Widget _infoRow(
    String label,
    String value, {
    bool isBold = false,
  }) =>
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
                style: TextStyle(
                  fontWeight:
                      isBold ? FontWeight.bold : FontWeight.normal,
                ),
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
