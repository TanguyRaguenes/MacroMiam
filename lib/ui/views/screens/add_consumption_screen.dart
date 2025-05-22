import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/models/enums_model.dart';
import 'package:macromiam/ui/view_models/list_vm.dart';
import 'package:provider/provider.dart';

import '../../../data/models/aliment_model.dart';

class AddConsumptionScreen extends StatefulWidget {
  final ConsumptionModel consumption;

  const AddConsumptionScreen({super.key, required this.consumption});

  @override
  State<AddConsumptionScreen> createState() => _AddConsumptionScreenState();
}

class _AddConsumptionScreenState extends State<AddConsumptionScreen> {
  bool _isFetchAlimentsDone = false;
  final TextEditingController _alimentController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  AlimentModel? _alimentSelected;

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.consumption.quantityInGrams.toString();
    if (widget.consumption.aliment != null) {
      _alimentController.text = widget.consumption.aliment!.name;
      _alimentSelected = widget.consumption.aliment;
    }
  }

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
    listVm.fetchAliments();
    ConsumptionModel consumption = widget.consumption;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(consumption.dayOfWeek.label, style: TextStyle(fontSize: 20)),
            Text(
              consumption.mealType.label,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TextField(
            keyboardType: TextInputType.number,
            controller: _quantityController,
            onChanged: (value) {},
          ),
          TextField(controller: _alimentController),
          ElevatedButton(
            onPressed: () async {
              final List<AlimentModel> allAliments = listVm.aliments;
              List<AlimentModel> filteredAliments = allAliments;
              final TextEditingController filterController =
                  TextEditingController();
              final AlimentModel?
              alimentSelected = await showModalBottomSheet<AlimentModel>(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          children: [
                            TextField(
                              controller: filterController,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  filteredAliments =
                                      allAliments
                                          .where(
                                            (a) => a.name
                                                .toUpperCase()
                                                .contains(value.toUpperCase()),
                                          )
                                          .toList();
                                });
                              },
                            ),
                            Expanded(
                              child: ListView.builder(
                                // shrinkWrap: true,
                                itemCount: filteredAliments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(filteredAliments[index].name),
                                    subtitle: Text(
                                      'Per 100g : ${filteredAliments[index].proteins} prot | ${filteredAliments[index].carbohydrates} carb | ${filteredAliments[index].fat} fat | ${filteredAliments[index].calories} Cal',
                                    ),
                                    leading:
                                        filteredAliments[index].imageSource !=
                                                null
                                            ? Image.file(
                                              File(
                                                filteredAliments[index]
                                                    .imageSource!,
                                              ),
                                            )
                                            : null,
                                    onTap: () {
                                      Navigator.pop(
                                        context,
                                        filteredAliments[index],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
              if (alimentSelected != null) {
                setState(() {
                  _alimentSelected = alimentSelected;
                  _alimentController.text = _alimentSelected!.name;
                });
              }
            },
            child: Text('Select a food item'),
          ),
        ],
      ),
    );
  }
}
