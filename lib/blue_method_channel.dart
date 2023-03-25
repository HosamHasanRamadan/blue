import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'blue_platform_interface.dart';

/// An implementation of [BluePlatform] that uses method channels.
class MethodChannelBlue extends BluePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('blue');

  @override
  Future<String?> getPairedDevices() async {
    final result = await methodChannel.invokeMethod<String>('getPairedDevices');
    return result;
  }

  @override
  Future<String?> getConnectedDevices() async {
    final result =
        await methodChannel.invokeMethod<String>('getConnectedDevices');
    return result;
  }

  @override
  Future<bool?> isConnected(String address) async {
    final result = await methodChannel
        .invokeMethod<bool>('isConnected', {'address': address});
    return result;
  }
}
