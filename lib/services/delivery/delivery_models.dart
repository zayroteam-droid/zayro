class DeliveryBooking {
  final String pickupAddress;
  final String dropAddress;
  final String vanType; // "Small", "Medium", "Large"
  final String deliveryOption; // "Standard", "Express"
  final bool fragile;
  final double estimatedPrice;
  final String notes;

  DeliveryBooking({
    required this.pickupAddress,
    required this.dropAddress,
    required this.vanType,
    required this.deliveryOption,
    required this.fragile,
    required this.estimatedPrice,
    required this.notes,
  });
}

class DeliveryCustomerDetails {
  final String name;
  final String email;
  final String phone;

  DeliveryCustomerDetails({
    required this.name,
    required this.email,
    required this.phone,
  });
}
