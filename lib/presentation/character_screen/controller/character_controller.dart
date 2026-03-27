import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:pridesys_app/core/database/db_helper.dart';
import 'package:pridesys_app/core/service/shared_preferences_helper.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;

  var characters = <dynamic>[].obs;
  var filteredCharacters = <dynamic>[].obs;

  var page = 1.obs;

  // 🔍 FILTER STATE
  var searchQuery = ''.obs;
  var selectedStatus = ''.obs;
  var selectedSpecies = ''.obs;

  // ❤️ FAVORITES
  var favorites = <int>[].obs;

  // ✏️ LOCAL EDITS
  var editedCharacters = <int, Map<String, dynamic>>{}.obs;

  final baseUrl = 'https://rickandmortyapi.com/api/character';

  // ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    loadEdits();
    fetchCharacters();
  }

  // ================= FAVORITES =================
  void toggleFavorite(int id) async {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    await SharedPreferencesHelper.saveFavorites(favorites.toSet());
  }

  bool isFavorite(int id) => favorites.contains(id);

  Future<void> loadFavorites() async {
    final stored = await SharedPreferencesHelper.getFavorites();
    favorites.value = stored.toList();
  }

  // ================= FETCH + CACHE =================
  Future<void> fetchCharacters() async {
    try {
      isLoading.value = true;

      final response = await http.get(Uri.parse('$baseUrl?page=${page.value}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'];

        characters.addAll(results);

        // 🔥 CACHE
        await cacheCharacters(results);

        // 🔥 APPLY FILTER AFTER LOAD
        applyFilters();

        page.value++;
      }
    } catch (e) {
      // 🔥 OFFLINE MODE
      final cached = await getCachedCharacters();

      if (characters.isEmpty) {
        characters.value = cached;

        applyFilters(); // 🔥 IMPORTANT
      }
    } finally {
      isLoading.value = false;
    }
  }

  void refreshCharacters() {
    characters.clear();
    filteredCharacters.clear();
    page.value = 1;
    fetchCharacters();
  }

  // ================= FILTER + SEARCH =================
  void applyFilters() {
    List data = characters.map((e) => getCharacter(e)).toList();

    // 🔍 SEARCH
    if (searchQuery.value.isNotEmpty) {
      data = data.where((char) {
        return char['name'].toString().toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        );
      }).toList();
    }

    // 🎯 STATUS
    if (selectedStatus.value.isNotEmpty) {
      data = data
          .where((char) => char['status'] == selectedStatus.value)
          .toList();
    }

    // 🎯 SPECIES
    if (selectedSpecies.value.isNotEmpty) {
      data = data
          .where((char) => char['species'] == selectedSpecies.value)
          .toList();
    }

    filteredCharacters.value = data;
  }

  void search(String value) {
    searchQuery.value = value;
    applyFilters();
  }

  void setStatus(String status) {
    selectedStatus.value = status;
    applyFilters();
  }

  void setSpecies(String species) {
    selectedSpecies.value = species;
    applyFilters();
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedStatus.value = '';
    selectedSpecies.value = '';
    applyFilters();
  }

  // ================= SQLITE CACHE =================
  Future<void> cacheCharacters(List list) async {
    final db = await DBHelper.db;

    for (var char in list) {
      await db.insert('characters', {
        'id': char['id'],
        'data': jsonEncode(char),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List> getCachedCharacters() async {
    final db = await DBHelper.db;

    final result = await db.query('characters');

    return result.map((e) => jsonDecode(e['data'] as String)).toList();
  }

  // ================= EDIT SYSTEM =================

  Future<void> loadEdits() async {
    final db = await DBHelper.db;

    final result = await db.query('edits');

    editedCharacters.value = {
      for (var e in result) e['id'] as int: jsonDecode(e['data'] as String),
    };
  }

  Future<void> saveEdit(int id, Map<String, dynamic> data) async {
    final db = await DBHelper.db;

    await db.insert('edits', {
      'id': id,
      'data': jsonEncode(data),
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    editedCharacters[id] = data;

    applyFilters(); // 🔥 UPDATE UI
  }

  Future<void> resetEdit(int id) async {
    final db = await DBHelper.db;

    await db.delete('edits', where: 'id = ?', whereArgs: [id]);

    editedCharacters.remove(id);

    applyFilters(); // 🔥 UPDATE UI
  }

  Map<String, dynamic> getCharacter(dynamic character) {
    final id = character['id'];

    if (editedCharacters.containsKey(id)) {
      return {...character, ...editedCharacters[id]!};
    }

    return character;
  }
}
