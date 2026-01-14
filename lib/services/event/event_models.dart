class EventBooking {
  final String pickupAddress;
  final List<String> dropAddresses;
  final String tripType;
  final DateTime dateTime;
  final int durationHours;
  final String vehicleType;
  final double estimatedPrice;
  final String notes;

  EventBooking({
    required this.pickupAddress,
    required this.dropAddresses,
    required this.tripType,
    required this.dateTime,
    required this.durationHours,
    required this.vehicleType,
    required this.estimatedPrice,
    required this.notes,
  });
}

class EventCustomerDetails {
  final String name;
  final String email;
  final String phone;
  final String? eventName; // optional

  EventCustomerDetails({
    required this.name,
    required this.email,
    required this.phone,
    this.eventName,
  });
}
