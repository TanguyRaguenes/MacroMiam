import 'package:flutter/material.dart';
import 'package:macromiam/data/services/api_service.dart';
import 'package:macromiam/data/services/file_picker_service.dart';
import 'package:macromiam/data/services/image_service.dart';
import 'package:macromiam/providers/theme_provider.dart';
import 'package:macromiam/ui/views/screens/aliment_screen.dart';
import 'package:macromiam/ui/views/screens/language_screen.dart';
import 'package:macromiam/ui/views/widgets/drawer_widget.dart';
import 'ui/view_models/list_vm.dart';
import 'data/services/sqlite_db_service.dart';
import 'ui/view_models/aliment_vm.dart';
import 'data/repositories/aliment_repository.dart';
import 'ui/views/widgets/add_widget.dart';
import 'ui/views/widgets/list_widget.dart';
import 'ui/views/widgets/stats_widget.dart';
import 'ui/views/screens/add_aliment_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'providers/locale_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => SqliteDbService()),
        Provider(create: (_) => FilePickerService()),

        Provider(
          create:
              (BuildContext context) => ImageService(
                sqliteDbService: context.read<SqliteDbService>(),
              ),
        ),

        Provider(
          create:
              (BuildContext context) => AlimentRepository(
                sqliteDbService: context.read<SqliteDbService>(),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (BuildContext context) => AlimentVm(
                alimentRepository: context.read<AlimentRepository>(),
                apiService: context.read<ApiService>(),
                imageService: context.read<ImageService>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (BuildContext context) => ListVm(
                alimentRepository: context.read<AlimentRepository>(),
                imageService: context.read<ImageService>(),
              ),
        ),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      locale: context.watch<LocaleProvider>().locale,
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(title: 'MacroMiam 🍽️'),
        '/addAliment': (context) => AddAlimentScreen(),
        '/language': (context) => LanguageScreen(),
        '/aliment': (context) => AlimentScreen(),
      },
      title: 'MacroMiam 🍽️',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink.shade300,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange.shade300,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('en'), Locale('fr')],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var index = 0;

  final List<Widget> _widgets = [AddWidget(), ListWidget(), StatsWidget()];

  @override
  Widget build(BuildContext context) {
    LocaleProvider localeProvider = context.watch<LocaleProvider>();
    ThemeProvider themeProvider = context.watch<ThemeProvider>();
    return Scaffold(
      drawer: Drawer(child: DrawerWidget()),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: ('Open menu'),
            );
          },
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onInverseSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () {
                themeProvider.toggleTheme();
              },
              icon: Text(
                themeProvider.getThemeEmoji(),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          SizedBox(width: 1),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.onInverseSurface.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/language');
              },
              icon: Text(
                localeProvider.flagEmojis[localeProvider.locale.languageCode]!,
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),

      body: SizedBox.expand(child: _widgets[index]),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        onTap: (newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list_rounded), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.percent_outlined),
            label: '',
          ),
        ],
      ),
    );
  }
}
