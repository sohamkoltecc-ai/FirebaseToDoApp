import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errormessage = '';
  bool isLogin = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signwithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
         _emailController.text,
         _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message!;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
         _emailController.text,
         _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errormessage = e.message!;
      });
    }
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _enterFeild(String title, TextEditingController controller,) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errormessage == '' ? '' : 'Humm ? $errormessage');
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signwithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Create an account' : 'I have an account'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _enterFeild('Email', _emailController,),
            _enterFeild('Password', _passwordController,),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}