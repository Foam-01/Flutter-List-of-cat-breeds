import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat_breed.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000'; // เปลี่ยนเป็น URL จริงถ้า deploy

  Future<List<CatBreed>> fetchCatBreeds() async {
    final response = await http.get(Uri.parse('$baseUrl/cats'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => CatBreed.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cat breeds');
    }
  }

  Future<CatBreed> addCatBreed(CatBreed cat) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cats'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': cat.name,
        'origin': cat.origin,
        'description': cat.description,
      }),
    );

    if (response.statusCode == 201) {
      return CatBreed.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add cat breed');
    }
  }

  Future<CatBreed> updateCatBreed(CatBreed cat) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cats/${cat.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': cat.name,
        'origin': cat.origin,
        'description': cat.description,
      }),
    );

    if (response.statusCode == 200) {
      return CatBreed.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update cat breed');
    }
  }

  Future<void> deleteCatBreed(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/cats/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete cat breed');
    }
  }
}
