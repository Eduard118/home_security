import 'package:flutter/material.dart';
import 'package:test_flutter_v2/screens/landingPage.dart';
import 'package:test_flutter_v2/services/auth.dart';
import 'dart:math' as math;

import 'package:test_flutter_v2/screens/signupPage.dart';

import '../globals/globals.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailTeC = TextEditingController();
  final TextEditingController _psswTeC = TextEditingController();

  bool showPssw = false;
  bool emailOrPsswWrong = false;

  final AuthService _auth = AuthService();

  Future<void> getLogInProcess() async{

    dynamic result = await _auth.signInWithEmailAndPassword(_emailTeC.text, _psswTeC.text);

    if(result != null){
      if(result != false){
        Globals.usEmail = _emailTeC.text;
        Globals.usPssw = _psswTeC.text;

        emailOrPsswWrong = false;
        if(context.mounted) {
          await Navigator.push(context,MaterialPageRoute(
            builder: (context) => const LandingPage(),
          ));
        }
      }
      else{
        emailOrPsswWrong = true;
      }
    }
    else{
      emailOrPsswWrong = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 300,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(500)
                  )
              ),
            ),
          ),

          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 400,
              width: 350,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border(

                    left: BorderSide(
                        color: Colors.blue.withOpacity(0.1),
                        width: 3),

                    bottom: BorderSide(
                        color: Colors.blue.withOpacity(0.1),
                        width: 3),
                  ),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(600)
                  )
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 230,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(

                  right: BorderSide(
                      color: Colors.blue.withOpacity(0.1),
                      width: 3),

                  top: BorderSide(
                      color: Colors.blue.withOpacity(0.1),
                      width: 3),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              height: 200,
              width: 130,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  right: BorderSide(
                      color: Colors.blue.withOpacity(0.1),
                      width: 3),

                  top: BorderSide(
                      color: Colors.blue.withOpacity(0.1),
                      width: 3),
                ),
              ),
            ),
          ),

          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Text('Login here', textAlign: TextAlign.center ,style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 40
                      ),),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Welcome back you've \n been missed!", textAlign: TextAlign.center, style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                    ),

                    const SizedBox(height: 30,),

                    TextFormField(
                      controller: _emailTeC,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blue)),

                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          filled: true,
                          fillColor: Colors.blue.withOpacity(0.2),
                          hintText: 'Email',
                          hintStyle: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),

                    const SizedBox(height: 20,),

                    TextFormField(
                      controller: _psswTeC,
                      obscureText: showPssw ? false : true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder:  const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blue)),

                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          suffixIcon: InkWell(
                              borderRadius: BorderRadius.circular(30),
                              onTap: (){
                                showPssw = !showPssw;
                                setState(() {

                                });
                              },
                              child: showPssw ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
                          filled: true,
                          fillColor: Colors.blue.withOpacity(0.2),
                          hintText: 'Password',
                          hintStyle: const TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: (){

                          },
                          child: const Text('Forgot your password?', style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    ),

                     emailOrPsswWrong ? const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text('Email or password invalid!', style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ) : const SizedBox.shrink(),
                    const SizedBox(height: 30,),

                    InkWell(
                      onTap: () async{
                        //var result = await _auth.signInWithEmailAndPassword(_emailTeC.text, _psswTeC.text);
                        await getLogInProcess();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(-3, 7)
                            )
                          ],
                        ),
                        child: const Center(
                          child: Text('Sign in', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage())
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Create new account', style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 8),
                      child: Text('Or continue with', style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            _auth.signInWithGoogle();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Icon(Icons.g_mobiledata, size: 40,),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right: 10, left: 10),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: const Icon(Icons.facebook, size: 35,),
                          ),
                        ),

                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(Icons.apple, size: 35,),
                        ),
                      ],
                    )
                  ]
              ),
            ),
          ),
        ],
      ),
    );
  }
}
