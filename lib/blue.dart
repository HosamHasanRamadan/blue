
import 'blue_platform_interface.dart';

class Blue {
  Future<String?> getPlatformVersion() {
    return BluePlatform.instance.getPlatformVersion();
  }
}
