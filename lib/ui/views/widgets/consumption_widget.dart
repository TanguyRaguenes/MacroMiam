import 'package:flutter/material.dart';
import 'package:macromiam/data/models/consumption_model.dart';
import 'package:macromiam/data/models/enums_model.dart';
import 'package:macromiam/ui/view_models/consumption_vm.dart';
import 'package:macromiam/ui/views/widgets/foodItem_widget.dart';
import 'package:provider/provider.dart';

class ConsumptionWidget extends StatefulWidget {
  final double maxWidth;

  const ConsumptionWidget({super.key, required this.maxWidth});

  @override
  State<ConsumptionWidget> createState() => _ConsumptionWidgetState();
}

class _ConsumptionWidgetState extends State<ConsumptionWidget> {
  int? _expandedDayIndex;
  int? _expandedMealIndex;
  final Map<int, String> _dayImagePaths = {};
  final Map<int, String> _mealImagePaths = {};

  @override
  void initState() {
    super.initState();
    context.read<ConsumptionVm>().getConsumptions();
    for (int i = 0; i < DayOfWeek.values.length; i++) {
      _dayImagePaths[i] = 'assets/images/night.png';
    }
    for (int i = 0; i < MealType.values.length; i++) {
      _mealImagePaths[i] = 'assets/images/sleep.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ConsumptionVm consumptionVm = context.watch<ConsumptionVm>();
    List<ConsumptionModel> consumptions = consumptionVm.consumptions;

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
              child: Builder(
                builder: (context) {
                  List<ConsumptionModel> consumptionsDay = consumptionVm
                      .filterConsumptions(day: DayOfWeek.values[i], meal: null);

                  return ExpansionTile(
                    key: UniqueKey(),
                    initiallyExpanded: _expandedDayIndex == i,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        _dayImagePaths[i] =
                            expanded
                                ? 'assets/images/day.png'
                                : 'assets/images/night.png';
                        _expandedDayIndex = expanded ? i : null;
                      });
                    },
                    leading: Image.asset(_dayImagePaths[i]!),
                    collapsedBackgroundColor:
                        Theme.of(context).colorScheme.onInverseSurface,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    title: Text(DayOfWeek.values[i].label),
                    subtitle: consumptionVm.getNutriments(
                      consumptions: consumptionsDay,
                    ),
                    children: [
                      for (int j = 0; j < MealType.values.length; j++)
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 0.5,
                            ),
                          ),
                          child: Builder(
                            builder: (context) {
                              final ScaffoldMessengerState
                              scaffoldMessengerState = ScaffoldMessenger.of(
                                context,
                              );
                              final List<ConsumptionModel> consumptionsMeal =
                                  consumptionVm.filterConsumptions(
                                    day: DayOfWeek.values[i],
                                    meal: MealType.values[j],
                                  );
                              return consumptionsMeal.isEmpty
                                  ? ListTile(
                                    title: Text(MealType.values[j].label),
                                    leading: IconButton(
                                      onPressed: () {
                                        addConsumption(
                                          context: context,
                                          day: DayOfWeek.values[i],
                                          meal: MealType.values[j],
                                        );
                                      },
                                      icon: Icon(Icons.add_circle),
                                    ),
                                  )
                                  : ExpansionTile(
                                    key: UniqueKey(),
                                    initiallyExpanded: _expandedMealIndex == j,
                                    onExpansionChanged: (expanded) {
                                      setState(() {
                                        _mealImagePaths[j] =
                                            expanded
                                                ? 'assets/images/eat.png'
                                                : 'assets/images/sleep.png';
                                        _expandedMealIndex =
                                            expanded ? j : null;
                                      });
                                    },
                                    trailing:
                                        consumptionsMeal.isEmpty
                                            ? SizedBox.shrink()
                                            : null,
                                    title: Row(
                                      children: [
                                        Image.asset(
                                          _mealImagePaths[j]!,
                                          width: 32,
                                          height: 32,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(MealType.values[j].label),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            addConsumption(
                                              context: context,
                                              day: DayOfWeek.values[i],
                                              meal: MealType.values[j],
                                            );
                                          },
                                          icon: Icon(Icons.add_circle),
                                        ),
                                      ],
                                    ),
                                    subtitle: consumptionVm.getNutriments(
                                      consumptions: consumptionsMeal,
                                    ),
                                    collapsedBackgroundColor:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onInverseSurface,
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).colorScheme.inversePrimary,
                                    children: [
                                      SizedBox(
                                        height: consumptionsMeal.length * 100,
                                        child: ListView.builder(
                                          itemCount: consumptionsMeal.length,
                                          itemBuilder: (
                                            BuildContext context,
                                            int index,
                                          ) {
                                            return FoodItemWidget(
                                              aliment:
                                                  consumptionsMeal[index]
                                                      .aliment!,
                                              isDeleteButtonVisible: true,
                                              onDelete: () async {
                                                await consumptionVm
                                                    .deleteConsumption(
                                                      id:
                                                          consumptionsMeal[index]
                                                              .id!,
                                                    );
                                                scaffoldMessengerState.showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      '${consumptionsMeal[index].aliment!.name} deleted',
                                                    ),
                                                    backgroundColor:
                                                        Colors.green,
                                                    duration: Duration(
                                                      milliseconds: 500,
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

void addConsumption({
  required BuildContext context,
  required DayOfWeek day,
  required MealType meal,
}) {
  Navigator.pushNamed(
    context,
    '/addConsumption',
    arguments: ConsumptionModel(
      id: null,
      aliment: null,
      quantityInGrams: null,
      mealType: meal,
      dayOfWeek: day,
    ),
  );
}
