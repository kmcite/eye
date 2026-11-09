import 'dart:io';

Future<bool> checkPocketBaseHealth(String baseUrl) async {
  final normalized = normalizePocketBaseUrl(baseUrl);
  try {
    final client = HttpClient();
    final request = await client
        .getUrl(Uri.parse('$normalized/api/health'))
        .timeout(const Duration(seconds: 6));
    final response = await request.close().timeout(const Duration(seconds: 6));
    final ok = response.statusCode == 200;
    client.close(force: true);
    return ok;
  } catch (_) {
    return false;
  }
}

String normalizePocketBaseUrl(String url) {
  var s = url.trim();
  while (s.endsWith('/')) {
    s = s.substring(0, s.length - 1);
  }
  if (!s.startsWith('http://') && !s.startsWith('https://')) {
    s = 'http://$s';
  }
  return s;
}
