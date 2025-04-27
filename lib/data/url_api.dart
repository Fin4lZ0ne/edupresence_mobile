class urlApi {
  static const String baseUrl = 'https://apsensi.my.id/api';

  static String login() {
    return baseUrl + '/login';
  }

  static String getUser() {
    return baseUrl + '/user';
  }

  static String forgotPassword() {
    return baseUrl + '/forgot-password';
  }

  static String codeOTP() {
    return baseUrl + '/verify-code';
  }

  static String resetPassword() {
    return baseUrl + '/reset-password';
  }

  static String getHolidays() {
    return baseUrl + '/holidays';
  }

  static String sendLocation() {
    return baseUrl + '/attendances/valid-area';
  }

  static String sendAttempt() {
    return baseUrl + '/attendances/attempt';
  }

  static String getStatus() {
    return baseUrl + '/attendances/status';
  }

  static String getLogPresensi() {
    return baseUrl + '/attendances';
  }
}
