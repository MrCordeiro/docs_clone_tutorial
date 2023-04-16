import 'dart:convert';
import 'dart:developer';

import 'package:docs_clone_tutorial/constants.dart';
import 'package:docs_clone_tutorial/models/error.dart';
import 'package:docs_clone_tutorial/models/user.dart';
import 'package:docs_clone_tutorial/services/local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Provider support
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

// Read-only access to the repository
final authRepositoryProvider = Provider((ref) => AuthRepository(
      googleSignIn: GoogleSignIn(),
      client: Client(),
      localStorageRepository: LocalStorageRepository(),
    ));

// Read-write access to a shared User state
final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository(
      {required GoogleSignIn googleSignIn,
      required Client client,
      required LocalStorageRepository localStorageRepository})
      : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      final userData = await _googleSignIn.signInSilently();
      if (userData != null) {
        final user = UserModel(
            email: userData.email,
            name: userData.displayName ?? "",
            profilePic: userData.photoUrl ?? "",
            uid: "",
            token: "");

        var res = await _client
            .post(Uri.parse('$host/api/signup'), body: user.toJson(), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        });

        switch (res.statusCode) {
          case 200:
            user.uid = jsonDecode(res.body)["user"]["_id"];
            user.token = jsonDecode(res.body)["token"];
            error = ErrorModel(error: null, data: user);
            _localStorageRepository.setToken(user.token);
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

  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        var res = await _client.get(Uri.parse('$host/'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });

        switch (res.statusCode) {
          case 200:
            UserModel user =
                UserModel.fromJson(jsonEncode(jsonDecode(res.body)["user"]))
                    .copyWith(token: token);
            error = ErrorModel(error: null, data: user);
            _localStorageRepository.setToken(user.token);
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

  void signOut() async {
    await _googleSignIn.signOut();
    _localStorageRepository.setToken('');
  }
}
