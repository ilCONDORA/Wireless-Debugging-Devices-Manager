import 'package:flutter/material.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_buttons_row.dart';

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
                    children: [
                      Padding(
                        /// this padding is used to make the scrollbar a bit more visible by giving it some space
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 9),
                        child: Wrap(
                          alignment: WrapAlignment.spaceEvenly,
                          spacing: 77,
                          runSpacing: 77,
                          children: [
                            Container(
                              height: 444,
                              width: 444,
                              color: Colors.grey.shade400,
                              child: const Text('Device 1'),
                            ),
                            Container(
                              height: 444,
                              width: 444,
                              color: Colors.grey.shade400,
                              child: const Text('Device 2'),
                            ),
                            Container(
                              height: 444,
                              width: 444,
                              color: Colors.grey.shade400,
                              child: const Text('Device 3'),
                            ),
                            Container(
                              height: 444,
                              width: 444,
                              color: Colors.grey.shade400,
                              child: const Text('Device 4'),
                            ),
                            Container(
                              height: 444,
                              width: 444,
                              color: Colors.grey.shade400,
                              child: const Text('Device 5'),
                            ),
                            Container(
                              height: 444,
                              width: 444,
                              color: Colors.grey.shade400,
                              child: const Text('Device 6'),
                            ),
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
