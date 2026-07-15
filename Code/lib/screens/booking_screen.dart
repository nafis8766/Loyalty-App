import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/data_service.dart';

class BookingScreen extends StatefulWidget {
  final User user;

  BookingScreen({required this.user});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentStep = 0;
  
  List<String> _selectedServices = [];
  double _servicePrice = 0.0;
  
  String? _selectedDate;
  String? _selectedTime;
  List<String> _availableSlots = [];
  
  bool _usePoints = false;

  final Map<String, double> _services = {
    "Haircut": 20.0,
    "Hair Coloring": 50.0,
    "Facial": 30.0,
    "Shaving": 15.0
  };

  void _onDateSelected(DateTime date) {
    String formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    setState(() {
      _selectedDate = formattedDate;
      _selectedTime = null;
      _availableSlots = DataService.getAvailableSlots(formattedDate);
    });
  }

  void _bookService() {
    double discount = 0.0;
    if (_usePoints && widget.user.loyaltyPoints >= 10) {
      int maxPointsToUse = (_servicePrice * 10).toInt();
      int pointsUsed = widget.user.loyaltyPoints > maxPointsToUse ? maxPointsToUse : widget.user.loyaltyPoints;
      discount = pointsUsed / 10.0;
      widget.user.loyaltyPoints -= pointsUsed;
    }

    DataService.addBooking(_selectedServices.join(", "), widget.user, _selectedDate!, _selectedTime!, _servicePrice, discount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Service booked successfully!")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Service")),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep == 0 && _selectedServices.isEmpty) return;
          if (_currentStep == 1 && (_selectedDate == null || _selectedTime == null)) return;
          
          if (_currentStep == 2) {
            _bookService();
          } else {
            setState(() {
              _currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          } else {
            Navigator.pop(context);
          }
        },
        steps: [
          Step(
            title: Text("Select Service"),
            isActive: _currentStep >= 0,
            content: Column(
              children: _services.keys.map((service) {
                return CheckboxListTile(
                  title: Text("$service - \$${_services[service]}"),
                  value: _selectedServices.contains(service),
                  onChanged: (val) {
                    setState(() {
                      if (val == true) {
                        _selectedServices.add(service);
                        _servicePrice += _services[service]!;
                      } else {
                        _selectedServices.remove(service);
                        _servicePrice -= _services[service]!;
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          Step(
            title: Text("Select Date & Time"),
            isActive: _currentStep >= 1,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 30)),
                    );
                    if (date != null) _onDateSelected(date);
                  },
                  child: Text(_selectedDate == null ? "Choose Date" : "Date: $_selectedDate"),
                ),
                if (_selectedDate != null) ...[
                  SizedBox(height: 20),
                  Text("Available Slots:"),
                  Wrap(
                    spacing: 10,
                    children: _availableSlots.map((slot) {
                      return ChoiceChip(
                        label: Text(slot),
                        selected: _selectedTime == slot,
                        onSelected: (selected) {
                          setState(() {
                            _selectedTime = selected ? slot : null;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  if (_availableSlots.isEmpty) Text("No slots available on this date.", style: TextStyle(color: Colors.red)),
                ]
              ],
            ),
          ),
          Step(
            title: Text("Confirm & Pay"),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Services: ${_selectedServices.join(", ")}"),
                Text("Date: $_selectedDate"),
                Text("Time: $_selectedTime"),
                Text("Price: \$${_servicePrice.toStringAsFixed(2)}"),
                SizedBox(height: 10),
                if (widget.user.loyaltyPoints >= 10)
                  CheckboxListTile(
                    title: Text("Use Loyalty Points? (${widget.user.loyaltyPoints} points available)"),
                    subtitle: Text("10 points = \$1 off"),
                    value: _usePoints,
                    onChanged: (val) {
                      setState(() {
                        _usePoints = val ?? false;
                      });
                    },
                  )
                else
                  Text("Not enough loyalty points for discount. (Min 10)"),
                Divider(),
                Text(
                  "Total to Pay: \$${(_usePoints ? (_servicePrice - (widget.user.loyaltyPoints >= (_servicePrice * 10) ? _servicePrice : widget.user.loyaltyPoints / 10)) : _servicePrice).toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}