import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_it/screens/bookmarks.dart';
import 'package:news_it/screens/home_screen.dart';
import 'package:news_it/screens/sign_in.dart';
import 'package:news_it/services/services.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 250,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
              color: Theme.of(context).canvasColor,
            ),
            child: Container(
              margin: const EdgeInsets.only(
                top: 55,
                bottom: 52,
                left: 20,
                right: 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      iconSize: 35,
                    ),
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        GestureDetector(
                          child: Row(
                            children: const [
                              Icon(Icons.home),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Home",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomeScreen()));
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          child: Row(
                            children: const [
                              Icon(Icons.bookmark),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Bookmarks",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const BookmarkScreen()));
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        user == null
                            ? GestureDetector(
                                child: Row(
                                  children: const [
                                    Icon(Icons.login),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Log In",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const SignIn()));
                                },
                              )
                            : GestureDetector(
                                child: Row(
                                  children: const [
                                    Icon(Icons.logout),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Log Out",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  logOut(context);
                                },
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
