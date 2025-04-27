import 'package:flutter/material.dart';
import 'package:macromiam/providers/locale_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final Map<Locale, String> languageLabels = {
    Locale('en'): 'English',
    Locale('fr'): 'Français',
    Locale('es'): 'Español',
    Locale('de'): 'Deutsch',
    Locale('it'): 'Italiano',
  };

  @override
  Widget build(BuildContext context) {
    LocaleProvider localeProvider = context.watch<LocaleProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageLabels[localeProvider.locale] ?? 'No language selected',
        ),
      ),
      body: ListView(
        children: [
          ElevatedButton(
            onPressed: () {
              localeProvider.setLocale(Locale('en'));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("The application now uses English."),
                  backgroundColor: Colors.green,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            child: Text('🇬🇧 English'),
          ),
          ElevatedButton(
            onPressed: () {
              localeProvider.setLocale(Locale('fr'));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("L'application utilise maintenant le français"),
                  backgroundColor: Colors.green,
                  duration: Duration(milliseconds: 500),
                ),
              );
            },
            child: Text('🇫🇷 Français'),
          ),
        ],
      ),
    );
  }
}
