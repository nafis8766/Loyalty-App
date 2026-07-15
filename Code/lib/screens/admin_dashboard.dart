import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/booking.dart';
import '../models/user.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
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

  Widget _buildActiveBookings() {
    List<Booking> activeBookings = DataService.getAdminActiveBookings();
    if (activeBookings.isEmpty) return Center(child: Text("No active bookings"));
    return ListView(
      padding: EdgeInsets.all(20),
      children: activeBookings.map((booking) {
        int index = DataService.bookings.indexOf(booking);
        return Card(
          child: ListTile(
            title: Text(booking.service),
            subtitle: Text("Customer: ${booking.customerName}\nDate: ${booking.date}  Time: ${booking.timeSlot}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  hint: Text("Assign"),
                  value: booking.barberName,
                  items: DataService.users
                      .where((u) => u.role == "barber")
                      .map((u) => DropdownMenuItem(
                            value: u.username,
                            child: Text(u.name ?? u.username),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        DataService.assignBarber(index, val);
                      });
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () {
                    setState(() {
                      DataService.markBookingDone(index);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      DataService.cancelBooking(index);
                    });
                  },
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistory() {
    List<Booking> historyBookings = DataService.getAdminHistory();
    if (historyBookings.isEmpty) return Center(child: Text("No history"));
    return ListView(
      padding: EdgeInsets.all(20),
      children: historyBookings.map((booking) => Card(
        color: booking.status == "done" ? Colors.green.shade100 : Colors.red.shade100,
        child: ListTile(
          title: Text(booking.service),
          subtitle: Text("Customer: ${booking.customerName}"),
          leading: Icon(booking.status == "done" ? Icons.check : Icons.cancel, 
            color: booking.status == "done" ? Colors.green : Colors.red),
          trailing: booking.status == "done" ? ElevatedButton(
            onPressed: () => _showInvoice(booking),
            child: Text("Invoice"),
          ) : null,
        ),
      )).toList(),
    );
  }

  Widget _buildStatistics() {
    List<User> customers = DataService.users.where((u) => u.role == "customer").toList();
    return ListView(
      padding: EdgeInsets.all(20),
      children: [
        Card(
          color: Colors.blue.shade100,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Total Customers", style: TextStyle(fontSize: 18)),
                Text("${customers.length}", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Text("Customer Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ...customers.map((c) {
            int orderCount = DataService.bookings.where((b) => b.customerName == c.username).length;
            return Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text(c.name ?? c.username),
                subtitle: Text("Phone: ${c.phoneNumber ?? 'N/A'}\nOrders: $orderCount"),
                isThreeLine: true,
                trailing: Text("${c.loyaltyPoints} pt", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
              ),
            );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      _buildActiveBookings(),
      _buildHistory(),
      _buildStatistics(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
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
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Active'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        onTap: _onItemTapped,
      ),
    );
  }
}