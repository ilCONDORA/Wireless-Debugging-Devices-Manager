import 'package:flutter/material.dart';

class CondorDeviceCard extends StatelessWidget {
  const CondorDeviceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 555,
      child: Card(
        color: Colors.grey.shade400,
        child: const Padding(
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 11,
          ),
          child: Row(
            children: [
              CondorDeviceInfos(),
              CondorColumnButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

class CondorDeviceInfos extends StatelessWidget {
  const CondorDeviceInfos({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 333,
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Complete IP Address',
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              const Expanded(
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Custom name',
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          const SizedBox(
            height: 14,
          ),
          const TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Serial number',
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          const TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Model',
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          const TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Manufacturer',
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          const TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Android version',
            ),
          ),
        ],
      ),
    );
  }
}

class CondorColumnButtons extends StatelessWidget {
  const CondorColumnButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Wrap(
        direction: Axis.vertical,
        runAlignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 36,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: Visibility(
                  visible: true,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              ),
              const SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Connect'),
              ),
            ],
          ),
          const Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Visibility(
                  visible: false,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              ),
              SizedBox(
                width: 14,
              ),
              ElevatedButton(
                onPressed: null,
                child: Text('Disconnect'),
              ),
            ],
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
    );
  }
}
