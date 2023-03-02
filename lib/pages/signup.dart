// import 'package:amid/provider/google_sign_in.dart';
import 'package:amid/utility/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amid/pages/login.dart';
import 'package:flutter/material.dart';

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
  final emailController = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/inner_background.jpg'),
              fit: BoxFit.fill),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 6, 95, 95),
                    ),
                    hintText: 'Enter New Username',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 11, 148, 148),
                    ),
                    prefixIcon: const Icon(
                      Icons.person_add,
                      color: Color.fromARGB(255, 13, 174, 174),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: const Color.fromARGB(74, 153, 167, 168),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please Enter Username';
                    }
                    if (value != null && value.length < 4) {
                      return 'Username must be at least 4 characters long';
                    }

                    return null;
                  },
                  onSaved: (value) {},
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.key,
                      color: Color.fromARGB(255, 13, 174, 174),
                    ),
                    labelText: 'New Password',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 6, 95, 95),
                    ),
                    hintText: 'Enter New Password',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 11, 148, 148),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: const Color.fromARGB(74, 153, 167, 168),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please Enter Password*';
                    }
                    if (value != null && value.length < 8) {
                      return 'Password length should be at least 8 characters';
                    }
                    if (value != confirmPasswordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.key,
                      color: Color.fromARGB(255, 13, 174, 174),
                    ),
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 6, 95, 95),
                    ),
                    hintText: 'Confirm New Password',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 11, 148, 148),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: const Color.fromARGB(74, 153, 167, 168),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                  obscureText: true,
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please Confirm password*';
                    }
                    if (value != passwordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                  onSaved: (value) {},
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Color.fromARGB(255, 13, 174, 174),
                    ),
                    labelText: 'Email',
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 6, 95, 95),
                    ),
                    hintText: 'Enter Your Email ID',
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 11, 148, 148),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: const Color.fromARGB(74, 153, 167, 168),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Email is required*';
                    }
                    final RegExp regex = RegExp(
                        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                    if (!regex.hasMatch(value!)) {
                      return 'Enter a valid Email';
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
                  child: const Text('Sign Up'),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, save the email and password
                      // to the variables and submit the form
                      debugPrint(emailController.text);
                      debugPrint(passwordController.text);

                      try {
                        await Auth().createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      } on FirebaseAuthException catch (e) {
                        debugPrint(e.message);
                      }
                    } else {
                      return;
                    }
                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(title: 'Login'),
                        ),
                      );
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
                  child: const Text('Login'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(title: 'Login'),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
