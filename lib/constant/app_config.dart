class AppConfig {
  static String ip = '192.168.1.247';

  static String get baseUrl => 'http://$ip:8000';

  static void changeIP(String newIP) {
    if (newIP.isNotEmpty) {
      ip = newIP;
    }
  }
}
