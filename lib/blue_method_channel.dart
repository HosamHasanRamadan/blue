import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'blue_platform_interface.dart';

/// An implementation of [BluePlatform] that uses method channels.
class MethodChannelBlue extends BluePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('blue');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
