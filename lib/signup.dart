import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});
  final String title;
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final confirmPasswordController = TextEditingController();
  final passwordController = TextEditingController();

  String? _username;
  String? _password1;
  String? _password2;
  String? _hashedPassword;
  String? _Email;
  String? _FirstName;
  String? _LastName;
  String? _Address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
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

                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'New Password',
                      hintText: 'Enter new password'),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter a password';
                    }
                    if (value != null && value.length < 8) {
                      return 'Password length should be at least 8 characters';
                    }
                    if (value != confirmPasswordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password1 = value ?? '';
                    _hashedPassword =
                        BCrypt.hashpw(_password1!, BCrypt.gensalt());
                    _password1 = '';
                  }),
              TextFormField(
                  decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Confirm new password'),
                  obscureText: true,
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter confirm password';
                    }
                    if (value != passwordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password2 = value ?? '';
                    _hashedPassword =
                        BCrypt.hashpw(_password2!, BCrypt.gensalt());
                    _password2 = '';
                  }),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Email', hintText: 'Your Email?'),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Email is required';
                  }
                  final RegExp regex = RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                  if (!regex.hasMatch(value!)) {
                    return 'Enter a valid Email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _Email = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'First Name:', hintText: 'Enter first name'),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'first name is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _FirstName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Last Name:', hintText: 'Enter Last name'),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Last name is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _LastName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Address:',
                    hintText: 'Enter your permanent address'),
                validator: (value) {
                  if (value?.isEmpty == true) {
                    return 'Address is required';
                  }
                  return null;
                },
                onSaved: (value) {
                  _Address = value!;
                },
              ),
              ElevatedButton(
                  child: const Text('Sign Up'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // If the form is valid, save the email and password
                      // to the variables and submit the form
                      debugPrint(_username);
                      debugPrint(_password1);
                      debugPrint(_hashedPassword);
                      debugPrint(_Email);
                      debugPrint(_Address);
                      debugPrint(_formKey.currentState.toString());
                    }
                  }),
              OutlinedButton(
                child: const Text('Login'),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(title: 'Login'),
                    ),
                  );
                },
              )
            ]),
          )),
    );
  }
}
