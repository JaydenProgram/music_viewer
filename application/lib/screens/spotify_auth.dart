import 'dart:math';
import 'dart:convert' show base64Url, jsonDecode, utf8;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:core';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

final SharedPreferencesAsync prefs = SharedPreferencesAsync();
const clientId = "";
String? code;

Future<Map<String, dynamic>?> startSpotifyAuthFlow() async {
  final serverFuture = setupServer(); //sets up the server instantly
  await redirectToAuthCodeFlow(
    clientId,
  ); //redirects the user where they need to be
  final authCode =
      await serverFuture; //wait for the code to get returned by the redirect
  final accessToken = await getAccessToken(
    clientId,
    authCode,
  ); //use that code to get the accesstoken for the user
  final recentlyPlayed = await fetchProfile(
    accessToken,
    path: "/player/recently-played",
  ); //fetch the profile using this accesstoken
  return recentlyPlayed; //return profile information
}

//Sets up the server to check the code parameter which makes the user able to log in
Future<String> setupServer() async {
  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    5173,
  ); //set back to anyipv4 at home
  print('Listening on ${server.address.address}:${server.port}');

  await for (final request in server) {
    print('Incoming path: ${request.uri.path} query: ${request.uri.query}');

    if (request.uri.path == '/callback' || request.uri.path == '/callback/') {
      final code = request.uri.queryParameters['code'];
      if (code == null) {
        request.response.statusCode = 400;
        request.response.write('Missing code');
        await request.response.close();
        continue;
      }

      request.response.write('Success, you can close this tab.');
      await request.response.close();
      await server.close(force: true);
      return code;
    }

    request.response.statusCode = 404;
    await request.response.close();
  }

  throw Exception('Server closed before callback');
}

Future<void> redirectToAuthCodeFlow(String clientId) async {
  final verifier = generateCodeVerifier(128);
  final challenge = await generateCodeChallenge(verifier);

  await prefs.setString("verifier", verifier);

  final params = {
    "client_id": clientId,
    "response_type": "code",
    "redirect_uri": "http://127.0.0.1:5173/callback",
    "scope":
        "user-read-private user-read-email user-read-currently-playing user-read-recently-played",
    "code_challenge_method": "S256",
    "code_challenge": challenge,
  };

  final authorizeUrl = Uri(
    scheme: "https",
    host: "accounts.spotify.com",
    path: "/authorize",
    queryParameters: params,
  );

  launchUrl(authorizeUrl, mode: .externalNonBrowserApplication);
}

Future<String> getAccessToken(String clientId, String code) async {
  final verifier = await prefs.getString("verifier");

  final params = {
    "client_id": clientId,
    "grant_type": "authorization_code",
    "code": code,
    "redirect_uri": "http://127.0.0.1:5173/callback",
    "code_verifier": verifier!,
  };

  final result = await http.post(
    Uri.parse("https://accounts.spotify.com/api/token"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: params,
  );

  final data = jsonDecode(result.body);
  return data["access_token"] as String;
}

Future<Map<String, dynamic>?> fetchProfile(String token, {String? path}) async {
  try {
    final result = await http.get(
      path == null
          ? Uri.parse("https://api.spotify.com/v1/me")
          : Uri.parse("https://api.spotify.com/v1/me$path"),
      headers: <String, String>{"Authorization": "Bearer $token"},
    );
    if (result.statusCode == 200) {
      return await jsonDecode(result.body) as Map<String, dynamic>;
    } else {
      throw Exception("Server error: ${result.statusCode}");
    }
  } catch (e) {
    throw Exception("Network error: $e");
  }
}

dynamic returnProfile(dynamic profile) {}

String generateCodeVerifier(num length) {
  var text = '';
  const possible =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  for (var i = 0; i < length; i++) {
    text += possible[Random().nextInt(possible.length).floor()];
  }

  return text;
}

Future<String> generateCodeChallenge(String codeVerifier) async {
  final data = utf8.encode(codeVerifier);
  final digest = sha256.convert(data);
  return base64Url.encode(digest.bytes).replaceAll('=', '');
}
