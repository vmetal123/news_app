import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:informe_pastran_app/models/entry_model.dart';

class ApiService {

  final client = http.Client();

  ApiService();

  Future<List<Entry>> getEntries() async {
    
    final response = await client.get("http://10.0.2.2/Api/api/app");

    List<Entry> entries;

    if(response.statusCode == 200){
      List result = json.decode(response.body) as List;

      entries = result.map((data) => Entry.fromJson(data)).toList();
    }

    return entries;
    
  }

}