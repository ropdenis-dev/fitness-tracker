import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _token;
  UserProfile? _profile;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get token => _token;
  UserProfile? get profile => _profile;

  AuthProvider() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    final profileJson = prefs.getString('user_profile');
    
    if (_token != null && _token!.isNotEmpty && profileJson != null) {
      try {
        final Map<String, dynamic> profileData = jsonDecode(profileJson);
        _profile = UserProfile.fromJson(profileData);
        _isAuthenticated = true;
      } catch (error) {
        print('Error loading profile: $error');
        _profile = null;
        _isAuthenticated = false;
      }
    } else {
      _isAuthenticated = false;
      _profile = null;
    }
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.register(
        email: email,
        password: password,
        fullName: fullName,
      );
      _token = result['token']?.toString();
      _profile = UserProfile.fromJson(result['profile'] ?? {});
      _isAuthenticated = true;
      
      final prefs = await SharedPreferences.getInstance();
      if (_token != null) {
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_profile', jsonEncode(result['profile']));
      }
    } catch (error) {
      print('Register error: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await AuthService.login(
        email: email,
        password: password,
      );
      _token = result['token']?.toString();
      _profile = UserProfile.fromJson(result['profile'] ?? {});
      _isAuthenticated = true;
      
      final prefs = await SharedPreferences.getInstance();
      if (_token != null) {
        await prefs.setString('auth_token', _token!);
        await prefs.setString('user_profile', jsonEncode(result['profile']));
      }
    } catch (error) {
      print('Login error: $error');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_profile');
    _token = null;
    _profile = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    if (_token == null) {
      return;
    }
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await AuthService.updateProfile(_token!, profile);
      final prefs = await SharedPreferences.getInstance();
      if (_profile != null) {
        await prefs.setString('user_profile', jsonEncode(_profile!.toJson()));
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}