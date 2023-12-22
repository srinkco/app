import 'dart:convert';

import 'package:http/http.dart' as http;

class SrinkResponse {
  final bool ok;
  String url = "";
  String error = "";

  SrinkResponse({
    required this.ok,
    required this.error,
    required this.url,
  });

  factory SrinkResponse.parseJson(Map<String, dynamic> data) {
    return SrinkResponse(
      ok: data['ok'],
      error: data['error'] ?? "",
      url: data['shortened_url'] ?? "",
    );
  }
}

Future<SrinkResponse> shortenUrl(String url, String hash, String token) async {
  final resp = await http.get(
    Uri.parse('https://srink.co/api/new?token=$token&hash=$hash&url=$url'),
  );
  if (resp.body.isNotEmpty) {
    return SrinkResponse.parseJson(
        jsonDecode(resp.body) as Map<String, dynamic>);
  } else {
    throw Exception("failed to make shorten url: statue: ${resp.statusCode}");
  }
}
