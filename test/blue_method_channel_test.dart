import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blue/blue_method_channel.dart';

void main() {
  MethodChannelBlue platform = MethodChannelBlue();
  const MethodChannel channel = MethodChannel('blue');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
