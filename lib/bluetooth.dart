import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'variables.dart';

class BluetoothSettings extends StatefulWidget {
  const BluetoothSettings({Key? key}) : super(key: key);

  @override
  BluetoothSettingsState createState() => BluetoothSettingsState();
}

class BluetoothSettingsState extends State<BluetoothSettings> {
  List<String> _bluetoothDevices = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (bluetoothEnabled && _bluetoothDevices.isEmpty) {
      _fetchBluetoothDevices();
    }
  }

  Future<void> _fetchBluetoothDevices() async {
    setState(() {
      _bluetoothDevices = availableBluetoothDevices; // Directly set the devices
    });
  }

  Future<void> _toggleBluetooth(bool value) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500)); // Short delay to simulate loading

    setState(() {
      bluetoothEnabled = value;
      _isLoading = false;
      if (value) {
        _fetchBluetoothDevices();
      } else {
        connectedBluetoothDevice = null; // Clear connected device if Bluetooth is turned off
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, connectedBluetoothDevice); // Return the connected device name
        return true;
      },
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Bluetooth')),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Bluetooth'),
                    if (_isLoading)
                      const CupertinoActivityIndicator()
                    else
                      CupertinoSwitch(
                        value: bluetoothEnabled,
                        onChanged: _toggleBluetooth,
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                if (bluetoothEnabled)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      'This iPhone is discoverable as "Moon" while Bluetooth Settings is open.',
                      style: TextStyle(color: CupertinoColors.secondaryLabel),
                    ),
                  ),
                if (bluetoothEnabled)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('MY DEVICES'),
                      Column(
                        children: _bluetoothDevices.map((device) {
                          return CupertinoListTile(
                            title: Text(device),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (connectedBluetoothDevice == device)
                                  const Text(
                                    'Connected',
                                    style: TextStyle(color: CupertinoColors.inactiveGray),
                                  ),
                                const Icon(CupertinoIcons.info_circle),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                connectedBluetoothDevice = device; // Set the connected device globally
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
