import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/data_service.dart';
import 'booking_screen.dart';
import '../models/booking.dart';

class CustomerDashboard extends StatefulWidget {
  final User user;

  CustomerDashboard({required this.user});

  @override
  _CustomerDashboardState createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showInvoice(Booking booking) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Invoice - ${booking.service}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Salon Loyalty App", style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(),
            Text("Date: ${booking.date} at ${booking.timeSlot}"),
            Text("Customer: ${booking.customerName}"),
            Text("Service Price: \$${booking.price.toStringAsFixed(2)}"),
            Text("Discount Applied: -\$${booking.discountApplied.toStringAsFixed(2)}"),
            Divider(),
            Text("Paid: \$${(booking.price - booking.discountApplied).toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("Points Earned: ${booking.points}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          )
        ],
      ),
    );
  }

  Widget _buildHome() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            color: Colors.pink.shade100,
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Text("Loyalty Points", style: TextStyle(fontSize: 20)),
                  Text(
                    "${widget.user.loyaltyPoints}",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text("Book New Service"),
            style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingScreen(user: widget.user)),
              );
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Widget _buildBookings() {
    var bookings = DataService.getCustomerBookings(widget.user.username);
    if (bookings.isEmpty) return Center(child: Text("No active bookings."));
    return ListView(
      padding: EdgeInsets.all(20),
      children: bookings.map((booking) {
        int index = DataService.bookings.indexOf(booking);
        return Card(
          child: ListTile(
            title: Text(booking.service),
            subtitle: Text("Date: ${booking.date}\nTime: ${booking.timeSlot}"),
            trailing: IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: () {
                setState(() {
                  DataService.cancelBooking(index);
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistory() {
    var history = DataService.getCustomerHistory(widget.user.username);
    if (history.isEmpty) return Center(child: Text("No service history."));
    return ListView(
      padding: EdgeInsets.all(20),
      children: history.map((booking) {
        return Card(
          child: ListTile(
            title: Text(booking.service),
            subtitle: Text("Status: ${booking.status.toUpperCase()}"),
            leading: Icon(
              booking.status == "done" ? Icons.check_circle : Icons.cancel, 
              color: booking.status == "done" ? Colors.green : Colors.red
            ),
            trailing: booking.status == "done" ? ElevatedButton(
              onPressed: () => _showInvoice(booking),
              child: Text("Invoice"),
            ) : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfile() {
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Icon(Icons.person, size: 100, color: Colors.grey),
        SizedBox(height: 20),
        ListTile(
          title: Text("Name"),
          subtitle: Text(widget.user.name ?? "Not Provided"),
        ),
        ListTile(
          title: Text("Username"),
          subtitle: Text(widget.user.username),
        ),
        ListTile(
          title: Text("Phone"),
          subtitle: Text(widget.user.phoneNumber ?? "Not Provided"),
        ),
        SizedBox(height: 40),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () {
             Navigator.pop(context); // Log out safely
          },
          child: Text("Log Out", style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      _buildHome(),
      _buildBookings(),
      _buildHistory(),
      _buildProfile(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Welcome, ${widget.user.name ?? widget.user.username}")),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}