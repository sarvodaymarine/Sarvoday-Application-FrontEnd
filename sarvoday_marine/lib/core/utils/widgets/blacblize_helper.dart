import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';
import 'package:intl/intl.dart';

// Generate HMAC-SHA256 hash
Uint8List hmacSha256(Uint8List key, Uint8List message) {
  // Convert the HMAC Digest to Uint8List
  return Uint8List.fromList(Hmac(sha256, key).convert(message).bytes);
}

// Generate the signing key
Uint8List getSignatureKey(
    String key, String dateStamp, String regionName, String serviceName) {
  var kDate = hmacSha256(Uint8List.fromList(utf8.encode('AWS4$key')),
      Uint8List.fromList(utf8.encode(dateStamp)));
  var kRegion = hmacSha256(kDate, Uint8List.fromList(utf8.encode(regionName)));
  var kService =
      hmacSha256(kRegion, Uint8List.fromList(utf8.encode(serviceName)));
  var kSigning =
      hmacSha256(kService, Uint8List.fromList(utf8.encode('aws4_request')));
  return kSigning;
}

// Generate the signature
String getSignature(String stringToSign, String secretKey, String dateStamp,
    String region, String service) {
  var signatureKey = getSignatureKey(secretKey, dateStamp, region, service);
  return HEX.encode(
      hmacSha256(signatureKey, Uint8List.fromList(utf8.encode(stringToSign))));
}

// Generate the canonical request
String getCanonicalRequest(
    String method, String uri, Map<String, String> headers, Uint8List payload) {
  var canonicalHeaders = headers.entries
      .map((e) => '${e.key.toLowerCase()}:${e.value.trim()}')
      .toList()
    ..sort((a, b) => a.compareTo(b));
  var signedHeaders = headers.keys.map((key) => key.toLowerCase()).toList()
    ..sort();

  // Join sorted headers and signed headers
  var canonicalHeadersString = canonicalHeaders.join('\n');
  var signedHeadersString = signedHeaders.join(';');

  // Hash the payload
  var payloadHash = sha256.convert(payload).toString();

  // Return the full canonical request string
  return '$method\n$uri\n\n$canonicalHeadersString\n\n$signedHeadersString\n$payloadHash';
}

// Generate the string to sign
String getStringToSign(String canonicalRequest, String dateStamp,
    String regionName, String serviceName) {
  var hashedCanonicalRequest =
      sha256.convert(utf8.encode(canonicalRequest)).toString();
  var scope = '$dateStamp/$regionName/$serviceName/aws4_request';
  String timestamp =
      DateFormat('yyyyMMdd\'T\'HHmmss\'Z\'').format(DateTime.now().toUtc());
  var stringToSign =
      'AWS4-HMAC-SHA256\n$timestamp\n$scope\n$hashedCanonicalRequest';
  return stringToSign;
}
