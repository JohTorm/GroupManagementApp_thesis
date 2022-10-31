import 'dart:convert';
import 'package:app/mvvm/event.dart';
import 'package:http/http.dart' as http;
class Webservice {
  Future<List<Event>> fetchMovies(String keyword) async {
    final url = 'http://www.omdbapi.com/?s=$keyword&apikey=eb0d5538';
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body["Search"];
      return json.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }
}