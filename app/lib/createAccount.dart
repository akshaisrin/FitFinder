import 'package:fit_finder/home.dart';
import 'package:fit_finder/initialPhotos.dart';
import 'package:flutter/material.dart';
import 'package:fit_finder/createAccount.dart';
import 'login.dart';
import 'profile.dart';
import 'package:crypto/crypto.dart';  // For hashing algorithms

import 'package:http/http.dart' as http;
import 'dart:convert';

const Color deepPurple = Color(0xFF6A0DAD);

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}





class _CreateAccountState extends State<CreateAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to handle create account logic
  void _handleCreateAccount() async {
    // TODO: Implement account creation logic here
    // print("Account created for username: ${_usernameController.text}");
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    http.Response resp = await http.post(
        Uri.parse("https://trigtbh.dev:5000/api/register"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String> {
          "username": username,
          "password": sha256.convert(utf8.encode(password)).toString(),
          "email": email
        })
    );

    if (resp.statusCode == 400) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return  AlertDialog(
              title: Text("Error"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Username already exists.'),
                    Text('Please use a different username.')
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
      return;
    } else if (resp.statusCode != 200) {
      await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return  AlertDialog(
              title: Text("Error"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Unable to create account.'),
                    Text('Please try again.')
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
      return;
    }
    String token = jsonDecode(resp.body)["token"];





    // After account creation, navigate to the Profile page or any other page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitialPhotosPage(token: token)),
    );
  }

  // Function to navigate to the Login page
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account'),
        //backgroundColor: none,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: deepPurple,
                ),
              ),
              SizedBox(height: 32.0),

              // Username TextField
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 16.0),

              // Email TextField
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 16.0),

              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true, // Hide the password input
              ),
              SizedBox(height: 24.0),

              // Create Account Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleCreateAccount,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: deepPurple,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Text(
                    'Create Account',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Already have an account? Login
              TextButton(
                onPressed: _navigateToLogin,
                style: TextButton.styleFrom(
                  foregroundColor: deepPurple,
                ),
                child: Text(
                  'Already have an account? Login',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}