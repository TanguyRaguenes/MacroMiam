import 'package:flutter/material.dart';
import 'package:macromiam/ui/view_models/list_vm.dart';
import 'package:provider/provider.dart';

import '../../view_models/aliment_vm.dart';
import 'foodItem_widget.dart';

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
    final alimentVm = context.read<AlimentVm>();

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
                    alimentVm.setAlimentModel(aliments[index]);
                    await Navigator.pushNamed(context, '/addAliment');
                    listVm.fetchAliments();
                  },
                  child: FoodItemWidget(
                    aliment: aliments[index],
                    isDeleteButtonVisible: true,
                    onDelete: () {
                      listVm.deleteAliment(
                        id: aliments[index].id!,
                        imageSource: aliments[index].imageSource,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${aliments[index].name} deleted'),
                          backgroundColor: Colors.green,
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
