// import 'package:docs_clone_flutter/screens/document.dart';
import 'package:docs_clone_tutorial/screens/document.dart';
import 'package:docs_clone_tutorial/screens/home.dart';
import 'package:docs_clone_tutorial/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: HomeScreen()),
  '/document/:id': (route) => MaterialPage(
        child: DocumentScreen(
          id: route.pathParameters['id'] ?? '',
        ),
      ),
});
