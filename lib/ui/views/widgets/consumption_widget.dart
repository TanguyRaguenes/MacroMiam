import 'package:flutter/material.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/models/enums_model.dart';
import 'package:macromiam/ui/view_models/consumption_vm.dart';
import 'package:provider/provider.dart';

class ConsumptionWidget extends StatefulWidget {
  final double maxWidth;

  const ConsumptionWidget({super.key, required this.maxWidth});

  @override
  State<ConsumptionWidget> createState() => _ConsumptionWidgetState();
}

class _ConsumptionWidgetState extends State<ConsumptionWidget> {
  int? _expandedDayIndex;

  @override
  void initState() {
    super.initState();
    context.read<ConsumptionVm>().getConsumptions().then((consumptions) {
      for (ConsumptionModel consumption in consumptions) {
        print(consumption.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ConsumptionVm consumptionVm = context.read<ConsumptionVm>();

    return SingleChildScrollView(
      child: Column(
        children: [
          for (int i = 0; i < DayOfWeek.values.length; i++)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 0.5,
                ),
              ),
              child: ExpansionTile(
                key: UniqueKey(),
                initiallyExpanded: _expandedDayIndex == i,
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expandedDayIndex = expanded ? i : null;
                  });
                },
                leading: Image.asset('assets/images/day_nobg.png'),
                collapsedBackgroundColor:
                    Theme.of(context).colorScheme.onInverseSurface,
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text(DayOfWeek.values[i].label),
                children: [
                  for (int j = 0; j < MealType.values.length; j++)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 0.5,
                        ),
                      ),
                      child: ExpansionTile(
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/addConsumption',
                              arguments: ConsumptionModel(
                                aliment: null,
                                quantityInGrams: 0,
                                mealType: MealType.values[j],
                                dayOfWeek: DayOfWeek.values[i],
                              ),
                            );
                          },
                          icon: Icon(Icons.add_circle),
                        ),
                        title: Text(MealType.values[j].label),
                        collapsedBackgroundColor:
                            Theme.of(context).colorScheme.onInverseSurface,
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
