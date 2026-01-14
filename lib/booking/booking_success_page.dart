import 'package:flutter/material.dart';
import '../services/event/event_models.dart';
import '../services/parcel/parcel_models.dart';
import '../services/delivery/delivery_models.dart';
import '../services/airport/airport_models.dart';
import '../widgets/primary_button.dart';

class BookingSuccessPage extends StatelessWidget {
  final String serviceType;
  final dynamic booking;
  final dynamic customer;

  const BookingSuccessPage({
    super.key,
    required this.serviceType,
    required this.booking,
    required this.customer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$serviceType Booking Complete")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Booking Confirmed!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your booking details are below. Please keep this page for your reference.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // -----------------------------
            // Booking Summary
            // -----------------------------
            _sectionTitle("Booking Summary"),
            ..._renderBookingSummary(booking),

            const SizedBox(height: 20),

            // -----------------------------
            // Customer Info
            // -----------------------------
            _sectionTitle("Customer Info"),
            Text("Name: ${customer.name}"),
            Text("Email: ${customer.email}"),
            Text("Phone: ${customer.phone}"),
            if (customer is EventCustomerDetails &&
                customer.eventName != null &&
                customer.eventName!.isNotEmpty)
              Text("Event / Hotel: ${customer.eventName}"),

            const SizedBox(height: 30),

            PrimaryButton(
              text: "Back to Home",
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }

  /// -----------------------------
  /// Render Booking Summary dynamically
  /// -----------------------------
  List<Widget> _renderBookingSummary(dynamic b) {
    List<Widget> widgets = [];

    if (b is EventBooking) {
      widgets.add(Text("Pickup: ${b.pickupAddress}"));
      for (var i = 0; i < b.dropAddresses.length; i++) {
        widgets.add(Text("Drop ${i + 1}: ${b.dropAddresses[i]}"));
      }
      widgets.add(Text("Trip Type: ${b.tripType}"));
      widgets.add(Text(
          "Date & Time: ${b.dateTime.day}/${b.dateTime.month}/${b.dateTime.year} ${b.dateTime.hour.toString().padLeft(2, '0')}:${b.dateTime.minute.toString().padLeft(2, '0')}"));
      widgets.add(Text("Duration: ${b.durationHours} hours"));
      widgets.add(Text("Vehicle: ${b.vehicleType}"));
      widgets.add(Text("Price Paid: £${b.estimatedPrice.toStringAsFixed(2)}"));
      if (b.notes.isNotEmpty) widgets.add(Text("Notes: ${b.notes}"));
    } else if (b is ParcelBooking) {
      widgets.add(Text("Pickup: ${b.pickupAddress}"));
      widgets.add(Text("Drop: ${b.dropAddress}"));
      widgets.add(Text("Weight: ${b.weight} kg"));
      widgets.add(Text("Fragile: ${b.fragile ? "Yes" : "No"}"));
      widgets.add(Text("Delivery Type: ${b.deliveryType}"));
      widgets.add(Text("Price Paid: £${b.estimatedPrice.toStringAsFixed(2)}"));
    } else if (b is DeliveryBooking) {
      widgets.add(Text("Pickup: ${b.pickupAddress}"));
      widgets.add(Text("Drop: ${b.dropAddress}"));
      widgets.add(Text("Van Type: ${b.vanType}"));
      widgets.add(Text("Delivery Option: ${b.deliveryOption}"));
      widgets.add(Text("Fragile: ${b.fragile ? "Yes" : "No"}"));
      widgets.add(Text("Price Paid: £${b.estimatedPrice.toStringAsFixed(2)}"));
    } else if (b is AirportBooking) {
      widgets.add(Text("Pickup: ${b.pickupAddress}"));
      widgets.add(Text("Drop: ${b.dropAddress}"));
      widgets.add(Text("Flight: ${b.flightNumber}"));
      widgets.add(Text("Passengers: ${b.passengers}"));
      widgets.add(Text("Price Paid: £${b.estimatedPrice.toStringAsFixed(2)}"));
    }

    return widgets;
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}
