import '../models/user.dart';
import '../models/booking.dart';

class DataService {
  static List<User> users = [];
  static List<Booking> bookings = [];

  // Null-safe login
  static User? login(String username, String password) {
    try {
      return users.firstWhere(
            (u) => u.username == username && u.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Add a new booking (do not add points yet)
  static void addBooking(String service, User user, String date, String timeSlot, double price, double discountApplied) {
    int earnedPoints = ((price - discountApplied) * 0.1).toInt();
    Booking booking = Booking(
      service: service, 
      customerName: user.username,
      date: date,
      timeSlot: timeSlot,
      price: price,
      discountApplied: discountApplied,
      points: earnedPoints < 1 ? 1 : earnedPoints, // At least 1 point
    );
    bookings.add(booking);
  }

  static List<String> getAvailableSlots(String date) {
    final allSlots = ["09:00 AM", "10:00 AM", "11:00 AM", "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM"];
    final bookedSlots = bookings
        .where((b) => b.date == date && b.status != "cancelled")
        .map((b) => b.timeSlot)
        .toList();
    return allSlots.where((slot) {
      int count = bookedSlots.where((s) => s == slot).length;
      return count < 2;
    }).toList();
  }

  // Cancel a booking
  static void cancelBooking(int index) {
    Booking booking = bookings[index];

    // Deduct points only if it was already done
    if (booking.status == "done") {
      User? user =
      users.firstWhere((u) => u.username == booking.customerName);
      user.loyaltyPoints -= booking.points;
    }

    booking.status = "cancelled"; // Instead of removing, mark as cancelled for history tracking (optional, but better for real world)
    // bookings.removeAt(index);
  }

  // Mark a booking as done and add points
  static void markBookingDone(int index) {
    Booking booking = bookings[index];
    if (booking.status != "done") {
      booking.status = "done";

      // Add points to the customer now
      User? user =
      users.firstWhere((u) => u.username == booking.customerName);
      user.loyaltyPoints += booking.points;
    }
  }

  // Get customer active bookings
  static List<Booking> getCustomerBookings(String username) {
    return bookings
        .where((b) => b.customerName == username && b.status == "pending")
        .toList();
  }

  // Get customer history
  static List<Booking> getCustomerHistory(String username) {
    return bookings
        .where((b) => b.customerName == username && (b.status == "done" || b.status == "cancelled"))
        .toList();
  }

  // Get admin active bookings
  static List<Booking> getAdminActiveBookings() {
    return bookings.where((b) => b.status == "pending").toList();
  }

  // Get admin history (all done bookings)
  static List<Booking> getAdminHistory() {
    return bookings.where((b) => b.status == "done" || b.status == "cancelled").toList();
  }

  // Assign a barber to a booking
  static void assignBarber(int index, String barberName) {
    bookings[index].barberName = barberName;
  }

  // Get barber active bookings
  static List<Booking> getBarberActiveBookings(String barberName) {
    return bookings.where((b) => b.status == "pending" && b.barberName == barberName).toList();
  }

  // Get barber history
  static List<Booking> getBarberHistory(String barberName) {
    return bookings.where((b) => b.status == "done" && b.barberName == barberName).toList();
  }
}