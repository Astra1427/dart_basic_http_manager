// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:basic_http_manager/basic_http_manager.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Basic Restful Api Test', () {
    final basicHttpManager = BasicHttpManager(
      managerConfig: HttpManagerConfig(
        baseUrl: 'https://www.baidu.com/',
        interceptors: [],
      ),
    );

    test('Get', () async {
      final resp = await basicHttpManager.get('');
      debugPrint(
        '${'=' * 10}\n$resp\n ${jsonEncode(resp?.data)}\n ${'=' * 10}',
      );
      expect(
        resp?.data,
        true,
      );
    });
  });
}
