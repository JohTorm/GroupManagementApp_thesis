import 'dart:convert';
import 'package:app/model/event.dart';
import 'package:http/http.dart' as http;

import '../model/user.dart';
import '../model/event.dart';
class Webservice {
  final ip = 'http://localhost:3001';


  Future<List<Event>> fetchMovies(String keyword) async {
    final url = 'http://www.omdbapi.com/?s=$keyword&apikey=eb0d5538';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final Iterable json = body["Search"];
      return json.map((event) => Event.fromJson(event)).toList();
    } else {
      throw Exception("Unable to perform request!");
    }
  }


  signUp(String email,String nickname, String pwd) async {
    final response = await http.post(
      Uri.parse('$ip/api/create/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nickname': nickname,
        'email': email,
        'password': pwd,
      }),
    );
    if (response.statusCode == 200) {

      return jsonDecode(response.body)['statusCheck'];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  login(String email, String pwd) async {
    final response = await http.post(
      Uri.parse('$ip/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{

        'email': email,
        'password': pwd,
      }),
    );
    if (response.statusCode == 200) {

      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  createGroup(String groupName,String email,) async {
    final response = await http.post(
      Uri.parse('$ip/api/create/group'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'GroupName': groupName,
      }),
    );
    if (response.statusCode == 200) {


      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }


  getUserGroups(String email) async {
    final response = await http.post(
      Uri.parse('$ip/api/user/groups'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    if (response.statusCode == 200) {

      return jsonDecode(response.body);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  getUserEvents(String email) async {
    final response = await http.post(
      Uri.parse('$ip/api/user/events'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    if (response.statusCode == 200) {



      return jsonDecode(response.body)["UsersEvents"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  getGroupMembers(String id) async {
    final response = await http.post(
      Uri.parse('$ip/api/group/members'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'groupId': id,
      }),
    );
    if (response.statusCode == 200) {



      return jsonDecode(response.body)["groupMembers"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  getGroupEvents(String id, String email) async {

    final response = await http.post(
      Uri.parse('$ip/api/group/events'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'idGroup': id,
        'email': email,
      }),
    );
    if (response.statusCode == 200) {



      return jsonDecode(response.body)["GroupEvents"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }


  createEvent(event, groupId, email) async {

    final response = await http.post(
      Uri.parse('$ip/api/create/event'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'idGroup': groupId,
        'EventName': event.eventName,
        'EventStartDate': event.startDate,
        'EventEndDate': event.endDate,
        'EventLocation': event.location,
        'EventInfo': event.info,
      }),
    );
    if (response.statusCode == 200) {


      return jsonDecode(json.encode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  signToEvent(email, eventId, entryType) async {


    final response = await http.post(
      Uri.parse('$ip/api/group/events/signtoevent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'idEvent': eventId,
        'email': email,
        'entryType': entryType,
      }),
    );
    if (response.statusCode == 200) {

      return jsonDecode(json.encode(response.body));
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  addToGroup(email, groupPassword) async {


    final response = await http.post(
      Uri.parse('$ip/api/group/addtogroup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'groupPassword': groupPassword,
      }),
    );
    if (response.statusCode == 200) {

      return jsonDecode(response.body)["AddtogroupResponse"][0]["message"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  deleteEvent(eventId) async {

    final response = await http.post(
      Uri.parse('$ip/api/delete/event'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'idEvent': eventId,
      }),
    );
    if (response.statusCode == 200) {

      return jsonDecode(response.body)["message"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  deleteGroup(groupId) async {

    final response = await http.post(
      Uri.parse('$ip/api/delete/group'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'idGroup': groupId,
      }),
    );
    if (response.statusCode == 200) {

      return jsonDecode(response.body)["message"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

  kickUser(groupId, userId) async {

    final response = await http.post(
      Uri.parse('$ip/api/kick/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'idGroup': groupId,
        'idUser': userId
      }),
    );
    if (response.statusCode == 200) {

      return jsonDecode(response.body)["KickUserResponse"][0]["message"];
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }

}