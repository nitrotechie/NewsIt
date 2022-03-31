// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:news_it/screens/sign_in.dart';
import 'package:news_it/services/helperfunction.dart';
import 'package:news_it/widgets/widgets.dart';
import 'package:http/http.dart' as http;

Future<User> googleSign() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

  var _authentication = await _googleSignInAccount!.authentication;
  var _credential = GoogleAuthProvider.credential(
    idToken: _authentication.idToken,
    accessToken: _authentication.accessToken,
  );

  User? user = (await _auth.signInWithCredential(_credential)).user;
  HelperFunctions.saveUserLoggedInSharedPreference(true);
  user!.updatePhotoURL(user.photoURL);
  return user;
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      HelperFunctions.saveUserLoggedInSharedPreference(false);
      Data.image = "";
      Data.userName = "Anon";
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const SignIn()));
    });
  } catch (e) {
    var ef = e;
  }
}

Future<bool> createAccountEmail(
    String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  var photo = "";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      // ignore: deprecated_member_use
      user.updateProfile(displayName: name);
      user.updatePhotoURL(photo);
      user.updateDisplayName(name);

      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        "name": name,
        "email": email,
        "status": "Unavalible",
        "uid": _auth.currentUser!.uid,
      });
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> logInEmail(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          // ignore: deprecated_member_use
          .then((value) => user.updateProfile(displayName: value['name']));
      HelperFunctions.saveUserLoggedInSharedPreference(true);
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

Future<bool> isEmailRegistered(String email) async {
  final QuerySnapshot result = await FirebaseFirestore.instance
      .collection('users')
      .where('email', isEqualTo: email)
      .limit(1)
      .get();
  final List<DocumentSnapshot> documents = result.docs;
  if (documents.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

// bool getIsBookmark(String description) {
//   FirebaseAuth _auth = FirebaseAuth.instance;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   try {
//     _firestore
//         .collection('users')
//         .doc(_auth.currentUser!.uid)
//         .collection('bookmarks')
//         .where('description', isEqualTo: description)
//         .get()
//         .then((value) {
//           // for (var i in value) {

//           // }
//     });
//   } catch (e) {}
// }

Future<bool> setBookmarks(String sourceName, String imageUrl, String title,
    String description, String url, String author, String publishDate) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    await _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('bookmarks')
        .doc(title)
        .set({
      "sourceName": sourceName,
      "imageUrl": imageUrl,
      "title": title,
      "description": description,
      "url": url,
      "author": author,
      "publishDate": publishDate,
    });
    return true;
  } catch (e) {
    return false;
  }
}

delete(String title) {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('bookmarks')
      .doc(title)
      .delete();
}

class Data {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static List<String> bookmark = [];
  static String userName = "Anon";
  static String api = "";
  static getUsername() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userName = user.displayName.toString();
    }
  }

  static String image = "";
  static getImage() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      image = user.photoURL.toString();
    }
  }

  getApiId() {
    _firestore.collection('api').doc('api-id').get().then((value) {
      api = value['api'];
      print(api);
    });
  }

  getBookmark(String description) {
    _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('bookmarks')
        .doc(description)
        .get()
        .then((value) {
      bookmark.add(value['description']);
      print("This is a");
      print(bookmark);
    });
  }

  static String getDate(String date) {
    return DateFormat.yMMMd().format(DateTime.parse(date)).toString();
  }
}

class News {
  static var newsUrl = "";
  static var title = "";
  static var sourceName = "";
  static var imageUrl = "";
  static var description = "";
  static var author = "";
  static var publishDate = "";
  static var api = Data.api;
  static var url =
      "https://newsapi.org/v2/top-headlines?country=in&pageSize=100&apiKey=$api";
  static var index = 0;
  Dio d = Dio();
  List news = [];
  static String topHeadlineUrl =
      "https://newsapi.org/v2/top-headlines?country=in&apiKey=$api";
  static String businessUrl =
      "https://newsapi.org/v2/top-headlines?country=in&category=business&apiKey=$api";
  static String entertainment =
      "https://newsapi.org/v2/top-headlines?country=in&category=entertainment&apiKey=$api";
  static String health =
      "https://newsapi.org/v2/top-headlines?country=in&category=health&apiKey=$api";
  static String science =
      "https://newsapi.org/v2/top-headlines?country=in&category=science&apiKey=$api";
  static String sports =
      "https://newsapi.org/v2/top-headlines?country=in&category=sports&apiKey=$api";
  static String technology =
      "https://newsapi.org/v2/top-headlines?country=in&category=technology&apiKey=$api";
  static String searchKeyword = "";
  static String searchUrl =
      "https://newsapi.org/v2/everything?q=$searchKeyword&apiKey=$api";
  Future<void> getNews(String url) async {
    var response = await http.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(element);
        }
      });
    }
  }
}
