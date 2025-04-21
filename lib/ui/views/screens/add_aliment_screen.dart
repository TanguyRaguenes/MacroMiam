import 'package:flutter/material.dart';
import 'package:macromiam/data/models/textformfield_model.dart';
import 'package:macromiam/ui/view_models/add_aliment_viewmodel.dart';
import 'package:provider/provider.dart';

class AddAlimentScreen extends StatefulWidget {
  const AddAlimentScreen({super.key});

  @override
  State<AddAlimentScreen> createState() => _AddAlimentScreenState();
}

class _AddAlimentScreenState extends State<AddAlimentScreen> {
  var _formKey = GlobalKey<FormState>();

  var _name;
  var _protein;
  var _carbohydrates;
  var _fat;
  var _calories;

  @override
  Widget build(BuildContext context) {
    List<TextFormFieldModel> inputs = [
      TextFormFieldModel(
        label: 'Aliment name',
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

    String? _validator(String? value) {
      if (value == Null || value!.isEmpty) {
        return 'This field is required.';
      }
      return null;
    }

    void submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        final addAlimentViewModel = context.read<AddAlimentViewModel>();
        addAlimentViewModel.saveAliment(
          _name,
          _protein,
          _carbohydrates,
          _fat,
          _calories,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add manually aliment')),
      body: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.primaryContainer,
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
                  validator: _validator,
                  onSaved: input.onSaved,
                ),
              ElevatedButton(onPressed: submit, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
