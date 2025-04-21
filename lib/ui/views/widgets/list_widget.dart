import 'package:flutter/material.dart';
import 'package:macromiam/data/services/sqlite_db_service.dart';
import 'package:macromiam/data/models/aliment_model.dart';
import 'package:provider/provider.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  late List<AlimentModel> _aliments = [];

  @override
  void initState() {
    super.initState();
    _fetchAliments();
  }

  Future<void> _fetchAliments() async {
    final sqliteDbService = context.read<SqliteDbService>();
    final List<AlimentModel> fetchAliments =
        await sqliteDbService.getAliments();
    print(DateTime.now());
    for (AlimentModel aliment in fetchAliments) {
      print(aliment.toString());
    }

    setState(() {
      _aliments = fetchAliments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_aliments.isEmpty) CircularProgressIndicator(),
          if (_aliments.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _aliments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: ListTile(
                      title: Text(_aliments[index].name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Proteins: ${_aliments[index].protein} g'),
                          Text(
                            'Carbohydrates: ${_aliments[index].carbohydrates} g',
                          ),
                          Text('Fat: ${_aliments[index].fat} g'),
                          Text('Calories: ${_aliments[index].calories} kcal'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
