import 'package:flutter/material.dart';
import 'package:macromiam/l10n/app_localizations.dart';
import 'package:macromiam/ui/view_models/add_aliment_viewmodel.dart';
import 'package:macromiam/ui/views/widgets/camera_widget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../view_models/aliment_viewmodel.dart';

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
    final AddAlimentViewModel addAlimentViewModel =
        context.read<AddAlimentViewModel>();
    final AlimentViewModel alimentViewModel = context.read<AlimentViewModel>();
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  print('click');
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
              width: double.infinity,
              child: ElevatedButton.icon(
                label: Text(
                  AppLocalizations.of(context)!.addWidget_scanAnAlimentBarcode,
                ),
                icon: Icon(Icons.qr_code_outlined),
                onPressed: () async {
                  String? res = await SimpleBarcodeScanner.scanBarcode(
                    context,
                    barcodeAppBar: const BarcodeAppBar(
                      appBarTitle: 'Test',
                      centerTitle: false,
                      enableBackButton: true,
                      backButtonIcon: Icon(Icons.arrow_back),
                    ),
                    isShowFlashIcon: true,
                    delayMillis: 2000,
                    cameraFace: CameraFace.back,
                  );

                  print(
                    '/////////////////////////////////////////////////////////////',
                  );

                  print(res as String);

                  print(
                    '/////////////////////////////////////////////////////////////',
                  );

                  addAlimentViewModel.fetchData(
                    alimentViewModel: alimentViewModel,
                    barcode: res as String,
                  );

                  Navigator.pushNamed(context, '/aliment');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
