import 'package:flutter/material.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_buttons_row.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_device_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scroolController = ScrollController();

    return Scaffold(
      appBar: AppBar(title: const Text('Wireless Debugging Devices Manager')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 8, top: 16),
          height: double.infinity,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            children: [
              const CondorButtonsRow(),
              const SizedBox(height: 20),
              Expanded(
                child: Scrollbar(
                  controller: scroolController,
                  thumbVisibility: true,
                  child: ListView(
                    controller: scroolController,
                    children: const [
                      Padding(
                        /// this padding is used to make the scrollbar a bit more visible by giving it some space.
                        padding: EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 9,
                        ),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 77,
                          runSpacing: 77,
                          children: [
                            CondorDeviceCard(),
                            CondorDeviceCard(),
                            CondorDeviceCard(),
                            CondorDeviceCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
