import 'dart:convert';

import 'package:day35/pages/signup.dart';
import 'package:day35/pages/start.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool _isLoading = false;

  void login() async {
    setState(() {
      this._isLoading = true;
    });
    var url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDAywYuOOCTvfS5yKwB8ZOCzdwb06XhWpw");
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
    print(res.body);
    setState(() {
      this._isLoading = false;
    });
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
    emailController.dispose();
    passwordController.dispose();
  }

  Widget inputFile({
    label,
    textFieldController,
    obscureText = false,
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
          controller: textFieldController,
          obscureText: obscureText,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400]),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]))),
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
      resizeToAvoidBottomInset: false,
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Login to your account",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        inputFile(
                          label: "Email",
                          textFieldController: emailController,
                        ),
                        inputFile(
                            label: "Password",
                            textFieldController: passwordController,
                            obscureText: true)
                      ],
                    ),
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Container(
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
                                      if (emailController.text.isEmpty ||
                                          passwordController.text.isEmpty) {
                                        return;
                                      }
                                      login();
                                    },
                              color: Color(0xff0095FF),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                        child: Text(
                          " Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 100),
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/background.png"),
                          fit: BoxFit.fitHeight),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
