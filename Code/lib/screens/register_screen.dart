import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../models/user.dart';

class RegisterScreen extends StatelessWidget {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void register(BuildContext context) {

    DataService.users.add(
      User(
        username: usernameController.text,
        password: passwordController.text,
        role: "customer",
        name: nameController.text.isNotEmpty ? nameController.text : null,
        phoneNumber: phoneController.text.isNotEmpty ? phoneController.text : null,
      ),
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Account Created")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Register")),

      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: "Full Name (Optional)"),
          ),
          TextField(
            controller: phoneController,
            decoration: InputDecoration(labelText: "Phone Number (Optional)"),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(labelText: "Username"),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: "Password"),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => register(context),
            child: Text("Create Account"),
          )
        ],
      ),
    );
  }
}