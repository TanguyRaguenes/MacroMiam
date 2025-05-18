import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:macromiam/data/models/textformfield_model.dart';
import 'package:macromiam/ui/view_models/aliment_vm.dart';
import 'package:provider/provider.dart';
import '../../../data/models/aliment_model.dart';
import '../../view_models/list_vm.dart';
import '../widgets/image_picker_widget.dart';

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
  String? _imageSource;
  XFile? _cacheImage;

  @override
  Widget build(BuildContext context) {
    final AlimentVm alimentVm = context.read<AlimentVm>();
    final AlimentModel? alimentModel = alimentVm.getAlimentModel();
    _imageSource = alimentModel?.imageSource;
    final ListVm listVm = context.read<ListVm>();

    List<TextFormFieldModel> inputs = [
      TextFormFieldModel(
        label: 'Food item name',
        hintText: 'Please enter the name',
        type: TextInputType.text,
        onSaved: (value) => _name = value,
        image: null,
        initialValue: alimentModel?.name,
      ),
      TextFormFieldModel(
        label: 'Amount of protein per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _protein = value,
        image: 'assets/images/proteins_nobg.png',
        initialValue: alimentModel?.proteins.toString(),
      ),
      TextFormFieldModel(
        label: 'Amount of carbohydrates per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _carbohydrates = value,
        image: 'assets/images/carbohydrates_nobg.png',
        initialValue: alimentModel?.carbohydrates.toString(),
      ),
      TextFormFieldModel(
        label: 'Amount of fat per 100g',
        hintText: 'In grams',
        type: TextInputType.number,
        onSaved: (value) => _fat = value,
        image: 'assets/images/fat_nobg.png',
        initialValue: alimentModel?.fat.toString(),
      ),
      TextFormFieldModel(
        label: 'Amount of calories per 100g',
        hintText: 'In kcal',
        type: TextInputType.number,
        onSaved: (value) => _calories = value,
        image: 'assets/images/energy_nobg.png',
        initialValue: alimentModel?.calories.toString(),
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
        alimentVm.saveAliment(
          id: alimentModel?.id,
          name: _name!,
          protein: _protein!,
          carbohydrates: _carbohydrates!,
          fat: _fat!,
          calories: _calories!,
          cacheImage: _cacheImage,
          imageSource: _imageSource,
        );

        listVm.fetchAliments();
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
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Manually add a new food item',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final maxWidth = constraints.maxWidth;
            return Column(
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
                          initialValue: input.initialValue,
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ImagePickerWidget(
                    onImageSelected: (cacheImage) {
                      _cacheImage = cacheImage;
                    },
                    imageSource: alimentModel?.imageSource,
                  ),
                ),
                SizedBox(
                  width: maxWidth * 0.95,
                  child: ElevatedButton(
                    onPressed: () {
                      submit();
                    },
                    child: Text('Add this food item to my list'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
