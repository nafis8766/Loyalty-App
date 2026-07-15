import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/data_service.dart';
import 'models/user.dart';

void main() {
  // Create default admin account
  DataService.users.add(User(
    username: "admin",
    password: "admin123",
    role: "admin",
    loyaltyPoints: 0,
    name: "System Admin",
  ));

  // Optional: sample customer
  DataService.users.add(User(
    username: "customer1",
    password: "pass123",
    role: "customer",
    loyaltyPoints: 50,
    name: "John Doe",
    phoneNumber: "+1234567890",
  ));

  // Hardcoded barbers
  DataService.users.add(User(
    username: "barber1",
    password: "password",
    role: "barber",
    name: "Barber One",
  ));

  DataService.users.add(User(
    username: "barber2",
    password: "password",
    role: "barber",
    name: "Barber Two",
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Salon Loyalty App",
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Color(0xfff5f5f5),
        fontFamily: "Roboto",
      ),
      home: LoginScreen(),
    );
  }
}