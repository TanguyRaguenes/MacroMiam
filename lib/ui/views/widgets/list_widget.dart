import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    Future.microtask(() {
      getAliments();
    });
  }

  Future<void> getAliments() async {
    context.read<ListViewModel>().getAliments();
  }

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
          TextField(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              hintText: 'Search',
            ),
            onChanged: (value) {
              listViewModel.filterList(value);
            },
          ),
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
                          Flexible(
                            flex: 3,
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    aliments[index].path != null
                                        ? Image.file(
                                          fit: BoxFit.cover,
                                          File(aliments[index].path!),
                                        )
                                        : SvgPicture.asset(
                                          'assets/images/No-Image-Placeholder.svg',
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

                          SizedBox(width: 12),

                          Flexible(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
