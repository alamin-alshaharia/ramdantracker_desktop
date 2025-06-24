import 'dart:convert';
import 'package:http/http.dart' as http;

class QuranService {
  static const String baseUrl = 'http://api.alquran.cloud/v1';
  static const String audioBaseUrlJuz = 'https://cdn.islamic.network/quran/sounds/128/ar.alafasy/';
  static const String audioBaseUrlSurah = 'https://cdn.islamic.network/quran/sounds-surah/128/ar.alafasy/';

  Future<List<dynamic>> listSurahs() async {
    final response = await http.get(Uri.parse('$baseUrl/surah'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load surahs');
    }
  }

  Future<Map<String, dynamic>> getSurahDetails(int number) async {
    final response = await http.get(Uri.parse('$baseUrl/surah/$number'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load surah details');
    }
  }

  Future<Map<String, dynamic>> getSurahWithTranslations(int number) async {
    final response = await http.get(Uri.parse('$baseUrl/surah/$number/editions/quran-uthmani,en.asad,bn.bengali'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load surah with translations');
    }
  }

  Future<Map<String, dynamic>> getJuzWithTranslations(int number) async {
    final response = await http.get(Uri.parse('$baseUrl/juz/$number/editions/quran-uthmani,en.asad,bn.bengali'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load juz with translations');
    }
  }

  Future<Map<String, dynamic>> search(String query) async {
    final response = await http.get(Uri.parse('$baseUrl/search/$query/all/en.asad,bn.bengali'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to search Quran');
    }
  }

  Future<List<dynamic>> getSajdaVerses() async {
    final response = await http.get(Uri.parse('$baseUrl/sajda/quran-uthmani'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['ayahs'];
    } else {
      throw Exception('Failed to load sajda verses');
    }
  }

  String getJuzAudioUrl(int number) {
    return 'audioBaseUrlJuz$number.mp3';
  }

  String getSurahAudioUrl(int number) {
    return 'audioBaseUrlSurah$number.mp3';
  }
} 