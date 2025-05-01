import 'package:flutter/material.dart';
import 'package:macromiam/l10n/app_localizations.dart';
import 'package:macromiam/ui/view_models/add_aliment_viewmodel.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../view_models/aliment_viewmodel.dart';

class AddWidget extends StatelessWidget {
  const AddWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AddAlimentViewModel addAlimentViewModel =
        context.read<AddAlimentViewModel>();
    final AlimentViewModel alimentViewModel = context.read<AlimentViewModel>();
    return Container(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
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
          ),
          Text('OR'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  addAlimentViewModel.fetchData(
                    alimentViewModel: alimentViewModel,
                  );
                  Navigator.pushNamed(context, '/aliment');
                },
                label: Text(
                  AppLocalizations.of(context)!.addWidget_scanAnAlimentBarcode,
                ),
                icon: Icon(Icons.qr_code_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
