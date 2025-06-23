import 'dart:io';

import 'package:chat_app/services/auth/googleAuthService.dart';
import 'package:chat_app/services/auth/data.dart';
import 'package:chat_app/components/inputField.dart';
import 'package:chat_app/components/signInButton.dart';
import 'package:chat_app/components/squareButton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool processingCredentials = false;

  Future<void> _onSignIn() async {
    FocusScope.of(context).unfocus();
    setState(() {
      processingCredentials = true;
    });
    try {
      errorCode = '';
      passwordNotMatched = false;
      if (showLogin) {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        if (passwordController.text == confirmPasswordController.text) {
          userCredential = await FirebaseAuth.instance 
              .createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
        } else {
          setState(() {
            passwordNotMatched = true;
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        processingCredentials = false;
        if (e.code == 'invalid-credential') {
          errorCode = 'Wrong email or password';
        } else {
          errorCode = e.code.replaceAll('-', ' ');
        }
      });

      print(e.code);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code),
            duration: loadingTime,
          ),
        );
      }
    }
  }

  Future<void> resetPassword() async {
    FocusScope.of(context).unfocus();
    resetEmailSent = false;
    errorCode = '';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Center(
        child: SpinKitPulse(
            color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,
        ),
      ),
    );
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text);
      setState(() {
        resetEmailSent = true;
      });
    } on FirebaseAuthException catch (e) {
      errorCode = e.code.replaceAll('-', ' ');
      setState(() {
        resetEmailSent = false;
      });
    }
    if (mounted) {
      Navigator.pop(context);
      FocusScope.of(context).unfocus();
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !forgotPassword,
      onPopInvokedWithResult: (didPop, result) {
        setState(() {
          clearControllers();
          forgotPassword = false;
          errorCode = '';
          resetEmailSent = false;
        });
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Icon(
                          Icons.lock,
                          size: showLogin ? 100 : 60,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        InputField(
                          hintText: 'Email',
                          obsecure: false,
                          controller: emailController,
                        ),
                        SizedBox(
                          height: 25,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ((errorCode.isNotEmpty &&
                                        errorCode !=
                                            'Wrong email or password') ||
                                    resetEmailSent)
                                ? (errorCode.isNotEmpty &&
                                        errorCode != 'Wrong email or password')
                                    ? Text(
                                        ' $errorCode',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      )
                                    : Text(
                                        ' Reset email sent',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                        ),
                                      )
                                : null,
                          ),
                        ),
                        if (!forgotPassword) ...{
                          InputField(
                            hintText: 'Password',
                            obsecure: true,
                            controller: passwordController,
                          ),
                          if (!showLogin) ...{
                            SizedBox(
                              height: 25,
                            ),
                            InputField(
                              hintText: 'Confirm Password',
                              obsecure: true,
                              controller: confirmPasswordController,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: passwordNotMatched
                                  ? Text(
                                      ' Passwords do not match',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    )
                                  : null,
                            ),
                          },
                          if (errorCode == 'Wrong email or password')
                            SizedBox(
                              height: 25,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: (errorCode.isNotEmpty || resetEmailSent)
                                    ? errorCode.isNotEmpty
                                        ? Text(
                                            ' $errorCode',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          )
                                        : Text(
                                            ' Reset email sent',
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12,
                                            ),
                                          )
                                    : null,
                              ),
                            )
                          else
                            SizedBox(
                              height: 10,
                            ),
                          if (showLogin) ...{
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      forgotPassword = true;
                                    });
                                  },
                                  child: Text("Forgot Password?")),
                            ),
                          },
                        },
                        SizedBox(
                          height: 25,
                        ),
                        processingCredentials
                            ? Center(
                                child: SpinKitPulse(
            color: Theme.of(context).brightness==Brightness.light?Colors.black:Colors.white,
                                ),
                              )
                            : SignInButton(
                                reset: forgotPassword,
                                showLogin: showLogin,
                                onTap:
                                    forgotPassword ? resetPassword : _onSignIn,
                              ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[600],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or continue with'),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[600],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareButton(
                          onTap: () => AuthService().signInWithGoogle(),
                          path: 'assets/google-logo-2.png'),
                      if (Platform.isIOS || true) ...{
                        SizedBox(
                          width: 20,
                        ),
                        SquareButton(
                            onTap: () => AuthService().signInWithGoogle(),
                            path: 'assets/apple-logo-2.png'),
                      }
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(showLogin
                          ? 'Not a member? '
                          : 'Already have an account?'),
                      SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: () => setState(() {
                          emailController.clear();
                          passwordController.clear();
                          confirmPasswordController.clear();
                          forgotPassword = false;
                          showLogin = !showLogin;
                          errorCode='';
                        }),
                        child: Text(
                          showLogin ? 'Register now' : 'Login',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
