// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:basic_http_manager/basic_http_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Basic Restful Api Test', () {
    final basicHttpManager = BasicHttpManager(
      managerConfig: HttpManagerConfig(baseUrl: 'https://api.askpic.com/',interceptors: []),
    );
    
    test('Get', () async {
      
      final resp = await basicHttpManager.get('/conversations');
      print('${'=' * 10}\n${resp.isSuccess}\n ${jsonEncode(resp.data)}\n ${'=' * 10}');
      expect(
        resp.isSuccess,
        true,
      );
    });
  });
}
