import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

Uint8List decodeBase64Image(String base64String) {
  return base64Decode(base64String);
}
