import 'dart:convert';

import 'package:day35/pages/Login.dart';
import 'package:day35/pages/start.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool _isLoading = false;

  void signUp() async {
    setState(() {
      this._isLoading = true;
    });
    var url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDAywYuOOCTvfS5yKwB8ZOCzdwb06XhWpw");
    Map data = {
      "email": emailController.text,
      "password": passwordController.text,
      "returnSecureToken": true,
    };
    var body = json.encode(data);
    var res = await http.post(
      url,
      body: body,
      headers: {"Content-Type": "application/json"},
    );
    setState(() {
      this._isLoading = false;
    });
    print(res.body);
    if (res.statusCode == 200 || res.statusCode == 201) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StartPage(),
        ),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Some error has occurred!",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Widget inputFile({
    label,
    obscureText = false,
    textFieldController,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obscureText,
          controller: textFieldController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[400],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Create an account, It's free ",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Column(
                children: <Widget>[
                  inputFile(
                    label: "Username",
                    textFieldController: nameController,
                  ),
                  inputFile(
                    label: "Email",
                    textFieldController: emailController,
                  ),
                  inputFile(
                    label: "Password",
                    obscureText: true,
                    textFieldController: passwordController,
                  ),
                  inputFile(
                    label: "Confirm Password ",
                    obscureText: true,
                    textFieldController: confirmPasswordController,
                  ),
                ],
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border(
                            bottom: BorderSide(color: Colors.black),
                            top: BorderSide(color: Colors.black),
                            left: BorderSide(color: Colors.black),
                            right: BorderSide(color: Colors.black),
                          )),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: _isLoading
                            ? null
                            : () {
                                print("name " + nameController.text);
                                print("email " + emailController.text);
                                print("password " + passwordController.text);
                                print("confirmPasswod " +
                                    confirmPasswordController.text);
                                if (nameController.text.isEmpty ||
                                    confirmPasswordController.text.isEmpty ||
                                    emailController.text.isEmpty ||
                                    passwordController.text.isEmpty) {
                                  return;
                                }
                                signUp();
                              },
                        color: Color(0xff0095FF),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      " Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
