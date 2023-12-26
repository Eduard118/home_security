import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_flutter_v2/globals/globals.dart';
import 'package:test_flutter_v2/screens/loginPage.dart';
import 'package:test_flutter_v2/services/auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController _psswConfirmTeC = TextEditingController();

  final AuthService _auth = AuthService();


  bool showPssw = false;
  bool showConfirmPssw = false;
  bool psswRequirements = false;
  bool matchedPssw = false;

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
                    const Text('Create Account', textAlign: TextAlign.center ,style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 38
                    ),),

                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Sign up to explore your home security privileges.", textAlign: TextAlign.center, style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),),
                    ),

                    const SizedBox(height: 30,),

                    TextFormField(
                      controller: emailCtrl,
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
                      controller: passwordController,
                      obscureText: showPssw ? false : true,
                      decoration: InputDecoration(
                          errorText: psswRequirements ? null : '8+ characters, mix of letters and numbers',
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
                      onChanged: (v){
                        final regex = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d).+$');

                        if(v.length >= 8 && regex.hasMatch(v)){
                          psswRequirements = true;
                        }else{
                          psswRequirements = false;
                        }
                        setState(() {

                        });
                      },
                    ),

                    const SizedBox(height: 20,),

                    TextFormField(
                      controller: _psswConfirmTeC,
                      obscureText: showConfirmPssw ? false : true,
                      decoration: InputDecoration(
                        errorText: matchedPssw ? null : "Passwords don't match",
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
                              showConfirmPssw = !showConfirmPssw;
                              setState(() {

                              });
                            },
                            child: showConfirmPssw ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility)),
                        filled: true,
                        fillColor: Colors.blue.withOpacity(0.2),
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(fontWeight: FontWeight.bold),

                      ),
                      onChanged: (v){
                        if(_psswConfirmTeC.text == passwordController.text){
                          matchedPssw = true;
                        }else{
                          matchedPssw = false;
                        }
                        setState(() {

                        });
                      },
                    ),

                    const SizedBox(height: 30,),

                    InkWell(
                      onTap: () async{
                        await registerAccount();
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
                          child: Text('Sign up', style: TextStyle(
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
                            MaterialPageRoute(builder: (context) => const LoginPage())
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Already have an account', style: TextStyle(
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
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(Icons.g_mobiledata, size: 40,),
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

  Future<void> registerAccount() async  {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();

    /*if(!RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)").hasMatch(emailCtrl.text)||passwordController.text.length < 6){

      if(!RegExp(r"(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)").hasMatch(emailCtrl.text)){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ));
        emailCtrl.value = emailCtrl.value.copyWith(selection: TextSelection(baseOffset: 0, extentOffset: emailCtrl.text.length));
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ));
        passwordController.value = passwordController.value.copyWith(selection: TextSelection(baseOffset: 0, extentOffset: passwordController.text.length));
      }

      return;
    }*/
    try {
      if (checkCredentialsForSignUp()) {
        String? text;
        if(mounted) {
          setState(() {
            emailCtrl.text = emailCtrl.text.replaceAll(RegExp(r"\s*"), '');
          });
        }

        dynamic result = await _auth.registerWithEmailAndPassword(emailCtrl.text, passwordController.text);
        if (result == null) {
          setState(() {
            emailCtrl.clear();
            passwordController.clear();
            _psswConfirmTeC.clear();

          });

        }
        else if (result == false){

          await showSuccessAccCreated();

          setState(() {
            emailCtrl.clear();
            passwordController.clear();
            _psswConfirmTeC.clear();
          });
          ///TODO - PRESENT ERROR HERE
          //await _presentError(text);
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ));
      }
    }
    catch(e) {
      emailCtrl.clear();
      passwordController.clear();
      _psswConfirmTeC.clear();
    }
    /*emailCtrl.clear();
    passwordController.clear();
    _psswConfirmTeC.clear();*/
  }

  bool checkCredentialsForSignUp(){
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    bool isEmailValid = passwordController.text.isNotEmpty && !regex.hasMatch(passwordController.text);


    if(emailCtrl.text.isNotEmpty && passwordController.text.isNotEmpty && _psswConfirmTeC.text.isNotEmpty && isEmailValid){
      if(passwordController.text == _psswConfirmTeC.text){
        return true;
      }
    }else{
      return false;
    }

    return false;
  }

  Future<void> showSuccessAccCreated() async{
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder:(BuildContext context) => AlertDialog(

          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage())
                  );
                },
                child: const Text('Ok', style: TextStyle(
                  fontSize: 20,
                )),
              ),
            )

          ],
          title: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: SizedBox(height: 1,)),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.check_circle_outline, color: Colors.green, size: 50,),
                ),
                Expanded(child: SizedBox(height: 1,)),
              ],
            ),
          ),
          content: Text("Account created successfully.\n Check your email to activate it.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Globals.darkmode ? Colors.white54 : Colors.black54
          ),),
        ));
  }
}

