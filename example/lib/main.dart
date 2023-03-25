import 'dart:async';
import 'dart:convert';

import 'package:blue/blue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final connectedDevicesProvider = FutureProvider((ref) async {
  final invalidationTimer = Timer(const Duration(seconds: 1), () {
    ref.invalidateSelf();
  });
  ref.onDispose(invalidationTimer.cancel);
  return await Blue().getConnectedDevices();
});

final pairedDevicesProvider = FutureProvider((ref) async {
  final invalidationTimer = Timer(const Duration(seconds: 1), () {
    ref.invalidateSelf();
  });
  ref.onDispose(invalidationTimer.cancel);
  return await Blue().getPairedDevices();
});

final flutterBlueConnectedDeviceProvider = FutureProvider((ref) async {
  final invalidationTimer = Timer(const Duration(seconds: 1), () {
    ref.invalidateSelf();
  });
  ref.onDispose(invalidationTimer.cancel);
  return await FlutterBluePlus.instance.connectedDevices;
});

final flutterBluePairedDeviceProvider = FutureProvider((ref) async {
  final invalidationTimer = Timer(const Duration(seconds: 1), () {
    ref.invalidateSelf();
  });
  ref.onDispose(invalidationTimer.cancel);
  return await FlutterBluePlus.instance.bondedDevices;
});


void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final connectedDevices =
                        ref.watch(pairedDevicesProvider).valueOrNull ?? [];
                    if (connectedDevices.isEmpty) return Text('Not Ready');
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Text('Paired'),
                        ...connectedDevices.map(
                          (e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text(e.address),
                            leading: Text(e.connected.toString()),
                            trailing: Text(e.level.toString()),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final connectedDevices =
                        ref.watch(connectedDevicesProvider).valueOrNull ?? [];
                    if (connectedDevices.isEmpty) return Text('Not Ready');
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Text('Connected'),
                        ...connectedDevices.map(
                          (e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text(e.address),
                            leading: Text(e.connected.toString()),
                            trailing: Text(e.level.toString()),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final connectedDevices = ref
                            .watch(flutterBluePairedDeviceProvider)
                            .valueOrNull ??
                        [];
                    if (connectedDevices.isEmpty) return Text('Not Ready');
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Text('Flutter Blue Paired'),
                        ...connectedDevices.map(
                          (e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text(e.id.id.toString()),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final connectedDevices = ref
                            .watch(flutterBlueConnectedDeviceProvider)
                            .valueOrNull ??
                        [];
                    if (connectedDevices.isEmpty) return Text('Not Ready');
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Text('Flutter blue Connected'),
                        ...connectedDevices.map(
                          (e) => ListTile(
                            title: Text(e.name),
                            subtitle: Text(e.id.id),
                          ),
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            [
              Permission.bluetooth,
              Permission.bluetoothAdvertise,
              Permission.bluetoothConnect,
              Permission.bluetoothScan,
            ].request();
          },
          child: Text('Ask'),
        ),
      ),
    );
  }

 
}
