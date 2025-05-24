import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/models/enums_model.dart';
import 'package:macromiam/ui/view_models/consumption_vm.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _alimentController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = widget.consumption.quantityInGrams.toString();
    if (widget.consumption.aliment != null) {
      _alimentController.text = widget.consumption.aliment!.name;
    }
  }

  @override
  void dispose() {
    _isFetchAlimentsDone = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ConsumptionModel consumption = widget.consumption;
    final ConsumptionVm consumptionVm = context.read();
    final ListVm listVm = context.watch<ListVm>();
    final List<AlimentModel> allAliments = listVm.aliments;

    if (!_isFetchAlimentsDone) {
      listVm.fetchAliments();
      _isFetchAlimentsDone = true;
    }
    listVm.fetchAliments();
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
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  textAlign: TextAlign.end,
                  decoration: InputDecoration(
                    labelText: 'Quantity in grams',
                    suffixText: 'g',
                  ),
                  keyboardType: TextInputType.number,
                  controller: _quantityController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    consumption.quantityInGrams = double.parse(value!);
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Food item'),
                  keyboardType: TextInputType.text,
                  controller: _alimentController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a food item';
                    }
                    return null;
                  },
                  onTap: () async {
                    final AlimentModel? alimentSelected = await selectAnAliment(
                      context,
                      allAliments,
                    );
                    if (alimentSelected != null) {
                      setState(() {
                        consumption.aliment = alimentSelected;
                        _alimentController.text = alimentSelected.name;
                      });
                    }
                  },
                ),
                SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        consumptionVm.saveConsumption(consumption: consumption);
                      }
                    },
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<AlimentModel?> selectAnAliment(
  BuildContext context,
  List<AlimentModel> allAliments,
) async {
  List<AlimentModel> filteredAliments = allAliments;
  final AlimentModel?
  alimentSelected = await showModalBottomSheet<AlimentModel>(
    backgroundColor: Theme.of(context).colorScheme.onPrimary,
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: FractionallySizedBox(
              heightFactor: 0.6,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
                    onChanged: (value) {
                      setState(() {
                        filteredAliments =
                            allAliments
                                .where(
                                  (a) => a.name.toUpperCase().contains(
                                    value.toUpperCase(),
                                  ),
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
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, filteredAliments[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                              left: 8,
                              right: 8,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onInverseSurface,
                                // border: Border.all(color: Theme.of(context).colorScheme.inverseSurface),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child:
                                              filteredAliments[index]
                                                          .imageSource !=
                                                      null
                                                  ? filteredAliments[index]
                                                              .imageSource!
                                                              .substring(
                                                                0,
                                                                4,
                                                              ) ==
                                                          'http'
                                                      ? Image.network(
                                                        filteredAliments[index]
                                                            .imageSource!,
                                                      )
                                                      : Image.file(
                                                        fit: BoxFit.cover,
                                                        File(
                                                          filteredAliments[index]
                                                              .imageSource!,
                                                        ),
                                                      )
                                                  : Image.asset(
                                                    'assets/images/no_image.png',
                                                    fit: BoxFit.cover,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 30),
                                    Flexible(
                                      flex: 2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            filteredAliments[index].name,
                                            style:
                                                Theme.of(
                                                  context,
                                                ).textTheme.titleMedium,
                                          ),
                                          Text(
                                            'Proteins: ${filteredAliments[index].proteins} g',
                                          ),
                                          Text(
                                            'Carbohydrates: ${filteredAliments[index].carbohydrates} g',
                                          ),
                                          Text(
                                            'Fat: ${filteredAliments[index].fat} g',
                                          ),
                                          Text(
                                            'Calories: ${filteredAliments[index].calories} kcal',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  if (alimentSelected != null) {
    return alimentSelected;
  }

  return null;
}
