import 'dart:convert';
import 'package:http/http.dart' as http;

class HadithService {
  // Static list of supported collections
  static const List<String> collections = [
    'bukhari', 'muslim', 'abudawud', 'tirmidhi', 'nasai', 'ibnmajah', 'malik', 'ahmad'
  ];

  static String get baseUrl => 'https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions';

  // Get all hadiths for a collection (book)
  Future<List<dynamic>> getHadithsByBook(String collection) async {
    final url = '$baseUrl/eng-$collection.min.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body)['hadiths'];
    } else {
      throw Exception('Failed to load hadiths for $collection');
    }
  }

  // Get a single hadith by collection and hadith number
  Future<Map<String, dynamic>> getHadithById(String collection, int hadithNumber) async {
    final url = '$baseUrl/eng-$collection/$hadithNumber.min.json';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load hadith $hadithNumber from $collection');
    }
  }

  // Local search (to be implemented in provider/UI)
} 