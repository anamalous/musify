import 'dart:convert';
dynamic jconv(String s) {
  return jsonDecode(
      s.replaceAll("{", "{\" ").replaceAll(":", "\":").replaceAll("[", "[\"")
          .replaceAll("]", "\"]").replaceAll(",", "\",\"").replaceAll(
          "\"]\",", "\"],")
          .replaceAll("+", "\"+"));
}

dynamic jconv2(String s) {
  return jsonDecode(
      s.replaceAll("{", "{\" ").replaceAll(": [", "\": [").replaceAll("[", "[\"")
          .replaceAll("]", "\"]").replaceAll(",", "\",\"").replaceAll(
          "\"]\",", "\"],")
          .replaceAll("+", "\"+"));
}