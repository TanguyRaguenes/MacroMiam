import 'package:flutter/material.dart';
import 'package:macromiam/helpers/database_helper.dart';
import 'package:macromiam/models/custom_aliment_model.dart';
import 'package:macromiam/models/textformfield_model.dart';

class AddManuallyAlimentPage extends StatefulWidget {
  const AddManuallyAlimentPage({super.key});

  @override
  State<AddManuallyAlimentPage> createState() => _AddManuallyAlimentPageState();
}

class _AddManuallyAlimentPageState extends State<AddManuallyAlimentPage> {
  var _formKey = GlobalKey<FormState>();

  var _alimentName;
  var _amountOfProtein;
  var _amountOfCarbohydrates;
  var _amountOfFat;
  var _calories;

  late List<TextFormFieldModel> inputs;

  @override
  void initState() {
    super.initState();
    inputs = [
      TextFormFieldModel(
        label: 'Aliment name',
        hintText: 'Please enter the name',
        type: TextInputType.text,
        onSaved: (value) => _alimentName = value,
      ),
      TextFormFieldModel(
        label: 'Amount of protein per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _amountOfProtein = value,
      ),
      TextFormFieldModel(
        label: 'Amount of carbohydrates per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _amountOfCarbohydrates = value,
      ),
      TextFormFieldModel(
        label: 'Amount of fat per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _amountOfFat = value,
      ),
      TextFormFieldModel(
        label: 'Amount of calories per 100g',
        hintText: 'In kcal',
        type: TextInputType.number,
        onSaved: (value) => _calories = value,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String? _validator(String? value) {
      if (value == Null || value!.isEmpty) {
        return 'This field is required.';
      }
      return null;
    }

    void submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        print('alimentName $_alimentName');
        print(_amountOfProtein);
        print(_amountOfCarbohydrates);
        print(_amountOfFat);
        print(_calories);
        final aliment = CustomAlimentModel(
          name: _alimentName,
          protein: double.tryParse(_amountOfProtein) ?? 0.0,
          carbohydrates: double.tryParse(_amountOfCarbohydrates) ?? 0.0,
          fat: double.tryParse(_amountOfFat) ?? 0.0,
          calories: double.tryParse(_calories) ?? 0.0,
        );
        DataBaseHelper().insertAliment(aliment);
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

// class MyInput {
//   final String label;
//   final String hintText;
//   final TextInputType type;
//   final FormFieldSetter<String>? onSaved;
//
//   MyInput({
//     required this.label,
//     required this.hintText,
//     required this.type,
//     this.onSaved,
//   });
// }
