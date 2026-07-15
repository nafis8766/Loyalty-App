class Booking {
  String service;
  String customerName;
  String date;
  String timeSlot;
  String status; // pending, done, cancelled
  int points;
  double price;
  double discountApplied;
  String? barberName;

  Booking({
    required this.service,
    required this.customerName,
    required this.date,
    required this.timeSlot,
    this.status = "pending",
    this.points = 10, // default points per service
    required this.price,
    this.discountApplied = 0.0,
    this.barberName,
  });
}