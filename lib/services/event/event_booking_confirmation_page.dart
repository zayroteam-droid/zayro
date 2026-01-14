import 'package:flutter/material.dart';
import 'event_customer_detail_page.dart';

class EventBookingConfirmationPage extends StatelessWidget {
  final String pickup;
  final String drop;
  final String bus;
  final DateTime date;
  final TimeOfDay time;
  final double fare;

  const EventBookingConfirmationPage({
    super.key,
    required this.pickup,
    required this.drop,
    required this.bus,
    required this.date,
    required this.time,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Booking Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Please review your booking details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            _info("Pickup", pickup),
            _info("Drop", drop),
            _info("Vehicle", bus),
            _info("Date", "${date.day}/${date.month}/${date.year}"),
            _info("Time", time.format(context)),
            _info("Estimated Fare", "£${fare.toStringAsFixed(2)}"),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "⚠ Fare is estimated.\n"
                "Extra waiting time or route changes may affect final price.\n"
                "Overtime will be charged at £0.50/min.",
                style: TextStyle(fontSize: 13),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text("Continue"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EventCustomerDetailPage(
                        pickup: pickup,
                        drop: drop,
                        bus: bus,
                        date: date,
                        time: time,
                        fare: fare,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _info(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(
                "$title:",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(child: Text(value)),
          ],
        ),
      );
}
