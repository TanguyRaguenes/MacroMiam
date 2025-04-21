import 'package:flutter/material.dart';
import 'package:macromiam/data/services/sqlite_db_service.dart';
import 'package:macromiam/data/models/aliment_model.dart';
import 'package:macromiam/ui/view_models/list_viewmodel.dart';
import 'package:provider/provider.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  @override
  void initState() {
    super.initState();
    // _fetchAliments();
  }

  // Future<void> _fetchAliments() async {
  //   _listViewModel = context.read<ListViewModel>();
  //   final List<AlimentModel> fetchAliments = await _listViewModel.getAliments();
  //
  //   setState(() {
  //     _aliments = fetchAliments;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final listViewModel = context.watch<ListViewModel>();
    final aliments = listViewModel.aliments;
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (aliments.isEmpty) CircularProgressIndicator(),
          if (aliments.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: aliments.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aliments[index].name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text('Proteins: ${aliments[index].protein} g'),
                                Text(
                                  'Carbohydrates: ${aliments[index].carbohydrates} g',
                                ),
                                Text('Fat: ${aliments[index].fat} g'),
                                Text(
                                  'Calories: ${aliments[index].calories} kcal',
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed:
                                    () => print(
                                      'Ajouter ${aliments[index].name}',
                                    ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed:
                                    () => {
                                      listViewModel.deleteAliment(
                                        aliments[index].id!,
                                      ),
                                    },
                              ),
                            ],
                          ),
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
