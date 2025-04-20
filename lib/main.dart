import 'package:flutter/material.dart';
import 'screens/add_screen.dart';
import 'screens/list_screen.dart';
import 'screens/stats_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MacroMiam 🍽️',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange.shade300),
      ),
      home: const MyHomePage(title: 'MacroMiam 🍽️'),
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

  final List<Widget> _screens = [
    const AddScreen(),
    const ListScreen(),
    const StatsScreen(),
  ];

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

      body: SizedBox.expand(child: _screens[index]),

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
