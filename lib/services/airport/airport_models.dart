class AirportBooking {
  final String pickupAddress;
  final String dropAddress;
  final String flightNumber;
  final int passengers;
  final double estimatedPrice;

  AirportBooking({
    required this.pickupAddress,
    required this.dropAddress,
    required this.flightNumber,
    required this.passengers,
    required this.estimatedPrice,
  });
}

class AirportCustomerDetails {
  final String name;
  final String email;
  final String phone;

  AirportCustomerDetails({
    required this.name,
    required this.email,
    required this.phone,
  });
}
