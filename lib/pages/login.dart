import 'package:amid/provider/google_sign_in.dart';
import 'package:amid/utility/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  bool isAuthenticated = false;
  // Create variables to store the user's email and password
  String? _username;
  String? _password;

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
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.fill),
        ),
        padding: const EdgeInsets.fromLTRB(50, 200, 50, 20),
        alignment: Alignment.topCenter,
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // const Spacer(),
              const Text(
                "WelCome To Amid",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 5, 73, 73),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                decoration: InputDecoration(
                  // filled: true,
                  // fillColor: Colors.grey,
                  prefixIcon: const Icon(
                    Icons.account_circle,
                    color: Color.fromARGB(255, 13, 174, 174),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                  labelText: 'Username',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 6, 95, 95),
                  ),
                  hintText: 'Enter Your Username',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 11, 148, 148),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  // floatingLabelAlignment: FloatingLabelAlignment.start,
                  filled: true,
                  fillColor: const Color.fromARGB(74, 153, 167, 168),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
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
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                  prefixIcon: const Icon(
                    Icons.key,
                    color: Color.fromARGB(255, 13, 174, 174),
                  ),
                  labelText: 'Password',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 6, 95, 95),
                  ),
                  hintText: 'Enter Your Password',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 11, 148, 148),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: const Color.fromARGB(74, 153, 167, 168),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
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
                onSaved: (value) {},
              ),
              const SizedBox(
                height: 40,
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
                    try {
                      await Auth().signInWithEmailAndPassword(
                        email: _username ?? '',
                        password: _password ?? '',
                      );
                    } on FirebaseAuthException catch (e) {
                      debugPrint(e.message);
                    }
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
                  'Sign In with Google',
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
