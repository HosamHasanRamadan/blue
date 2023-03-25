import 'dart:convert';

class BlueDevice {
  final String address;
  final String name;
  final bool connected;
  final int level;
  BlueDevice({
    required this.address,
    required this.name,
    required this.connected,
    required this.level,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'address': address});
    result.addAll({'name': name});
    result.addAll({'connected': connected});
    result.addAll({'battery_level': level});

    return result;
  }

  factory BlueDevice.fromMap(Map<String, dynamic> map) {
    return BlueDevice(
      address: map['address'] ?? '',
      name: map['name'] ?? '',
      connected: map['connected'] ?? '',
      level: map['battery_level']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BlueDevice.fromJson(String source) =>
      BlueDevice.fromMap(json.decode(source));
}

List<BlueDevice> jsonListOfBluetoothDevicesInfo(String json) {
  final devicesList = jsonDecode(json) as List;
  return devicesList
      .cast<Map<String, dynamic>>()
      .map((e) => BlueDevice.fromMap(e))
      .toList();
}
