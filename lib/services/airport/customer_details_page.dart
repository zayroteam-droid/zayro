import 'package:flutter/material.dart';
import 'Airport_final_review_page.dart';

class CustomerDetailsPage extends StatefulWidget {
  final String pickupAddress;
  final String dropAddress;
  final DateTime date;
  final TimeOfDay time;
  final String vehicle;
  final double fare;

  const CustomerDetailsPage({
    super.key,
    required this.pickupAddress,
    required this.dropAddress,
    required this.date,
    required this.time,
    required this.vehicle,
    required this.fare,
  });

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passengersController = TextEditingController(text: "1");
  final luggageController = TextEditingController(text: "0");
  final notesController = TextEditingController();
  final emergencyContactController = TextEditingController();

  // Airport fields (added)
  final flightNumberController = TextEditingController();
  final airlineController = TextEditingController();
  final terminalController = TextEditingController();
  final arrivalTimeController = TextEditingController();

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
    emergencyContactController.dispose();
    flightNumberController.dispose();
    airlineController.dispose();
    terminalController.dispose();
    arrivalTimeController.dispose();
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
      "Pickup": widget.pickupAddress,
      "Drop": widget.dropAddress,
      "Date & Time":
          "${widget.date.day}/${widget.date.month}/${widget.date.year} ${widget.time.format(context)}",
      "Vehicle": widget.vehicle,
    };

    final serviceDetails = {
      "Name": nameController.text,
      "Contact": contactController.text,
      "Email": emailController.text,
      "Passengers": passengersController.text,
      "Luggage": luggageController.text,
      "Flight Number": flightNumberController.text,
      "Airline": airlineController.text,
      "Terminal": terminalController.text,
      "Arrival Time": arrivalTimeController.text,
      if (notesController.text.isNotEmpty)
        "Notes": notesController.text,
      if (emergencyContactController.text.isNotEmpty)
        "Emergency Contact": emergencyContactController.text,
    };

    final priceDetails = {
      "Total": "£${widget.fare.toStringAsFixed(2)}",
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AirportFinalReviewPage(
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
      appBar: AppBar(title: const Text("Passenger Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Personal Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty ? "Enter your name" : null,
              ),

              const SizedBox(height: 10),

              // UK Phone Number (updated)
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(
                  labelText: "UK Mobile Number",
                  hintText: "07XXXXXXXXX or +447XXXXXXXXX",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter mobile number";
                  }
                  final ukPhoneRegex =
                      RegExp(r'^(?:\+44|0)7\d{9}$');
                  if (!ukPhoneRegex.hasMatch(val)) {
                    return "Enter valid UK mobile number";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email (optional)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) {
                  if (val != null &&
                      val.isNotEmpty &&
                      !val.contains("@")) {
                    return "Enter valid email";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Passenger Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: passengersController,
                decoration: const InputDecoration(
                  labelText: "Number of Passengers",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || int.tryParse(val) == null
                        ? "Enter valid number"
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: luggageController,
                decoration: const InputDecoration(
                  labelText: "Number of Luggage",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (val) =>
                    val == null || int.tryParse(val) == null
                        ? "Enter valid number"
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: "Special Notes (optional)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 20),

              // Airport questions (added)
              const Text(
                "Flight Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: flightNumberController,
                decoration: const InputDecoration(
                  labelText: "Flight Number",
                  hintText: "e.g. BA2490",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty
                        ? "Enter flight number"
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: airlineController,
                decoration: const InputDecoration(
                  labelText: "Airline (optional)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: terminalController,
                decoration: const InputDecoration(
                  labelText: "Terminal",
                  hintText: "e.g. Terminal 3",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                    val == null || val.isEmpty
                        ? "Enter terminal"
                        : null,
              ),

              const SizedBox(height: 10),

              TextFormField(
                controller: arrivalTimeController,
                decoration: const InputDecoration(
                  labelText: "Flight Arrival Time (optional)",
                  hintText: "e.g. 18:45",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Emergency / Safety",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              TextFormField(
                controller: emergencyContactController,
                decoration: const InputDecoration(
                  labelText: "Emergency Contact (optional)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Checkbox(
                    value: termsAccepted,
                    onChanged: (v) =>
                        setState(() => termsAccepted = v ?? false),
                  ),
                  const Expanded(
                    child: Text("I accept the Terms & Conditions"),
                  ),
                ],
              ),

              Row(
                children: [
                  Checkbox(
                    value: privacyAccepted,
                    onChanged: (v) =>
                        setState(() => privacyAccepted = v ?? false),
                  ),
                  const Expanded(
                    child: Text("I accept the Privacy Policy"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: handleProceed,
                child: const Text("Review Booking"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
