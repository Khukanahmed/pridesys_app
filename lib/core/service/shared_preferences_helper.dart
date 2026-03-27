import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._();

  // ── Keys ──────────────────────────────────────────────────────────────────

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUsername = 'username';
  static const String _keyName = 'name';
  static const String _keyEmail = 'email';
  static const String _keyImage = 'image';
  static const String _keyIsDarkMode = 'is_dark_mode';
  static const String _keyFavorites = 'favorites';

  // ── Save user session ─────────────────────────────────────────────────────

  static Future<void> saveUserSession({
    required String accessToken,
    required String refreshToken,
    required String username,
    required String name,
    required String email,
    required String image,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_keyAccessToken, accessToken),
      prefs.setString(_keyRefreshToken, refreshToken),
      prefs.setString(_keyUsername, username),
      prefs.setString(_keyName, name),
      prefs.setString(_keyEmail, email),
      prefs.setString(_keyImage, image),
    ]);
  }

  // ── Favorites ─────────────────────────────────────────────

  static Future<void> saveFavorites(Set<int> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final list = favorites.map((e) => e.toString()).toList();
    await prefs.setStringList(_keyFavorites, list);
  }

  static Future<Set<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_keyFavorites) ?? [];
    return list.map((e) => int.parse(e)).toSet();
  }

  // ── Getters ───────────────────────────────────────────────────────────────

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  static Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyName);
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<String?> getImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyImage);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_keyAccessToken);
    return token != null && token.isNotEmpty;
  }

  // ── Theme ─────────────────────────────────────────────────────────────────

  static Future<void> saveTheme({required bool isDark}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsDarkMode, isDark);
  }

  static Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsDarkMode) ?? false;
  }

  // ── Clear session ─────────────────────────────────────────────────────────

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.remove(_keyAccessToken),
      prefs.remove(_keyRefreshToken),
      prefs.remove(_keyUsername),
      prefs.remove(_keyName),
      prefs.remove(_keyEmail),
      prefs.remove(_keyImage),
    ]);
  }
}
