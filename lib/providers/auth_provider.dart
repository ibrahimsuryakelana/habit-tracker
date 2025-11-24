import 'dart:convert'; //ubah data jadi JSON
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart'; //hashing password atau ubah data menjadi kode unik untuk password
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class AuthProvider with ChangeNotifier {
  static const String _usersKey = 'habit_users'; 
  final Uuid _uuid = Uuid(); //untuk id unik

  List<UserModel> _users = [];
  UserModel? _currentUser;

  AuthProvider() {
    _loadUsers();
  }

  UserModel? get currentUser => _currentUser;

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_usersKey);
    if (raw != null) {
      final list = json.decode(raw) as List<dynamic>;
      _users = list.map((e) => UserModel.fromMap(Map<String, dynamic>.from(e))).toList();
    } else {
      _users = []; // start empty; allow register
    }
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _users.map((u) => u.toMap()).toList();
    await prefs.setString(_usersKey, json.encode(list)); // simpan dalam bentuk JSON
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<String?> register(String username, String password) async {
    username = username.trim();
    if (username.isEmpty || password.isEmpty) return 'Username/Password tidak boleh kosong';
    if (_users.any((u) => u.username == username)) return 'Username sudah ada';

    final newUser = UserModel(
      id: _uuid.v4(),
      username: username,
      passwordHash: _hashPassword(password),
    );
    _users.add(newUser);
    await _saveUsers();
    notifyListeners();
    return null;
  }

  Future<String?> login(String username, String password) async {
    username = username.trim();
    final hash = _hashPassword(password);
    final u = _users.firstWhere(
      (user) => user.username == username && user.passwordHash == hash,
      orElse: () => null as UserModel, // jika tidak ditemukan -> null
    );
    if (u == null) {
      return 'Login gagal: username atau password salah';
    } else {
      _currentUser = u;
      notifyListeners();
      return null;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
