import 'package:flutter/material.dart';
import 'package:macromiam/helpers/database_helper.dart';
import 'package:macromiam/models/custom_aliment_model.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  late List<CustomAlimentModel> _aliments = [];

  @override
  void initState() {
    super.initState();
    _fetchAliments();
  }

  Future<void> _fetchAliments() async {
    final List<CustomAlimentModel> fetchAliments =
        await DataBaseHelper().getAliments();
    print(DateTime.now());
    for (CustomAlimentModel aliment in fetchAliments) {
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
