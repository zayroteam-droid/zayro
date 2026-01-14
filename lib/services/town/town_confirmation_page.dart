import 'package:flutter/material.dart';
import '../../services/town/town_customer_details_page.dart';

class BookingConfirmationPage extends StatelessWidget {
  final String pickupAddress;
  final String dropAddress;
  final DateTime date;
  final TimeOfDay time;
  final String vehicle;
  final double fare;

  const BookingConfirmationPage({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.date,
    required this.time,
    required this.vehicle,
    required this.fare,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Booking Confirmation")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Pickup: $pickupAddress"),
            Text("Drop: $dropAddress"),
            Text("Date: ${date.day}/${date.month}/${date.year}"),
            Text("Time: ${time.format(context)}"),
            Text("Vehicle: $vehicle"),
            Text("Fare: £${fare.toStringAsFixed(2)}"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Customer Details Page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TownCustomerDetailsPage(
                      pickupAddress: pickupAddress,
                      dropAddress: dropAddress,
                      date: date,
                      time: time,
                      vehicle: vehicle,
                      fare: fare,
                    ),
                  ),
                );
              },
              child: const Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
