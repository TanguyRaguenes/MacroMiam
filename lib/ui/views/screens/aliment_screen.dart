import 'package:flutter/material.dart';
import 'package:macromiam/data/models/aliment_api_model.dart';
import 'package:macromiam/ui/views/widgets/choose_image_widget.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../view_models/aliment_vm.dart';

class AlimentScreen extends StatefulWidget {
  const AlimentScreen({super.key});

  @override
  State<AlimentScreen> createState() => _AlimentScreenState();
}

class _AlimentScreenState extends State<AlimentScreen> {
  @override
  Widget build(BuildContext context) {
    final AlimentVm alimentVm = context.watch<AlimentVm>();
    final AlimentApiModel? alimentToDisplay = alimentVm.getAlimentApiModel();

    final Map<String, dynamic> alimentToSave = {
      'name': alimentToDisplay!.productName ?? '',
      'proteins': alimentToDisplay.nutriments!['proteins_100g'] ?? 0.0,
      'carbohydrates':
          alimentToDisplay.nutriments!['carbohydrates_100g'] ?? 0.0,
      'fat': alimentToDisplay.nutriments!['fat_100g'] ?? 0.0,
      'calories': alimentToDisplay.nutriments!['energy-kcal_100g'] ?? 0.0,
      'pathOrUrl': alimentToDisplay.imageFrontUrl,
    };

    final Map<String, dynamic> nutrimentItems = {
      AppLocalizations.of(context)!.energy: {
        'nutriment': 'calories',
        'keyword': 'energy-kcal_100g',
        'image': 'energy_nobg.png',
        'unit': 'kcal',
      },
      AppLocalizations.of(context)!.proteins: {
        'nutriment': 'proteins',
        'keyword': 'proteins_100g',
        'image': 'proteins_nobg.png',
        'unit': 'g',
      },
      AppLocalizations.of(context)!.carbohydrates: {
        'nutriment': 'carbohydrates',
        'keyword': 'carbohydrates_100g',
        'image': 'carbohydrates_nobg.png',
        'unit': 'g',
      },
      AppLocalizations.of(context)!.fat: {
        'nutriment': 'fat',
        'keyword': 'fat_100g',
        'image': 'fat_nobg.png',
        'unit': 'g',
      },
    };
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Food item details'), centerTitle: true),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final maxHeight = constraints.maxHeight;
            final maxWidth = constraints.maxWidth;
            return Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: maxWidth * 0.95,
                      child: TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        controller: TextEditingController(
                          text: alimentVm.getAlimentApiModel()!.productName!,
                        ),
                        onChanged: (value) {
                          alimentToSave['name'] = value;
                        },
                      ),
                    ),
                  ),
                  for (MapEntry<String, dynamic> nutrimentItem
                      in nutrimentItems.entries)
                    Card(
                      child: SizedBox(
                        width: maxWidth * 0.95,
                        child: Row(
                          children: [
                            SizedBox(
                              width: maxWidth * 0.10,
                              child: Image.asset(
                                'assets/images/${nutrimentItem.value['image']}',
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: maxWidth * 0.30,
                              child: Text(
                                nutrimentItem.key,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(width: 8),
                            Text(':'),
                            SizedBox(width: 8),

                            SizedBox(
                              width: maxWidth * 0.2,
                              child: TextField(
                                controller: TextEditingController(
                                  text:
                                      '${alimentToDisplay.nutriments![nutrimentItem.value['keyword']]}',
                                ),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 10,
                                  ),
                                ),
                                textAlign: TextAlign.right,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  alimentToSave[nutrimentItem
                                      .value['nutriment']] = double.tryParse(
                                    value,
                                  );
                                },
                              ),
                            ),

                            SizedBox(width: 8),
                            Text('${nutrimentItem.value['unit']}/100g'),
                          ],
                        ),
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ChooseImageWidget(
                        onImageChosen: (path) {
                          alimentToSave['pathOrUrl'] = path;
                        },
                        pathOrUrl: alimentToDisplay.imageFrontUrl,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: maxWidth * 0.95,
                    child: ElevatedButton(
                      onPressed: () {
                        alimentVm.saveAliment(
                          id: null,
                          name: alimentToSave['name'],
                          protein: alimentToSave['proteins'].toString(),
                          carbohydrates:
                              alimentToSave['carbohydrates'].toString(),
                          fat: alimentToSave['fat'].toString(),
                          calories: alimentToSave['calories'].toString(),
                          pathOrUrl: alimentToSave['pathOrUrl'],
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Food item added'),
                            backgroundColor: Colors.green,
                            duration: Duration(milliseconds: 500),
                          ),
                        );
                      },
                      child: Text('Save food item'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
