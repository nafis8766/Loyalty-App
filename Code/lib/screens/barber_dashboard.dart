import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/booking.dart';
import '../models/user.dart';

class BarberDashboard extends StatefulWidget {
  final User user;

  BarberDashboard({required this.user});

  @override
  _BarberDashboardState createState() => _BarberDashboardState();
}

class _BarberDashboardState extends State<BarberDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildActiveBookings() {
    List<Booking> activeBookings = DataService.getBarberActiveBookings(widget.user.username);
    if (activeBookings.isEmpty) return Center(child: Text("No active assigned bookings"));
    return ListView(
      padding: EdgeInsets.all(20),
      children: activeBookings.map((booking) {
        int index = DataService.bookings.indexOf(booking);
        return Card(
          child: ListTile(
            title: Text(booking.service),
            subtitle: Text("Customer: ${booking.customerName}\nDate: ${booking.date}  Time: ${booking.timeSlot}"),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Complete", style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  DataService.markBookingDone(index);
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistory() {
    List<Booking> historyBookings = DataService.getBarberHistory(widget.user.username);
    if (historyBookings.isEmpty) return Center(child: Text("No completed bookings yet"));
    return ListView(
      padding: EdgeInsets.all(20),
      children: historyBookings.map((booking) => Card(
        color: Colors.green.shade100,
        child: ListTile(
          title: Text(booking.service),
          subtitle: Text("Customer: ${booking.customerName}\nDate: ${booking.date}  Time: ${booking.timeSlot}"),
          leading: Icon(Icons.check_circle, color: Colors.green),
          trailing: Text("\$${(booking.price - booking.discountApplied).toStringAsFixed(2)}", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      )).toList(),
    );
  }

  Widget _buildEarnings() {
    List<Booking> historyBookings = DataService.getBarberHistory(widget.user.username);
    double totalRevenue = historyBookings.fold(0, (sum, item) => sum + (item.price - item.discountApplied));
    double earnings = totalRevenue * 0.70;

    return Center(
      child: Card(
        margin: EdgeInsets.all(30),
        color: Colors.blue.shade100,
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.monetization_on, size: 80, color: Colors.blue.shade700),
              SizedBox(height: 20),
              Text("Total Earnings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("\$${earnings.toStringAsFixed(2)}", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.blue.shade900)),
              SizedBox(height: 20),
              Text("Based on 70% of total customer payments.", style: TextStyle(color: Colors.blue.shade800)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      _buildActiveBookings(),
      _buildHistory(),
      _buildEarnings(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Barber Dashboard - ${widget.user.name ?? widget.user.username}"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Active'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Earnings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        onTap: _onItemTapped,
      ),
    );
  }
}
