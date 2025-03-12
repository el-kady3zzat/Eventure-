import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventure/core/utils/theme/colors.dart';
import 'package:eventure/features/admin_Dashboard/presentation/pages/events_screen.dart';
import 'package:eventure/features/admin_Dashboard/presentation/widgets/event_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminAuth extends StatefulWidget {
  const AdminAuth({super.key});

  @override
  State<AdminAuth> createState() => _AdminAuthState();
}

class _AdminAuthState extends State<AdminAuth> {
  bool hiddenpass = true;
  bool isSignUp = true;
  bool hiddenConfirmPass = true;
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignup = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  void togglePassword() {
    setState(() {
      hiddenpass = !hiddenpass;
    });
  }

  void toggleConfirmPassword() {
    setState(() {
      hiddenConfirmPass = !hiddenConfirmPass;
    });
  }

  void switchToSignUp() {
    setState(() {
      isSignUp = true;
    });
  }

  void switchToLogin() {
    setState(() {
      isSignUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: lightWhite,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Eventure',
                      style: TextStyle(
                        color: kMainDark,
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Admin Dashboard',
                      style: TextStyle(
                        color: kMainDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: switchToSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSignUp ? kButton2 : lightWhite,
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: isSignUp ? white : kMainDark,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: switchToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !isSignUp ? kButton2 : lightWhite,
                          ),
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: !isSignUp ? white : kMainDark,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: kMainDark,
              child: Padding(
                padding: const EdgeInsets.all(100.0),
                child: isSignUp ? _signUpForm() : _loginForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _signUpForm() {
    return Form(
      key: _formKeySignup,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's Sign Up ✨",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: white),
          ),
          const SizedBox(height: 8),
          Text(
            "Enter your details to create a new account.",
            style: TextStyle(fontSize: 14, color: lightWhite),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 400,
            child: CustomEventTextField(
                hint: "Enter Your Email",
                controller: emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }
                  String pattern = r'^[a-zA-Z0-9._%+-]+@gmail\.com$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return "Enter a valid Gmail address";
                  }
                  return null;
                },
                icon: Icons.person),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: CustomEventTextField(
                hint: "Your Password",
                controller: passwordController,
                obscureText: hiddenpass,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return "Password must be more than 6 characters";
                  }
                  return null;
                },
                icon: Icons.lock_person,
                suffixIcon: IconButton(
                  onPressed: () {
                    togglePassword();
                  },
                  icon: Icon(
                      hiddenpass ? Icons.visibility : Icons.visibility_off),
                )),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: CustomEventTextField(
                hint: "Confirm Password",
                controller: confirmpasswordController,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return "Password must be more than 6 characters";
                  } else if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
                icon: Icons.lock_reset_outlined,
                obscureText: hiddenConfirmPass,
                suffixIcon: IconButton(
                  onPressed: () {
                    toggleConfirmPassword();
                  },
                  icon: Icon(hiddenConfirmPass
                      ? Icons.visibility
                      : Icons.visibility_off),
                )),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 200,
            height: 35,
            child: ElevatedButton(
                onPressed: () async {
                  if (_formKeySignup.currentState!.validate()) {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    var db = FirebaseFirestore.instance;
                    final data = {
                      "id": userCredential.user!.uid,
                      "email": emailController.text,
                    };

                    db.collection("admin").add(data).then((documentSnapshot) {
                      emailController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Your Account Created Successfuly"),
                        backgroundColor: Colors.green,
                      ));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventsScreen()));
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kButton2,
                ),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.w500, fontSize: 18),
                )),
          )
        ],
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKeyLogin,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Back! 👋",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: white),
          ),
          const SizedBox(height: 8),
          Text(
            "Login to your account.",
            style: TextStyle(fontSize: 14, color: lightWhite),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: 400,
            child: CustomEventTextField(
                hint: "Enter Your Email",
                controller: emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email is required";
                  }
                  String pattern = r'^[a-zA-Z0-9._%+-]+@gmail\.com$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value)) {
                    return "Enter a valid Gmail address";
                  }
                  return null;
                },
                icon: Icons.person),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: CustomEventTextField(
                hint: "Your Password",
                controller: passwordController,
                obscureText: hiddenpass,
                validator: (value) {
                  if (value!.isEmpty || value.length < 6) {
                    return "Password must be more than 6 characters";
                  }
                  return null;
                },
                icon: Icons.lock_person,
                suffixIcon: IconButton(
                  onPressed: () {
                    togglePassword();
                  },
                  icon: Icon(
                      hiddenpass ? Icons.visibility : Icons.visibility_off),
                )),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: 200,
            height: 35,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKeyLogin.currentState!.validate()) {
                  try {
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );

                    if (credential.user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventsScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Login failed! Please check your email or password."),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    String errorMessage = "Login failed. Please try again.";

                    if (e.code == 'user-not-found') {
                      errorMessage =
                          "No user found with this email. Please sign up first.";
                    } else if (e.code == 'wrong-password') {
                      errorMessage = "Incorrect password. Please try again.";
                    } else if (e.code == 'invalid-email') {
                      errorMessage =
                          "Invalid email format. Please enter a valid email.";
                    } else if (e.code == 'user-disabled') {
                      errorMessage =
                          "This account has been disabled. Contact support.";
                    } else if (e.code == 'too-many-requests') {
                      errorMessage =
                          "Too many failed attempts. Try again later.";
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(errorMessage),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } catch (e) {
                    debugPrint("Error: ${e.toString()}");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "An unexpected error occurred. Please try again."),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: kButton2),
              child: Text("Login",
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.w500, fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    super.dispose();
  }
}
