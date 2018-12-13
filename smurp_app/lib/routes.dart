// This file inspired by: https://medium.com/@kashifmin/flutter-login-app-using-rest-api-and-sqflite-b4815aed2149

import 'package:flutter/material.dart';
import 'history.dart';
import 'main.dart';
import 'package:smurp_app/history.dart';
import 'package:smurp_app/rated.dart';
import 'package:smurp_app/friends.dart';
import 'package:smurp_app/profile.dart';
import 'package:smurp_app/recommended.dart';
import 'package:smurp_app/main.dart';





// Container holding the routes to go to any page
final routes = {
  '/login':         (BuildContext context) => new LoginScreen(),
  '/history':         (BuildContext context) => new HistoryWidget(),
  '/' :          (BuildContext context) => new LoginScreen(),
  '/profile': (BuildContext context) => new ProfilePage(),
  '/recommended': (BuildContext context) => new RecommendedPage(),
  '/rated': (BuildContext context) => new RatedPage(),
  '/friends': (BuildContext context) => new FriendsPage(),
};