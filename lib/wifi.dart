import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'variables.dart';

class WifiSettings extends StatefulWidget {
  const WifiSettings({Key? key}) : super(key: key);

  @override
  WifiSettingsState createState() => WifiSettingsState();
}

class WifiSettingsState extends State<WifiSettings> {
  List<String> _wifiNetworks = [];

  @override
  void initState() {
    super.initState();
    if (wifiEnabled && _wifiNetworks.isEmpty) {
      _fetchWifiNetworks();
    }
  }

  Future<void> _fetchWifiNetworks() async {
    setState(() {
      _wifiNetworks = availableWifiNetworks; // Directly set the networks
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, connectedWifiNetwork); // Return the connected network name
        return true;
      },
      child: CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(middle: Text('Wi-Fi')),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text('Wi-Fi'),
                    CupertinoSwitch(
                      value: wifiEnabled,
                      onChanged: (value) async {
                        setState(() {
                          wifiEnabled = value;
                        });
                        if (value && _wifiNetworks.isEmpty) {
                          await _fetchWifiNetworks();
                        } else if (!value) {
                          connectedWifiNetwork = null; // Clear connected network if Wi-Fi is turned off
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (wifiEnabled)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('NETWORKS'),
                      Column(
                        children: _wifiNetworks.map((network) {
                          return CupertinoListTile(
                            title: Text(network),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (connectedWifiNetwork == network)
                                  const Text(
                                    'Connected',
                                    style: TextStyle(color: CupertinoColors.inactiveGray),
                                  ),
                                const Icon(CupertinoIcons.info_circle),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                connectedWifiNetwork = network; // Set the connected network globally
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
