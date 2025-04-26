import 'package:flutter/material.dart';
import 'package:macromiam/ui/view_models/list_viewmodel.dart';
import '../../data/services/sqlite_db_service.dart';
import 'ui/view_models/add_aliment_viewmodel.dart';
import 'data/repositories/aliment_repository.dart';
import 'ui/views/widgets/add_widget.dart';
import 'ui/views/widgets/list_widget.dart';
import 'ui/views/widgets/stats_widget.dart';
import 'ui/views/screens/add_aliment_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => SqliteDbService()),

        Provider(
          create:
              (context) => AlimentRepository(
                sqliteDbService: context.read<SqliteDbService>(),
              ),
        ),

        ChangeNotifierProvider(
          create:
              (context) => AddAlimentViewModel(
                alimentRepository: context.read<AlimentRepository>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => ListViewModel(
                alimentRepository: context.read<AlimentRepository>(),
              ),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => MyHomePage(title: 'MacroMiam 🍽️'),
          '/addAliment': (context) => AddAlimentScreen(),
        },
        title: 'MacroMiam 🍽️',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade300),
        ),
      ),
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
    return Scaffold(
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
                print('Open menu');
              },
              tooltip: ('Open menu'),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle_rounded),
            tooltip: 'Open account',
            onPressed: () {
              print('Open account');
            },
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
