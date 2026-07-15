import 'package:flutter/material.dart';
import '../services/data_service.dart';
import 'customer_dashboard.dart';
import 'admin_dashboard.dart';
import 'barber_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void login(BuildContext context) {

    var user = DataService.login(
      usernameController.text,
      passwordController.text,
    );

    if (user != null) {

      if (user.role == "admin") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AdminDashboard()),
        );
      } else if (user.role == "barber") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BarberDashboard(user: user)),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CustomerDashboard(user: user)),
        );
      }

    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),

          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),

            child: Padding(
              padding: EdgeInsets.all(25),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Icon(Icons.content_cut,
                      size: 60, color: Colors.pink),

                  SizedBox(height: 10),

                  Text(
                    "Loyalty Salon",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),

                  SizedBox(height: 10),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),

                  SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 45),
                    ),
                    onPressed: () => login(context),
                    child: Text("Login"),
                  ),

                  TextButton(
                    child: Text("Create Account"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => RegisterScreen()),
                      );
                    },
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}