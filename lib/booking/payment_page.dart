import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final String serviceType;
  final Map<String, String> journeySummary;
  final Map<String, String> serviceDetails;
  final Map<String, String> priceDetails;

  const PaymentPage({
    super.key,
    required this.serviceType,
    required this.journeySummary,
    required this.serviceDetails,
    required this.priceDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$serviceType Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Payment Page"),
            const SizedBox(height: 20),
            Text("Journey Summary: ${journeySummary.toString()}"),
            const SizedBox(height: 10),
            Text("Service Details: ${serviceDetails.toString()}"),
            const SizedBox(height: 10),
            Text("Price Details: ${priceDetails.toString()}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: integrate actual payment here
              },
              child: const Text("Pay Now"),
            )
          ],
        ),
      ),
    );
  }
}
