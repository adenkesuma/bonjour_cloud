import 'package:bonjour/Modul/Login/login_controller.dart';
import 'package:bonjour/analytic_helper.dart';
import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  MyAnalyticsHelper analytic = MyAnalyticsHelper();
  @override
  Widget build(BuildContext context) {
  final loginCtrl = Provider.of<LoginController>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: primaryColor),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('${logoCompany}')
                      )
                    ),
                  ),
                  Text('Sign in to continue',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white,)),
                  SizedBox(height: 30,),
                  Container(
                    width: 350,
                    child: TextFormField(
                      controller: loginCtrl.username,
                      decoration: InputDecoration(
                        errorText: loginCtrl.errname ? "Username can't empty" : null,
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Username',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.person, color: Colors.white, size: 20,),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(width: 2,color: Colors.white38),
                        ),
                        enabledBorder: OutlineInputBorder( // Default border when not focused
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(width: 1, color: Colors.white38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(width: 2,color: Colors.white38),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
                    width: 350,
                    child: TextFormField(
                      controller: loginCtrl.password,
                      obscureText: loginCtrl.obscure,
                      decoration: InputDecoration(
                        errorText: loginCtrl.errpass ? "Incorrect password. Please try again." : null,
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.lock, color: Colors.white, size: 20,),
                        suffixIcon: IconButton(
                          onPressed: loginCtrl.onOffSecure, 
                          icon: Icon(loginCtrl.obscure ? Icons.visibility : Icons.visibility_off, color: Colors.white, size: 20,)
                        ),  
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(width: 2,color: Colors.white38),
                        ),
                        enabledBorder: OutlineInputBorder( // Default border when not focused
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(width: 1, color: Colors.white38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(width: 2,color: Colors.white38),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(color: Color.fromARGB(255, 255, 0, 0)),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 15,),
                  SizedBox(
                    width: 350,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                      ),
                      onPressed: () {
                        analytic.navigatorEvent("Login");
                        loginCtrl.login();
                      },
                      child: Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),)
                    )
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