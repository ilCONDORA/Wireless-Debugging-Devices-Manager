import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';

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
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) =>
          previous.appSettingsModel.locale != current.appSettingsModel.locale,
      builder: (context, state) {
        return SizedBox(
          width: 333,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText:
                            condorLocalization.l10n.completeIpAddressLabel,
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
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: condorLocalization.l10n.customNameLabel,
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
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: condorLocalization.l10n.serialNumberLabel,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: condorLocalization.l10n.modelLabel,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: condorLocalization.l10n.manufacturerLabel,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              TextField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: condorLocalization.l10n.androidVersionLabel,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CondorColumnButtons extends StatelessWidget {
  const CondorColumnButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) =>
          previous.appSettingsModel.locale != current.appSettingsModel.locale,
      builder: (context, state) {
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
                    child: Text(condorLocalization.l10n.connectDeviceButton),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: Visibility(
                      visible: false,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  ElevatedButton(
                    onPressed: null,
                    child: Text(condorLocalization.l10n.disconnectDeviceButton),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(condorLocalization.l10n.runTcpipButton),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(condorLocalization.l10n.mirrorScreenButton),
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
      },
    );
  }
}
