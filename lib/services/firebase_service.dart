import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/weather_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Получить текущего пользователя
  User? get currentUser => _auth.currentUser;

  // Stream для отслеживания состояния аутентификации
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Регистрация
  Future<UserCredential> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Ошибка регистрации: $e');
    }
  }

  // Вход
  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Ошибка входа: $e');
    }
  }

  // Выход
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Ошибка выхода: $e');
    }
  }

  // Сохранить запрос погоды в Firestore
  Future<void> saveWeatherSearch(WeatherModel weather) async {
    try {
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('weather_history')
          .add({
        'city': weather.city,
        'country': weather.country,
        'temperature': weather.temperature,
        'feelsLike': weather.feelsLike,
        'humidity': weather.humidity,
        'windSpeed': weather.windSpeed,
        'description': weather.description,
        'icon': weather.icon,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Ошибка сохранения: $e');
    }
  }

  // Получить историю поисков
  Future<List<WeatherModel>> getWeatherHistory() async {
    try {
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('weather_history')
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => WeatherModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Ошибка загрузки истории: $e');
    }
  }

  // Stream истории поисков (для реал-тайм обновления)
  Stream<List<WeatherModel>> getWeatherHistoryStream() {
    if (currentUser == null) {
      return Stream.error('Пользователь не авторизован');
    }

    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('weather_history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WeatherModel.fromFirestore(doc.data()))
            .toList());
  }

  // Удалить из истории
  Future<void> deleteWeatherFromHistory(String docId) async {
    try {
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('weather_history')
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception('Ошибка удаления: $e');
    }
  }

  // Сохранить избранный город
  Future<void> saveFavoriteCity(String city, String country) async {
    try {
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('favorites')
          .doc(city)
          .set({
        'city': city,
        'country': country,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Ошибка сохранения избранного: $e');
    }
  }

  // Получить избранные города
  Stream<List<Map<String, dynamic>>> getFavoriteCitiesStream() {
    if (currentUser == null) {
      return Stream.error('Пользователь не авторизован');
    }

    return _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }

  // Удалить из избранного
  Future<void> removeFavoriteCity(String city) async {
    try {
      if (currentUser == null) {
        throw Exception('Пользователь не авторизован');
      }

      await _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('favorites')
          .doc(city)
          .delete();
    } catch (e) {
      throw Exception('Ошибка удаления из избранного: $e');
    }
  }
}
