import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wireless_debugging_devices_manager/blocs/app_settings/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/services/condor_snackbar_service.dart';

/// The screen that displays the information about the app.
class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      buildWhen: (previous, current) =>
          previous.appSettingsModel.themeMode !=
          current.appSettingsModel.themeMode,
      builder: (context, state) {
        bool isDark = state.appSettingsModel.themeMode == ThemeMode.dark;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Info'),
            iconTheme:
                IconThemeData(color: isDark ? Colors.white : Colors.black),
          ),
          body: CondorMarkdown(
            fileName: 'Infos on how to use WDDM.md',
            assetsPath: 'assets/info screen files/',
            isDark: isDark,
          ),
        );
      },
    );
  }
}

/// A widget that displays a markdown file.
///
/// [fileName] is the name of the markdown file, required.
/// [assetsPath] is the path to the directory where the markdown file is located, required.
/// [isDark] determines if the widget should be displayed in dark mode, defaults to false.
class CondorMarkdown extends StatefulWidget {
  const CondorMarkdown({
    super.key,
    required this.fileName,
    required this.assetsPath,
    this.isDark = false,
  });

  final String fileName;
  final String assetsPath;

  final bool isDark;

  @override
  State<CondorMarkdown> createState() => _CondorMarkdownState();
}

class _CondorMarkdownState extends State<CondorMarkdown> {
  String? markdownContent;

  @override
  void initState() {
    super.initState();
    _loadMarkdownContentFromAssets();
  }

  Future<void> _loadMarkdownContentFromAssets() async {
    try {
      final filePath = '${widget.assetsPath}${widget.fileName}';
      final content = await rootBundle.loadString(filePath);
      setState(() {
        markdownContent = content;
      });
    } catch (e) {
      setState(() {
        markdownContent = "Error loading markdown file: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (markdownContent == null) {
      return const Center(child: CircularProgressIndicator());
    }
    Color? textColor = widget.isDark ? Colors.white : Colors.black;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: MarkdownBody(
        data: markdownContent!,
        selectable: true,
        onTapLink: (text, href, title) async {
          final Uri url = Uri.parse(href!);
          if (!await launchUrl(url)) {
            condorSnackBar.show(
              message: 'Could not launch $url',
              isSuccess: false,
            );
          }
        },
        imageBuilder: (uri, title, alt) {
          return Image.asset('${widget.assetsPath}${uri.toString()}');
        },
        styleSheet: MarkdownStyleSheet(
          h1: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          h2: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          h3: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
          p: TextStyle(
            color: textColor,
          ),
          code: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.red.withOpacity(0.2),
          ),
          listBullet: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
  }
}
