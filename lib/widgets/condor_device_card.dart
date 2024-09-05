import 'package:flutter/material.dart';

class CondorDeviceCard extends StatelessWidget {
  const CondorDeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 555,
      child: Card(
        color: Colors.grey.shade400,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //TODO: use input with disabled without it's theme because it's prettier and Text needs to be always black.
                    Row(
                      children: [
                        const SelectableText(
                            'Complete IP Address\n192.168.1.1:5555'),
                        const SizedBox(
                          width: 14,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const SelectableText(
                            'Custom name\nSamsung Galaxy S22+'),
                        const SizedBox(
                          width: 14,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                    const SelectableText('Serial number\nXJYPL678QWE'),
                    const SelectableText('Model\nSM_S906B'),
                    const SelectableText('Manufacturer\nSamsung'),
                    const SelectableText('Android version\n14'),
                  ],
                ),
              ),
              Expanded(
                child: Wrap(
                  direction: Axis.vertical,
                  runAlignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 28,
                  children: [
                    //TODO: change theme of onPressed: null to have it opaque and add spinner.
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Connect'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Disconnect'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Run tcpip'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mirror screen'),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red.shade600,
                        size: 44,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
