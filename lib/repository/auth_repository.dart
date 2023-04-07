import 'dart:convert';
import 'dart:developer';

import 'package:docs_clone_tutorial/constants.dart';
import 'package:docs_clone_tutorial/models/error.dart';
import 'package:docs_clone_tutorial/models/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // Provider support
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

// Read-only access to the repository
final authRepositoryProvider = Provider(
    (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()));

// Read-write access to a shared User state
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        final userAcc = UserModel(
            email: user.email,
            name: user.displayName ?? "",
            profilePic: user.photoUrl ?? "",
            uid: "",
            token: "");

        var res = await _client.post(Uri.parse("$host/api/signup"),
            body: userAcc.toJson(),
            headers: {
              "Content-Type": "application/json; charset=UTF-8",
            });

        switch (res.statusCode) {
          case 200:
            userAcc.uid = jsonDecode(res.body)["user"]["_id"];
            userAcc.token = jsonDecode(res.body)["token"];
            error = ErrorModel(error: null, data: userAcc);
            break;
          default:
            log("Error");
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }
}
