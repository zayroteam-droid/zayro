class TownRideBooking {
  String pickup;
  String drop;
  DateTime dateTime;
  int passengers;
  double? estimatedPrice;

  TownRideBooking({
    required this.pickup,
    required this.drop,
    required this.dateTime,
    required this.passengers,
    this.estimatedPrice,
  });
}
