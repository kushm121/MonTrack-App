import 'package:flutter/material.dart';
import 'Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String errorMessage = '';
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  String email = '';
  String password = '';
  String username = '';

  bool _isUsernameTyped = false;
  bool _isEmailTyped = false;
  bool _isPasswordTyped = false;
  bool _isConfirmPasswordTyped = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  bool isValidEmail(String email) {
    // Regular expression for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/pbg.png"),
                  fit: BoxFit.cover)),
          child: ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Create a new account',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white, // Outline color
                        ),
                      ),
                      child: TextField(
                        controller: _usernameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: _isUsernameTyped ? '' : 'Username',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            username = value;
                            _isUsernameTyped = value.isNotEmpty;
                          });
                        },
                      ),
                    ),

                    // SizedBox for spacing
                    SizedBox(height: 20),

                    // Add the custom outlined transparent text field for Email
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white, // Outline color
                        ),
                      ),
                      child: TextField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: _isEmailTyped ? '' : 'Email',
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                            _isEmailTyped = value.isNotEmpty;
                          });
                        },
                      ),
                    ),

                    // SizedBox for spacing
                    SizedBox(height: 20),

                    // Add the custom outlined transparent text field for Password
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white, // Outline color
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _passwordController,
                            style: TextStyle(color: Colors.white),
                            obscureText:
                                !_isPasswordVisible, // Hide or show the password based on _isPasswordVisible
                            decoration: InputDecoration(
                              hintText: _isPasswordTyped ? '' : 'Password',
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                password = value;
                                _isPasswordTyped = value.isNotEmpty;
                              });
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible; // Toggle password visibility
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox for spacing
                    SizedBox(height: 20),

                    // Add the custom outlined transparent text field for Confirm Password
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white, // Outline color
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextField(
                            controller: _confirmPasswordController,
                            style: TextStyle(color: Colors.white),
                            obscureText:
                                !_isConfirmPasswordVisible, // Hide or show the confirm password based on _isConfirmPasswordVisible
                            decoration: InputDecoration(
                              hintText: _isConfirmPasswordTyped
                                  ? ''
                                  : 'Confirm Password',
                              hintStyle: TextStyle(color: Colors.white),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isConfirmPasswordTyped = value.isNotEmpty;
                              });
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible; // Toggle confirm password visibility
                              });
                            },
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 66, 1, 130),
                            Color.fromARGB(255, 102, 0, 192)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 4,
                            offset: Offset(0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          signUp(email, password, username);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                        ),
                        child: Center(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Circular',
                              fontWeight: FontWeight.w800,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Circular',
                              fontWeight: FontWeight.w600,
                              fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Color.fromARGB(255, 178, 89, 252),
                              fontFamily: 'Circular',
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password, String username) async {
    final RegExp emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]+[a-zA-Z0-9_]*$');
    final RegExp phoneRegex = RegExp(r'^[0-9]+$');
    final RegExp passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$');
    if (!usernameRegex.hasMatch(username) || username.length < 3) {
      Fluttertoast.showToast(msg: 'Username should be at least 3 characters and contain only letters, numbers, and underscores.');
      return;
    }

    if (!emailRegex.hasMatch(email)) {
      Fluttertoast.showToast(msg: 'Please enter a valid email address.');
      return;
    }
    if (!passwordRegex.hasMatch(password) || password.length < 6) {
      Fluttertoast.showToast(msg: 'Password should be at least 6 characters and contain at least 1 letter and 1 digit.');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore.instance
          .collection("newUsers")
          .doc(userCredential.user!.email)
          .set({'email': email, 'username': username});

      Fluttertoast.showToast(msg: 'Sign up successful!');

      // Update text controllers to show hints after successful signup
      setState(() {
        _usernameController.text = 'Username';
        _emailController.text = 'Email';
        _passwordController.text = 'Password';
        _confirmPasswordController.text = 'Confirm Password';
      });
    } catch (e) {
      String errorcode = '';
      errorcode = e.toString();
      // print(errorcode);
      switch (errorcode) {
        case "[firebase_auth/invalid-email] The email address is badly formatted.":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
          errorMessage =
              "The email address is already associated with an existing account.";
          break;
        case "[firebase_auth/weak-password] Password should be at least 6 characters":
          errorMessage =
              "The password is too weak. It should atleast be 6 characters.";
          break;
        case "[firebase_auth/operation-not-allowed] Password sign-in is disabled for this project.":
          errorMessage = "Password sign-in is currently disabled.";
          break;
        case '[firebase_auth/unknown] Given String is empty or null':
          errorMessage = 'Empty fields! Enter some input to continue';
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "User with this email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests. Please try again later.";
          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined error occurred.";
      }
      // Fluttertoast.showToast(msg: errorMessage!);
      errorMessage = '';
    }
  }
}
