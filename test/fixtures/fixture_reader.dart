import 'dart:convert';
import 'dart:io';

/// Reads and decodes the JSON file `test/fixtures/[name]`.
dynamic fixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync());
