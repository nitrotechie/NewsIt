import 'package:flutter/material.dart';
import 'package:news_it/screens/home_screen.dart';
import 'package:news_it/screens/sign_in.dart';
import 'package:news_it/services/helperfunction.dart';
import 'package:news_it/services/services.dart';
import 'package:news_it/utils/themes.dart';
import 'package:news_it/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController name = TextEditingController();
  final TextEditingController emailid = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool changeButton = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Container(
                      height: 25,
                      width: 150,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            MyTheme.gradientColor1,
                            MyTheme.gradientColor2,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Center(
                        child: Text(
                          "Skip for Now",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomeScreen()));
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.15,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 400,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  height: 420,
                  width: 320,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  height: 440,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 60, 60, 10),
                          child: TextFormField(
                            controller: name,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                                hintText: "Enter Your Name",
                                labelText: "Name"),
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter Your Name";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 60, 10),
                          child: TextFormField(
                            controller: emailid,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                                hintText: "Enter Your Email Address",
                                labelText: "Email Address"),
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter Your Email Address";
                              } else if (!RegExp(r'\S+@\S+\.\S+')
                                  .hasMatch(value)) {
                                return "Please Enter A Valid Email Address";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 60, 20),
                          child: TextFormField(
                            controller: _pass,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Theme.of(context).secondaryHeaderColor,
                                ),
                              ),
                              hintText: "Enter Password",
                              labelText: "Password",
                            ),
                            validator: (value) {
                              if (value == null) {
                                return "Please Enter Password";
                              } else if (value.length < 8) {
                                return "Please Enter Minimum Eight Characters Password";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 60, 20),
                          child: Container(
                            width: changeButton == true ? 35 : 300,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    MyTheme.gradientColor1,
                                    MyTheme.gradientColor2,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25)),
                            child: changeButton == true
                                ? const CircularProgressIndicator()
                                : TextButton(
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          changeButton = true;
                                        });
                                        isEmailRegistered(emailid.text)
                                            .then((value) {
                                          if (value) {
                                            final snackBar = SnackBar(
                                              content: const Text(
                                                  "This Email is already registered."),
                                              action: SnackBarAction(
                                                label: "Ok",
                                                textColor: Theme.of(context)
                                                    .canvasColor,
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            setState(() {
                                              changeButton = false;
                                            });
                                          } else {
                                            HelperFunctions
                                                .saveUserNameSharedPreference(
                                                    name.text);
                                            HelperFunctions
                                                .saveUserEmailSharedPreference(
                                                    emailid.text);
                                            setState(() {
                                              changeButton = true;
                                            });

                                            createAccountEmail(
                                              name.text,
                                              emailid.text,
                                              _pass.text,
                                            ).then((value) {
                                              if (value) {
                                                logInEmail(
                                                    emailid.text, _pass.text);
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen(),
                                                  ),
                                                );
                                              } else {
                                                final snackBar = SnackBar(
                                                  content: const Text(
                                                      "Something Went Wrong..."),
                                                  action: SnackBarAction(
                                                    label: "Ok",
                                                    textColor: Theme.of(context)
                                                        .canvasColor,
                                                    onPressed: () {},
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                setState(() {
                                                  changeButton == false;
                                                });
                                              }
                                            });
                                          }
                                        });
                                      }
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 110,
                  bottom: 390,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          MyTheme.gradientColor1,
                          MyTheme.gradientColor2,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: GoogleBtn1(),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignIn()));
              },
              child: const Text(
                "Already Have an account?",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
