import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macromiam/data/models/textformfield_model.dart';
import 'package:macromiam/ui/view_models/aliment_vm.dart';
import 'package:macromiam/ui/views/widgets/choose_image_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/camera_widget.dart';

class AddAlimentScreen extends StatefulWidget {
  const AddAlimentScreen({super.key});

  @override
  State<AddAlimentScreen> createState() => _AddAlimentScreenState();
}

class _AddAlimentScreenState extends State<AddAlimentScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _protein;
  String? _carbohydrates;
  String? _fat;
  String? _calories;
  String? _imagePath;

  late final AlimentVm _addAlimentViewModel;

  @override
  void initState() {
    super.initState();
    _addAlimentViewModel = context.read<AlimentVm>();
  }

  @override
  Widget build(BuildContext context) {
    final addAlimentViewModel = context.watch<AlimentVm>();

    List<TextFormFieldModel> inputs = [
      TextFormFieldModel(
        label: 'Food item name',
        hintText: 'Please enter the name',
        type: TextInputType.text,
        onSaved: (value) => _name = value,
        image: null,
      ),
      TextFormFieldModel(
        label: 'Amount of protein per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _protein = value,
        image: 'assets/images/proteins_nobg.png',
      ),
      TextFormFieldModel(
        label: 'Amount of carbohydrates per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _carbohydrates = value,
        image: 'assets/images/carbohydrates_nobg.png',
      ),
      TextFormFieldModel(
        label: 'Amount of fat per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _fat = value,
        image: 'assets/images/fat_nobg.png',
      ),
      TextFormFieldModel(
        label: 'Amount of calories per 100g',
        hintText: 'In kcal',
        type: TextInputType.number,
        onSaved: (value) => _calories = value,
        image: 'assets/images/energy_nobg.png',
      ),
    ];

    String? validator(String? value) {
      if (value == null || value.isEmpty) {
        return 'This field is required.';
      }
      return null;
    }

    void submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        addAlimentViewModel.saveAliment(
          name: _name!,
          protein: _protein!,
          carbohydrates: _carbohydrates!,
          fat: _fat!,
          calories: _calories!,
          imagePath: _imagePath!,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Food item added'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 500),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manually add a new aliment',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  for (var input in inputs)
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: input.label,
                        hintText: input.hintText,

                        prefixIcon:
                            input.image != null
                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    input.image!,
                                    width: 24,
                                    height: 24,
                                  ),
                                )
                                : null,
                      ),
                      keyboardType: input.type,
                      validator: validator,
                      onSaved: input.onSaved,
                    ),
                ],
              ),
            ),
            Expanded(
              child: ChooseImageWidget(
                onImageChosen: (imagePath) {
                  _imagePath = imagePath;
                },
                imageUrl: null,
              ),
            ),

            ElevatedButton(
              onPressed: submit,
              child: Text('Add this food item to my list'),
            ),
          ],
        ),
      ),
    );
  }
}
