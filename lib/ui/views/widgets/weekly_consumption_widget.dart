import 'package:flutter/material.dart';

class WeeklyConsumptionWidget extends StatelessWidget {
  const WeeklyConsumptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime firsDate = DateTime.now();
    DateTime lastDate = firsDate.add(Duration(days: 61));
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // showDatePicker(
            //   context: context,
            //   firstDate: firsDate,
            //   lastDate: lastDate,
            // );
          },
          child: Text('Pick a week'),
        ),
      ],
    );
  }
}
