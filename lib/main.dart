import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'variables.dart';
import 'wifi.dart';
import 'bluetooth.dart';

void main() => runApp(const CupertinoApp(
    theme: CupertinoThemeData(brightness: Brightness.light),
    debugShowCheckedModeBanner: false,
    home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _airplaneMode = false;
  bool _personalHotspotEnabled = false;
  String? _connectedWifi; // Variable to store the connected Wi-Fi network name
  String? _connectedBluetoothDevice; // Variable to store the connected Bluetooth device name

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  CupertinoListTile(
                    title: const Text('Airplane Mode'),
                    leading: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: CupertinoColors.systemOrange,
                      ),
                      child: const Icon(CupertinoIcons.airplane, color: CupertinoColors.white),
                    ),
                    trailing: CupertinoSwitch(
                      value: _airplaneMode,
                      onChanged: (value) {
                        setState(() {
                          _airplaneMode = value;
                        });
                      },
                    ),
                  ),
                  CupertinoListTile(
                    title: const Text('Wi-Fi'),
                    leading: const Icon(CupertinoIcons.wifi),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_connectedWifi ?? 'Off'), // Show the connected Wi-Fi network name or 'Off'
                        const Icon(CupertinoIcons.right_chevron),
                      ],
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => const WifiSettings()),
                      );
                      // Get the connected Wi-Fi network name when returning from WifiSettings
                      setState(() {
                        _connectedWifi = result;
                      });
                    },
                  ),
                  CupertinoListTile(
                    title: const Text('Bluetooth'),
                    leading: const Icon(CupertinoIcons.bluetooth),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_connectedBluetoothDevice ?? 'Off'),
                        const Icon(CupertinoIcons.right_chevron),
                      ],
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => const BluetoothSettings()),
                      );
                      setState(() {
                        _connectedBluetoothDevice = result; // Update the connected Bluetooth device name
                      });
                    },
                  ),
                  CupertinoListTile(
                    title: const Text('Cellular'),
                    leading: const Icon(CupertinoIcons.antenna_radiowaves_left_right),
                    trailing: const Icon(CupertinoIcons.right_chevron),
                    onTap: () {},
                  ),
                  CupertinoListTile(
                    title: const Text('Personal Hotspot'),
                    leading: const Icon(CupertinoIcons.personalhotspot),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_personalHotspotEnabled ? 'On' : 'Off'),
                        const Icon(CupertinoIcons.right_chevron),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        _personalHotspotEnabled = !_personalHotspotEnabled;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
