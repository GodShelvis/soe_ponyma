import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soe_ponyma/soe_ponyma.dart';

void main() {
  const MethodChannel channel = MethodChannel('soe_ponyma');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    // expect(await SoePonyma.platformVersion, '42');
  });
}
