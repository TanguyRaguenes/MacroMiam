import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/services/aliment_service.dart';
import 'package:macromiam/data/services/api_service.dart';
import 'package:macromiam/data/services/consumption_service.dart';
import 'package:macromiam/data/services/image_service.dart';
import 'package:macromiam/providers/theme_provider.dart';
import 'package:macromiam/ui/view_models/consumption_vm.dart';
import 'package:macromiam/ui/views/screens/add_consumption_screen.dart';
import 'package:macromiam/ui/views/screens/aliment_screen.dart';
import 'package:macromiam/ui/views/screens/language_screen.dart';
import 'package:macromiam/ui/views/widgets/Banner_pub_widget.dart';
import 'package:macromiam/ui/views/widgets/consumption_widget.dart';
import 'package:macromiam/ui/views/widgets/drawer_widget.dart';
import 'package:provider/provider.dart';

import 'data/repositories/aliment_repository.dart';
import 'data/repositories/consumption_repository.dart';
import 'data/services/sqlite_db_service.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';
import 'ui/view_models/aliment_vm.dart';
import 'ui/view_models/list_vm.dart';
import 'ui/views/screens/add_aliment_screen.dart';
import 'ui/views/widgets/add_widget.dart';
import 'ui/views/widgets/list_widget.dart';
import 'ui/views/widgets/stats_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final config = RequestConfiguration(
    testDeviceIds: ['1259D4F82A884EF735E366CAE834ABAF'],
  );
  MobileAds.instance.updateRequestConfiguration(config);
  MobileAds.instance.initialize();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => SqliteDbService()),

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
        Provider(
          create:
              (BuildContext context) => ConsumptionRepository(
                sqliteDbService: context.read<SqliteDbService>(),
              ),
        ),
        Provider(
          create:
              (BuildContext context) => AlimentService(
                alimentRepository: context.read<AlimentRepository>(),
              ),
        ),
        Provider(
          create:
              (BuildContext context) => ConsumptionService(
                alimentService: context.read<AlimentService>(),
                consumptionRepository: context.read<ConsumptionRepository>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (BuildContext context) => ConsumptionVm(
                consumptionService: context.read<ConsumptionService>(),
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
      onGenerateRoute: (settings) {
        if (settings.name == '/addConsumption') {
          final ConsumptionModel consumption =
              settings.arguments as ConsumptionModel;
          return MaterialPageRoute(
            builder:
                (context) => AddConsumptionScreen(consumption: consumption),
          );
        }
        return MaterialPageRoute(
          builder: (BuildContext context) => MyHomePage(title: 'MacroMiam 🍽️'),
        );
      },
      routes: {
        '/': (BuildContext context) => MyHomePage(title: 'MacroMiam 🍽️'),
        '/addAliment': (BuildContext context) => AddAlimentScreen(),
        '/language': (BuildContext context) => LanguageScreen(),
        '/aliment': (BuildContext context) => AlimentScreen(),
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
          seedColor: Colors.pink.shade300,
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

  // final List<Widget> _widgets = [AddWidget(), ListWidget(), StatsWidget()];

  final List<Widget Function(double)> _widgets = [
    (maxWidth) => AddWidget(maxWidth: maxWidth),
    (maxWidth) => ListWidget(maxWidth: maxWidth),
    (maxWidth) => StatsWidget(maxWidth: maxWidth),
    (maxWidth) => ConsumptionWidget(maxWidth: maxWidth),
  ];

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

      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final maxWidth = constraints.maxWidth;
          final maxHeight = constraints.maxHeight;
          return SizedBox(
            width: maxWidth,
            height: maxHeight,
            child: Column(
              children: [
                Expanded(child: _widgets[index](maxWidth)),
                BannerPubWidget(),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(icon: Icon(Icons.ac_unit), label: ''),
        ],
      ),
    );
  }
}
