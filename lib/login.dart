import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'What do you want to be called here?'),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Please enter a username';
                  }
                  if (value != null && value.length < 4) {
                    return 'Username must be at least 4 characters long';
                  }
                  if (value != null &&
                      !value.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
                    return 'Username can only contain letters and numbers';
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
                  }),
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  // Validate the form
                  if (_formKey.currentState != null &&
                      _formKey.currentState!.validate()) {
                    // If the form is valid, save the email and password
                    // to the variables and submit the form
                    _formKey.currentState!.save();
                    debugPrint(_password);
                    debugPrint(_username);
                    debugPrint(_formKey.currentState.toString());
                    // Perform the login action (e.g. send the email and password
                    // to a server to verify the user's credentials)
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}