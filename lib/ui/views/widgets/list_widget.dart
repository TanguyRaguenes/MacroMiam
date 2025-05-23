import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macromiam/ui/view_models/list_vm.dart';
import 'package:provider/provider.dart';

import '../../view_models/aliment_vm.dart';

class ListWidget extends StatefulWidget {
  final double maxWidth;

  const ListWidget({super.key, required this.maxWidth});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  bool _isFetchAlimentsDone = false;
  TextEditingController filterController = TextEditingController();

  @override
  void dispose() {
    _isFetchAlimentsDone = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ListVm listVm = context.watch<ListVm>();
    if (!_isFetchAlimentsDone) {
      listVm.fetchAliments();
      _isFetchAlimentsDone = true;
    }
    final aliments = listVm.aliments;
    return Column(
      children: [
        TextField(
          controller: filterController,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.search),
            hintText: 'Search',
          ),
          onChanged: (value) {
            listVm.filterList(value);
          },
        ),
        if (aliments.isEmpty)
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    strokeWidth: 10,
                  ),
                ),
              ],
            ),
          ),
        if (aliments.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: aliments.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () async {
                    final alimentVm = context.read<AlimentVm>();
                    alimentVm.setAlimentModel(aliments[index]);
                    await Navigator.pushNamed(context, '/addAliment');
                    listVm.fetchAliments();
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 3,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    aliments[index].imageSource != null
                                        ? aliments[index].imageSource!
                                                    .substring(0, 4) ==
                                                'http'
                                            ? Image.network(
                                              aliments[index].imageSource!,
                                            )
                                            : Image.file(
                                              fit: BoxFit.cover,
                                              File(
                                                aliments[index].imageSource!,
                                              ),
                                            )
                                        : Image.asset(
                                          'assets/images/no_image.png',
                                          fit: BoxFit.cover,
                                        ),
                              ),
                            ),
                          ),

                          SizedBox(width: 12),

                          Flexible(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aliments[index].name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Text('Proteins: ${aliments[index].proteins} g'),
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

                          SizedBox(width: 12),

                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed:
                                        () => {
                                          listVm.deleteAliment(
                                            id: aliments[index].id!,
                                            imageSource:
                                                aliments[index].imageSource,
                                          ),
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${aliments[index].name} deleted',
                                              ),
                                              backgroundColor: Colors.green,
                                              duration: Duration(
                                                milliseconds: 500,
                                              ),
                                            ),
                                          ),
                                        },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
