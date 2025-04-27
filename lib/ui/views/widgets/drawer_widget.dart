import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Header')),
          ListTile(
            title: Text('Language'),
            onTap: () {
              print('Youpi');
              Scaffold.of(context).closeDrawer();
              Navigator.pushNamed(context, '/language');
            },
          ),
          ListTile(title: Text('B')),
          ListTile(title: Text('C')),
        ],
      ),
    );
  }
}
