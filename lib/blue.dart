import 'dart:io';

import 'blue_platform_interface.dart';
import 'models.dart';
import 'package:universal_platform/universal_platform.dart';

class Blue {
  Future<List<BlueDevice>> getPairedDevices() async {
    if (Platform.isAndroid == false) return [];
    final devicesJson = await BluePlatform.instance.getPairedDevices();
    if (devicesJson == null) return <BlueDevice>[];
    return jsonListOfBluetoothDevicesInfo(devicesJson);
  }

  Future<List<BlueDevice>> getConnectedDevices() async {
    if (Platform.isAndroid == false) return [];
    final devicesJson = await BluePlatform.instance.getConnectedDevices();
    if (devicesJson == null) return <BlueDevice>[];
    return jsonListOfBluetoothDevicesInfo(devicesJson);
  }

  Future<bool?> isConnected(String address) async {
    if (Platform.isAndroid == false) return false;
    return BluePlatform.instance.isConnected(address);
  }
}
