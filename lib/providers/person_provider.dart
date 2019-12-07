import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:prolimpia_mobile/models/person_model.dart';
import 'package:prolimpia_mobile/shared_preferences/shared_preferences.dart';

class PersonProvider {
  final _prefs = new PreferenciasUsuario();
  //String _url = 'http://192.168.100.199:8000/api/persons';
  String _url = 'http://prolimpia.duckdns.org:8080/prolimpia/public/api/persons';

  Future<List<Person>> search(String q) async {
    print('SEARCH');
    List<Person> personas = new List();
    final url = '$_url?q=$q';

    final authorizationHeaders = {
      HttpHeaders.authorizationHeader: 'bearer ${_prefs.user.token}'
    };

    final response = await http.get(url, headers: authorizationHeaders);
    print('Response status: ${response.statusCode}');
    
    final decodeData = json.decode(response.body);
    //final responseQ = new Persons.fromJsonList(decodeData);

    if (decodeData == null) return personas;
    
    decodeData.forEach((item) {
      final persona = Person.fromJson(item);
      personas.add(persona);
    });
    return personas;
  }
}
