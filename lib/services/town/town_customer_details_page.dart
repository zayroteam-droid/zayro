import 'package:flutter/material.dart';
import 'town_final_review_page.dart';

class TownCustomerDetailsPage extends StatefulWidget {
  final String pickupAddress;
  final String dropAddress;
  final DateTime date;
  final TimeOfDay time;
  final String vehicle;
  final double fare;

  const TownCustomerDetailsPage({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.date,
    required this.time,
    required this.vehicle,
    required this.fare,
  });

  @override
  State<TownCustomerDetailsPage> createState() => _TownCustomerDetailsPageState();
}

class _TownCustomerDetailsPageState extends State<TownCustomerDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passengersController = TextEditingController(text: "1");
  final luggageController = TextEditingController();
  final notesController = TextEditingController();
  final hotelController = TextEditingController();
  final emergencyContactController = TextEditingController();

  // Legal checkboxes
  bool termsAccepted = false;
  bool privacyAccepted = false;

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    passengersController.dispose();
    luggageController.dispose();
    notesController.dispose();
    hotelController.dispose();
    emergencyContactController.dispose();
    super.dispose();
  }

  void handleProceed() {
    if (_formKey.currentState!.validate()) {
      if (!termsAccepted || !privacyAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please accept Terms & Privacy Policy")),
        );
        return;
      }

      final journeySummary = {
        "Pickup Address": widget.pickupAddress,
        "Drop Address": widget.dropAddress,
        "Date & Time": "${widget.date.day}/${widget.date.month}/${widget.date.year} • ${widget.time.format(context)}",
        "Vehicle": widget.vehicle,
        "Fare": "£${widget.fare.toStringAsFixed(2)}",
      };

      final serviceDetails = {
        "Name": nameController.text,
        "Contact": contactController.text,
        "Email": emailController.text,
        "Passengers": passengersController.text,
        "Luggage": luggageController.text,
        "Hotel": hotelController.text,
        "Notes": notesController.text,
        "Emergency Contact": emergencyContactController.text,
      };

      final priceDetails = {
        "Total": "£${widget.fare.toStringAsFixed(2)}",
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TownFinalReviewPage(
            journeySummary: journeySummary,
            serviceDetails: serviceDetails,
            priceDetails: priceDetails,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Passenger Details - Town Ride")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Personal Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(nameController, "Full Name", validator: (val) => val == null || val.isEmpty ? "Enter your name" : null),
              const SizedBox(height: 10),
              _buildTextField(contactController, "Contact Number", keyboard: TextInputType.phone, validator: (val) => val == null || val.length < 10 ? "Enter valid contact number" : null),
              const SizedBox(height: 10),
              _buildTextField(emailController, "Email (optional)", keyboard: TextInputType.emailAddress, validator: (val) {
                if (val != null && val.isNotEmpty && !val.contains("@")) return "Enter valid email";
                return null;
              }),
              const SizedBox(height: 20),

              const Text("Passenger Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(passengersController, "Number of Passengers", keyboard: TextInputType.number, validator: (val) => val == null || int.tryParse(val) == null ? "Enter valid number" : null),
              const SizedBox(height: 10),
              _buildTextField(luggageController, "Number of Luggage (optional)", keyboard: TextInputType.number),
              const SizedBox(height: 10),
              _buildTextField(hotelController, "Hotel Name (optional)"),
              const SizedBox(height: 10),
              _buildTextField(notesController, "Special Notes (optional)", maxLines: 2),
              const SizedBox(height: 20),

              const Text("Emergency / Safety", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(emergencyContactController, "Emergency Contact (optional)"),
              const SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(value: termsAccepted, onChanged: (v) => setState(() => termsAccepted = v ?? false)),
                  const Expanded(child: Text("I accept the Terms & Conditions")),
                ],
              ),
              Row(
                children: [
                  Checkbox(value: privacyAccepted, onChanged: (v) => setState(() => privacyAccepted = v ?? false)),
                  const Expanded(child: Text("I accept the Privacy Policy")),
                ],
              ),
              const SizedBox(height: 20),

              ElevatedButton(onPressed: handleProceed, child: const Text("Review Booking")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
          {TextInputType keyboard = TextInputType.text, int maxLines = 1, String? Function(String?)? validator}) =>
      TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: validator,
      );
}
