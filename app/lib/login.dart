import 'package:flutter/material.dart';
import 'home.dart';
import 'package:fit_finder/createAccount.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';


const Color deepPurple = Color(0xFF6A0DAD);

void main() {
  runApp(FitFinderApp());
}

class FitFinderApp extends StatelessWidget {
  const FitFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFinder',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers to retrieve the input from the TextFields
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> checkForm() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    String missingItem;
    if (username.isEmpty) {
      missingItem = "Username";
    } else if (password.isEmpty) {
      missingItem = "Password";
    } else {
      return;
    }

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: Text("Error"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(missingItem + ' missing.'),
                  Text('Make sure all fields are filled in.')
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
  }




  // Function to handle login logic
void _handleLogin() async {
  await checkForm();

  String username = _usernameController.text;
  String password = _passwordController.text;

  if (username.isEmpty || password.isEmpty) {
    return;
  }

  http.Response resp = await http.post(
    Uri.parse("https://trigtbh.dev:5000/api/login"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String> {
      "username": username,
      "password": sha256.convert(utf8.encode(password)).toString()
    })
  );

  if (resp.statusCode != 200) {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return  AlertDialog(
            title: Text("Error"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Invalid credentials.'),
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




    // Navigate to HomePage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(token: token)),
    );
  }

  // Function to navigate to the Create Account page
  void _navigateToCreateAccount() {
    // TODO: Implement navigation to the Create Account page
    // For example:
    // Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
    // print('Navigate to Create Account page');
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitFinder'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          // To make the content scrollable in case of small screens
          padding: const EdgeInsets.all(16.0), // Add padding around the content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Find your fashion style today!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 32.0),
              // Username TextField
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 16.0), // Space between fields

              // Password TextField
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true, // Hide the password
              ),
              const SizedBox(height: 24.0), // Space before the button

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Text color
                    backgroundColor:
                        Colors.deepPurple, // Button background color
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Create Account Text Button
              TextButton(
                onPressed: _navigateToCreateAccount,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple,
                ),
                child: const Text(
                  'Create Account',
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
