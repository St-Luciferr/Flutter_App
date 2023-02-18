import 'package:amid/provider/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'signup.dart';
import 'home_page.dart';

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
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
              image: AssetImage('assets/background.jpg'), fit: BoxFit.fill),
        ),
        padding: const EdgeInsets.fromLTRB(50, 200, 50, 20),
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const Text(
                "WelCome To Amid",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 5, 73, 73),
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  // filled: true,
                  // fillColor: Colors.grey,
                  contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                  labelText: 'Username',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 6, 95, 95),
                  ),
                  hintText: 'Enter Your Username',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 11, 148, 148),
                  ),
                ),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please Enter Username*';
                  }
                  if (value != null && value.length < 6) {
                    return 'Username must be at least 6 characters long';
                  }

                  return null;
                },
                onSaved: (value) {
                  _username = value ?? '';
                  // _username = (value != null && !value.isEmpty) ? value : '';
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 6, 95, 95),
                  ),
                  hintText: '********',
                  hintStyle: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 11, 148, 148),
                  ),
                ),
                obscureText: true,
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please Enter Password*';
                  }
                  if (value != null && value.length < 8) {
                    return 'Password length should be at least 8 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value ?? '';
                  _hashedPassword = BCrypt.hashpw(_password, BCrypt.gensalt());
                  _password = '';
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 71, 88),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  fixedSize: const Size(200, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
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
                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomePage(camera: camera),
                        ),
                      );
                    }
                  }
                },
              ),
              OutlinedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 71, 88),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  fixedSize: const Size(200, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(title: 'Sign Up'),
                    ),
                  );
                },
              ),
              OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 2, 71, 88),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  fixedSize: const Size(200, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(Icons.alternate_email_outlined),
                label: const Text(
                  'Sign Up with Google',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  await provider.googleLogin();
                  final cameras = await availableCameras();
                  final camera = cameras.first;
                  if (mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(camera: camera),
                      ),
                    );
                  }
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                      fontSize: 15, decoration: TextDecoration.underline),
                ),
                child: const Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Color.fromARGB(255, 6, 95, 95),
                  ),
                ),
                onPressed: () {
                  // Open forgot password page
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
