import 'package:flutter/material.dart';
import 'package:montrack_app/dashboard.dart';
import 'bottom_navigation.dart';
import 'landing.dart';
import 'SignUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  bool _isUsernameTyped = false;
  bool _isPasswordTyped = false;
  bool _isPasswordVisible = false;
  bool showSpinner = false;
  String email = '';
  String errorMessage = '';
  String password = '';
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Container(
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
                        'Welcome',
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
                        'Login to your account',
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
                            hintText: _isUsernameTyped ? '' : 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                      ),
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
                              offset:
                                  Offset(0, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email, password: password);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Bottom()), //bottom page will be main
                              );
                              Fluttertoast.showToast(
                                  msg: 'Successfully Logged In!');
                              setState(() {
                                showSpinner = false;
                              });
                            } catch (e) {
                              String error = '';
                              error = e.toString();
                              switch (error) {
                                case '[firebase_auth/wrong-password] The password is invalid or the user does not have a password.':
                                  errorMessage = 'Invalid Password Entered.';
                                  break;
                                case '[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.':
                                  errorMessage = 'No such user exists.';
                                  break;
                                case '[firebase_auth/invalid-email] The email address is badly formatted.':
                                  errorMessage = 'Invalid email address.';
                                  break;
                                case '[firebase_auth/unknown] Given String is empty or null':
                                  errorMessage =
                                      'Empty fields! Enter some input to continue';
                                  break;
                                case '[firebase_auth/too-many-requests] We have blocked all requests from this device due to unusual activity. Try again later.':
                                  errorMessage =
                                      'Too many attempts, try again later';
                                  break;
                                case '[firebase_auth/user-disabled] The user account has been disabled by an administrator.':
                                  errorMessage =
                                      'Account blocked by Administrator';
                                  break;
                                default:
                                  errorMessage = 'An undefined error occurred.';
                                  break;
                              }
                            }
                            Fluttertoast.showToast(msg: errorMessage);
                            setState(() {
                              showSpinner = false;
                            });
                            errorMessage = '';
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Center(
                            child: Text(
                              'Login',
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
                            'Don\'t have an account?',
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
                                MaterialPageRoute(
                                    builder: (context) => SignUp()),
                              );
                            },
                            child: Text(
                              'SIGN UP',
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
      ),
    );
  }
}
