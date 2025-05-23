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

  // Gestion form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double? _quantityToSave;
  AlimentModel? _alimentToSave;

  String? _validateQuantity(){
    if(_quantityToSave==null && _quantityToSave.isNumeric)
  }

  void _onSubmit() {}

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
            Text(consumption.mealType.label, style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                    onSaved: (value) {
                  _quantityToSave=value as double?;
                },
                validator: _validateQuantity,),
                TextFormField(),
                ElevatedButton(
                  onPressed: () {
                    _onSubmit();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
          // TextField(
          //   keyboardType: TextInputType.number,
          //   controller: _quantityController,
          //   onChanged: (value) {},
          // ),
          // TextField(controller: _alimentController),
          ElevatedButton(
            onPressed: () async {
              final List<AlimentModel> allAliments = listVm.aliments;
              List<AlimentModel> filteredAliments = allAliments;
              final AlimentModel? alimentSelected = await showModalBottomSheet<AlimentModel>(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
                useSafeArea: true,
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Theme.of(context).colorScheme.onInverseSurface,
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
                                                      borderRadius: BorderRadius.circular(8),
                                                      child:
                                                          filteredAliments[index].imageSource !=
                                                                  null
                                                              ? filteredAliments[index].imageSource!
                                                                          .substring(0, 4) ==
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
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        filteredAliments[index].name,
                                                        style:
                                                            Theme.of(context).textTheme.titleMedium,
                                                      ),
                                                      Text(
                                                        'Proteins: ${filteredAliments[index].proteins} g',
                                                      ),
                                                      Text(
                                                        'Carbohydrates: ${filteredAliments[index].carbohydrates} g',
                                                      ),
                                                      Text('Fat: ${filteredAliments[index].fat} g'),
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
