import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macromiam/data/models/textformfield_model.dart';
import 'package:macromiam/ui/view_models/add_aliment_viewmodel.dart';
import 'package:provider/provider.dart';

import '../widgets/camera_widget.dart';

class AddAlimentScreen extends StatefulWidget {
  const AddAlimentScreen({super.key});

  @override
  State<AddAlimentScreen> createState() => _AddAlimentScreenState();
}

class _AddAlimentScreenState extends State<AddAlimentScreen> {
  final _formKey = GlobalKey<FormState>();

  var _name;
  var _protein;
  var _carbohydrates;
  var _fat;
  var _calories;

  late final AddAlimentViewModel _addAlimentViewModel;

  @override
  void initState() {
    super.initState();
    _addAlimentViewModel = context.read<AddAlimentViewModel>();
  }

  @override
  void dispose() {
    super.dispose();
    _addAlimentViewModel.disposeState();
  }

  @override
  Widget build(BuildContext context) {
    final addAlimentViewModel = context.watch<AddAlimentViewModel>();

    List<TextFormFieldModel> inputs = [
      TextFormFieldModel(
        label: 'Food item name',
        hintText: 'Please enter the name',
        type: TextInputType.text,
        onSaved: (value) => _name = value,
      ),
      TextFormFieldModel(
        label: 'Amount of protein per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _protein = value,
      ),
      TextFormFieldModel(
        label: 'Amount of carbohydrates per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _carbohydrates = value,
      ),
      TextFormFieldModel(
        label: 'Amount of fat per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _fat = value,
      ),
      TextFormFieldModel(
        label: 'Amount of calories per 100g',
        hintText: 'In kcal',
        type: TextInputType.number,
        onSaved: (value) => _calories = value,
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
          _name,
          _protein,
          _carbohydrates,
          _fat,
          _calories,
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
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                for (var input in inputs)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: input.label,
                      hintText: input.hintText,
                    ),
                    keyboardType: input.type,
                    validator: validator,
                    onSaved: input.onSaved,
                  ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (addAlimentViewModel.isCameraVisible) {
                              addAlimentViewModel.toggleIsCameraVisible();
                            }
                            addAlimentViewModel.selectFile();
                          },
                          child: Text('Pick an image'),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('OR'),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: addAlimentViewModel.toggleIsCameraVisible,
                          child: Text('Take a picture'),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child:
                        addAlimentViewModel.isCameraVisible
                            ? CameraWidget(
                              onPictureTaken: (path) {
                                addAlimentViewModel.imagePath = path;
                                addAlimentViewModel.toggleIsCameraVisible();
                              },
                              onBarcodeDetected: null,
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  addAlimentViewModel.imagePath != null
                                      ? Image.file(
                                        File(addAlimentViewModel.imagePath!),
                                        fit: BoxFit.cover,
                                      )
                                      : SvgPicture.asset(
                                        'assets/images/No-Image-Placeholder.svg',
                                        fit: BoxFit.cover,
                                      ),
                            ),
                  ),
                ),

                // Bouton final
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submit,
                      child: Text('Add this food item to my list'),
                    ),
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
