import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macromiam/providers/locale_provider.dart';
import 'package:provider/provider.dart';

class DailyConsumptionWidget extends StatefulWidget {
  const DailyConsumptionWidget({super.key});

  @override
  State<DailyConsumptionWidget> createState() => _DailyConsumptionWidgetState();
}

class _DailyConsumptionWidgetState extends State<DailyConsumptionWidget> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    LocaleProvider localeProvider = context.watch<LocaleProvider>();
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime(
      firstDate.month == 12 ? firstDate.year + 1 : firstDate.year,
      firstDate.month == 12 ? 2 : firstDate.month + 2,
      0,
    );

    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: firstDate,
              firstDate: firstDate,
              lastDate: lastDate,
            );
            print('___________________________________________');
            print(selectedDate);
            print('___________________________________________');

            setState(() {
              _selectedDate = selectedDate;
            });
          },
          child: Text('Pick a date'),
        ),
        if (_selectedDate != null)
          Text(
            DateFormat(
              'dd MMMM yyyy',
              localeProvider.locale.languageCode,
            ).format(_selectedDate!),
          ),
      ],
    );
  }
}
