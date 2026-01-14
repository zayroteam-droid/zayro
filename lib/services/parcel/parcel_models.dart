class ParcelBooking {
  final String pickupAddress;
  final String dropAddress;
  final int weight;
  final bool fragile;
  final String deliveryType; // "Next Day" or "Express"
  final double estimatedPrice;

  ParcelBooking({
    required this.pickupAddress,
    required this.dropAddress,
    required this.weight,
    required this.fragile,
    required this.deliveryType,
    required this.estimatedPrice,
  });
}

class ParcelCustomerDetails {
  final String name;
  final String email;
  final String phone;

  ParcelCustomerDetails({
    required this.name,
    required this.email,
    required this.phone,
  });
}
