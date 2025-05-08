import 'package:flutter/material.dart';
import 'package:macromiam/l10n/app_localizations.dart';
import 'package:macromiam/ui/view_models/aliment_vm.dart';
import 'package:macromiam/data/services/barcode_scanner_service.dart';
import 'package:provider/provider.dart';
import '../../../data/models/aliment_api_model.dart';

class AddWidget extends StatefulWidget {
  const AddWidget({super.key});

  @override
  State<AddWidget> createState() => _AddWidgetState();
}

class _AddWidgetState extends State<AddWidget> {
  bool isCameraVisible = false;

  void toggleIsCameraVisible() {
    setState(() {
      isCameraVisible = !isCameraVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final BarcodeScannerService barcodeScannerWidget = BarcodeScannerService();
    final AlimentVm alimentVm = context.read<AlimentVm>();
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final maxWidth = constraints.maxWidth;
          final maxheight = constraints.maxHeight;
          return Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: maxWidth * 0.8,
                    height: maxheight * 0.5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: maxWidth * 0.9,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      print('click');
                      alimentVm.setAlimentModel(null);
                      Navigator.pushNamed(context, '/addAliment');
                    },
                    label: Text(
                      AppLocalizations.of(
                        context,
                      )!.addWidget_manuallyAddANewAliment,
                    ),
                    icon: Icon(Icons.edit),
                  ),
                ),
                Text('OR'),

                SizedBox(
                  width: maxWidth * 0.9,
                  child: ElevatedButton.icon(
                    label: Text(
                      AppLocalizations.of(
                        context,
                      )!.addWidget_scanAnAlimentBarcode,
                    ),
                    icon: Icon(Icons.qr_code_outlined),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      final scaffoldMessenger = ScaffoldMessenger.of(context);

                      String? barcode = await barcodeScannerWidget.scan(
                        context: context,
                      );
                      print('barcode : $barcode');
                      if (barcode == null || barcode.isEmpty) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text('barcode not found')),
                        );
                        return;
                      }

                      AlimentApiModel? aliment = await alimentVm.fetchData(
                        barcode: barcode,
                      );
                      print(aliment.toString());
                      if (aliment == null) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text('Unknown barcode')),
                        );
                        return;
                      }
                      alimentVm.setAlimentApiModel(aliment);
                      navigator.pushNamed('/aliment');
                    },
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
