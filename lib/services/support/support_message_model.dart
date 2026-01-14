class SupportMessage {
  final String text;
  final bool isSent; // true = customer, false = support
  final DateTime timestamp;

  SupportMessage({
    required this.text,
    required this.isSent,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}
