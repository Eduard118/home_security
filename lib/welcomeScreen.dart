import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_v2/signupPage.dart';

import 'loginPage.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
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

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(child: SizedBox(width: 1,)),

                Image.asset('assets/images/welcomepage.png'),

                const Text('Discover \n Home Security', textAlign: TextAlign.center ,style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    fontSize: 40
                ),),

                const Text('Peace of mind, one tap away', style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                ),),

                const Expanded(child: SizedBox(width: 1,)),

                Row(
                  children: [
                    const Expanded(child: SizedBox(height: 1,)),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      },
                      child: Container(
                        height: 55,
                        width: 170,
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
                          child: Text('Login', style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                          ),),
                        ),
                      ),
                    ),

                    const Expanded(child: SizedBox(height: 1,)),

                    InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignupPage())
                        );
                      },
                      child: const Text('Register', textAlign: TextAlign.center,style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          shadows: [
                            Shadow(
                                color: Colors.black12,
                                offset: Offset(-2, 3)
                            )
                          ]
                      ),),
                    ),

                    const Expanded(child: SizedBox(height: 1,)),
                  ],
                ),

                const Expanded(child: SizedBox(width: 1,)),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
