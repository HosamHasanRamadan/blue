import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'blue_method_channel.dart';

abstract class BluePlatform extends PlatformInterface {
  /// Constructs a BluePlatform.
  BluePlatform() : super(token: _token);

  static final Object _token = Object();

  static BluePlatform _instance = MethodChannelBlue();

  /// The default instance of [BluePlatform] to use.
  ///
  /// Defaults to [MethodChannelBlue].
  static BluePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BluePlatform] when
  /// they register themselves.
  static set instance(BluePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPairedDevices() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getConnectedDevices() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> isConnected(String address) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
