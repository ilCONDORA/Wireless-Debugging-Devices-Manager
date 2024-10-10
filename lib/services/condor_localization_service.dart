import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Service for localization.
///
/// It provides access to the localized strings in the application.
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

/// Global instance for easy access to the localized strings in the application.
final condorLocalization = CondorLocalizationService();