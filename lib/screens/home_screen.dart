import 'package:flutter/material.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_switch_theme_mode.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wireless Debugging Devices Manager')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: double.maxFinite,
          width: MediaQuery.of(context).size.width * 0.85,
          color: Colors.red,
          alignment: Alignment.topCenter,
          child: const Column(
            children: [
              Wrap(
                children: [
                  CondorSwitchThemeMode(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
