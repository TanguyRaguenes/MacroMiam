import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    final AlimentApiModel? aliment = alimentVm.getAlimentApiModel();

    final Map<String, dynamic> nutrimentItems = {
      AppLocalizations.of(context)!.energy: {
        'keyword': 'energy-kcal_100g',
        'image': 'energy_nobg.png',
        'unit': 'kcal',
      },
      AppLocalizations.of(context)!.proteins: {
        'keyword': 'proteins_100g',
        'image': 'proteins_nobg.png',
        'unit': 'g',
      },
      AppLocalizations.of(context)!.carbohydrates: {
        'keyword': 'carbohydrates_100g',
        'image': 'carbohydrates_nobg.png',
        'unit': 'g',
      },
      AppLocalizations.of(context)!.fat: {
        'keyword': 'fat_100g',
        'image': 'fat_nobg.png',
        'unit': 'g',
      },
    };
    return Scaffold(
      appBar: AppBar(title: Text('Food item details'), centerTitle: true),
      body: LayoutBuilder(
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
                                    '${aliment?.nutriments![nutrimentItem.value['keyword']]}',
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
                      onImageChosen: (path) {},
                      imageUrl: aliment?.imageFrontUrl,
                    ),
                  ),
                ),
                SizedBox(
                  width: maxWidth * 0.95,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Save food item'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
