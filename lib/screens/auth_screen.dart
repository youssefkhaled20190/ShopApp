// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:shop/widgits/auth_form.dart';

class AuthScreen extends StatelessWidget {
  static const routename = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            //tadrog l alwan
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Color.fromARGB(255, 0, 0, 0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.purple,
                        // ignore: prefer_const_literals_to_create_immutables
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Color.fromARGB(66, 239, 233, 239),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        "Shop App",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Anton',
                            fontSize: 50),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
