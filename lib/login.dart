import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:camera/camera.dart';
import 'package:mysql1/mysql1.dart';
import 'signup.dart';
import 'Homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create a global key that will uniquely identify the Form widget
  // and allow us to validate the form
  final _formKey = GlobalKey<FormState>();

  // Create variables to store the user's email and password
  String _username = '';
  String _password = '';
  String _hashedPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.jpg'), fit: BoxFit.fill)),
        padding: const EdgeInsets.all(20.0),
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Username', hintText: 'What is your username'),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a username';
                  }
                  if (value != null && value.length < 4) {
                    return 'Username must be at least 4 characters long';
                  }

                  return null;
                },
                onSaved: (value) {
                  _username = value ?? '';
                  // _username = (value != null && !value.isEmpty) ? value : '';
                },
              ),
              TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter a password';
                    }
                    if (value != null && value.length < 8) {
                      return 'Password length should be at least 8 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value ?? '';
                    _hashedPassword =
                        BCrypt.hashpw(_password, BCrypt.gensalt());
                    _password = '';
                  }),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () async {
                  // Validate the form
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    // If the form is valid, save the email and password
                    // to the variables and submit the form
                    _formKey.currentState!.save();
                    debugPrint(_password);
                    debugPrint(_username);
                    debugPrint(_hashedPassword);
                    debugPrint(_formKey.currentState.toString());
                    // Perform the login action (e.g. send the email and password
                    // to a server to verify the user's credentials)
                    final cameras = await availableCameras();
                    final camera = cameras.first;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => HomePage(camera: camera),
                      ),
                    );
                  }
                },
              ),
              OutlinedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Sign Up Now',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SignupPage(title: 'Sign Up'),
                    ),
                  );
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 10, decoration: TextDecoration.underline),
                ),
                child: const Text("Forgot password?"),
                onPressed: () {
                  // Open forgot password page
                  debugPrint('forgot password link clicked');
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
