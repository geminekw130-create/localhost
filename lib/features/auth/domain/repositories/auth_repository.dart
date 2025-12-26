import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motoboy/data/api_client.dart';
import 'package:motoboy/features/auth/domain/models/signup_body.dart';
import 'package:motoboy/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:motoboy/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepository({
    required this.apiClient,
    required this.sharedPreferences,
  });

  @override
  Future<Response?> login({
    required String phone,
    required String password,
  }) async {
    return await apiClient.postData(
      AppConstants.loginUri,
      {"phone_or_email": phone, "password": password},
    );
  }

  @override
  Future<Response?> logOut() async {
    return await apiClient.postData(AppConstants.logout, {});
  }

  @override
  Future<Response> registration({
    required SignUpBody signUpBody,
    XFile? profileImage,
    List<MultipartBody>? identityImage,
    List<MultipartDocument>? documents,
  }) async {
    /// ✅ Conversão segura para release
    final Map<String, String> body = signUpBody
        .toJson()
        .map((key, value) => MapEntry(key, value.toString()));

    return await apiClient.postMultipartData(
      AppConstants.registration,
      body,
      identityImage ?? [],
      profileImage != null
          ? MultipartBody('profile_image', profileImage)
          : null,
      documents ?? [],
    );
  }

  @override
  Future<Response?> sendOtp({required String phone}) async {
    return await apiClient.postData(
      AppConstants.sendOtp,
      {"phone_or_email": phone},
    );
  }

  @override
  Future<Response?> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    return await apiClient.postData(
      AppConstants.otpVerification,
      {"phone_or_email": phone, "otp": otp},
    );
  }

  @override
  Future<Response?> verifyFirebaseOtp({
    required String phone,
    required String otp,
    required String session,
  }) async {
    return await apiClient.postData(
      AppConstants.otpFirebaseVerification,
      {
        "phone_or_email": phone,
        "code": otp,
        "session_info": session,
      },
    );
  }

  @override
  Future<Response?> resetPassword(
    String phoneOrEmail,
    String password,
  ) async {
    return await apiClient.postData(
      AppConstants.resetPassword,
      {
        "phone_or_email": phoneOrEmail,
        "password": password,
      },
    );
  }

  @override
  Future<Response?> changePassword(
    String oldPassword,
    String password,
  ) async {
    return await apiClient.postData(
      AppConstants.changePassword,
      {
        "password": oldPassword,
        "new_password": password,
      },
    );
  }

  String? deviceToken;

  @override
  Future<Response?> updateToken() async {
    if (GetPlatform.isIOS) {
      FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    } else {
      deviceToken = await _saveDeviceToken();
      await saveDeviceToken();
    }

    if (!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(
        AppConstants.topic,
      );
    }

    return await apiClient.postData(
      AppConstants.fcmTokenUpdate,
      {
        "_method": "put",
        "fcm_token": deviceToken,
      },
    );
  }

  Future<String?> _saveDeviceToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Response?> forgetPassword(String? phone) async {
    return await apiClient.postData(
      AppConstants.configUri,
      {"phone_or_email": phone},
    );
  }

  @override
  Future<Response?> verifyPhone(
    String phone,
    String otp,
  ) async {
    return await apiClient.postData(
      AppConstants.configUri,
      {"phone": phone, "otp": otp},
    );
  }

  @override
  Future<bool?> saveUserToken(
    String token,
    String zoneId,
  ) async {
    apiClient.token = token;
    apiClient.updateHeader(
      token,
      sharedPreferences.getString(AppConstants.languageCode),
      "latitude",
      "longitude",
      zoneId,
    );
    return await sharedPreferences.setString(
      AppConstants.token,
      token,
    );
  }

  @override
  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  @override
  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    return true;
  }

  @override
  Future<void> saveUserCredential(
    String code,
    String number,
    String password,
  ) async {
    await sharedPreferences.setString(
      AppConstants.userPassword,
      password,
    );
    await sharedPreferences.setString(
      AppConstants.userNumber,
      number,
    );
    await sharedPreferences.setString(
      AppConstants.loginCountryCode,
      code,
    );
  }

  @override
  Future<void> saveDeviceToken() async {
    await sharedPreferences.setString(
      AppConstants.deviceToken,
      deviceToken ?? '',
    );
  }

  @override
  String getDeviceToken() {
    return sharedPreferences.getString(AppConstants.deviceToken) ?? "";
  }

  @override
  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  @override
  String getUserCountryCode() {
    return "";
  }

  @override
  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  @override
  bool isNotificationActive() => true;

  @override
  void toggleNotificationSound(bool isNotification) {}

  @override
  Future<bool> clearUserCredential() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }

  @override
  bool clearSharedAddress() => true;

  @override
  String getZonId() {
    return sharedPreferences.getString(AppConstants.zoneId) ?? "";
  }

  @override
  Future<void> updateZone(String zoneId) async {
    await sharedPreferences.setString(AppConstants.zoneId, zoneId);
    apiClient.updateHeader(
      sharedPreferences.getString(AppConstants.token) ?? '',
      sharedPreferences.getString(AppConstants.languageCode),
      'latitude',
      'longitude',
      zoneId,
    );
  }

  /* =========================================================
     IMPLEMENTAÇÕES OBRIGATÓRIAS (RepositoryInterface)
     Stubs seguros – NÃO QUEBRAM O APP
     ========================================================= */

  @override
  Future<dynamic> add(value) async {
    return null;
  }

  @override
  Future<dynamic> delete(int id) async {
    return null;
  }

  @override
  Future<dynamic> get(String id) async {
    return null;
  }

  @override
  Future<dynamic> getList({int? offset = 1}) async {
    return [];
  }

  @override
  Future<dynamic> update(Map<String, dynamic> body, int id) async {
    return null;
  }

  /* ========================================================= */

  @override
  Future<Response?> permanentDelete() async {
    return await apiClient.postData(
      AppConstants.permanentDelete,
      {},
    );
  }

  @override
  Future<void> saveRideCreatedTime(DateTime dateTime) async {
    await sharedPreferences.setString(
      'DateTime',
      dateTime.toString(),
    );
  }

  @override
  Future<String> remainingTime() async {
    return sharedPreferences.getString('DateTime') ?? '';
  }

  @override
  String getLoginCountryCode() {
    return sharedPreferences.getString(
          AppConstants.loginCountryCode,
        ) ??
        "";
  }

  @override
  Future<Response?> isUserRegistered({
    required String phone,
  }) async {
    return await apiClient.postData(
      AppConstants.checkRegisteredUserUri,
      {"phone_or_email": phone},
    );
  }
}
