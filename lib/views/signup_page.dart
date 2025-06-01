import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:royal_clothes/views/login_page.dart';

class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF121212), // hitam pekat
              Color(0xFFF8E16C), // emas soft
            ],
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 800),
                    child: Image.asset(
                      'assets/illustration.png', // logo illustration
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700), // emas cerah
                        fontFamily: 'Garamond',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 1200),
                    child: Text(
                      "Create an account, It's free",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white70,
                        fontFamily: 'Garamond',
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  FadeInUp(
                    duration: Duration(milliseconds: 1200),
                    child: makeInput(
                      label: "Email",
                      textColor: Colors.white,
                      borderColor: Color(0xFFFFD700),
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1300),
                    child: makeInput(
                      label: "Password",
                      obscureText: true,
                      textColor: Colors.white,
                      borderColor: Color(0xFFFFD700),
                    ),
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 1400),
                    child: makeInput(
                      label: "Confirm Password",
                      obscureText: true,
                      textColor: Colors.white,
                      borderColor: Color(0xFFFFD700),
                    ),
                  ),
                  SizedBox(height: 40),

                  FadeInUp(
                    duration: Duration(milliseconds: 1500),
                    child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        height: 60,
                        onPressed: () {},
                        color: Color(0xFFFFD700), // tombol emas
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Colors.black87,
                            fontFamily: 'Garamond',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  FadeInUp(
                    duration: Duration(milliseconds: 1600),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'Garamond',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
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
                              color: Color(0xFFFFD700),
                              fontFamily: 'Garamond',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
       );
  }

  Widget makeInput({
    String? label,
    bool obscureText = false,
    Color? textColor,
    Color? borderColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label ?? '',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: textColor ?? Colors.white,
            fontFamily: 'Garamond',
          ),
        ),
        SizedBox(height: 5),
        TextField(
          obscureText: obscureText,
          style: TextStyle(color: textColor ?? Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.black.withOpacity(0.3), // transparan gelap
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? Colors.white54),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? Color(0xFFFFD700)),
              borderRadius: BorderRadius.circular(8),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor ?? Colors.white54),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
