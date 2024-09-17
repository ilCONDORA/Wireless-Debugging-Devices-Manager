import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CondorLocalizationService {
  static final CondorLocalizationService _instance = CondorLocalizationService._internal();
  factory CondorLocalizationService() => _instance;
  CondorLocalizationService._internal();

  late BuildContext _context;

  void init(BuildContext context) {
    _context = context;
  }

  AppLocalizations get l10n => AppLocalizations.of(_context)!;
}

final condorLocalization = CondorLocalizationService();