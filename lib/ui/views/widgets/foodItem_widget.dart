import 'dart:io';

import 'package:flutter/material.dart';
import 'package:macromiam/data/models/aliment_model.dart';

class FoodItemWidget extends StatelessWidget {
  final AlimentModel aliment;
  final bool isDeleteButtonVisible;
  final VoidCallback onDelete;

  const FoodItemWidget({
    super.key,
    required this.aliment,
    required this.isDeleteButtonVisible,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      aliment.imageSource != null
                          ? aliment.imageSource!.substring(0, 4) == 'http'
                              ? Image.network(aliment.imageSource!)
                              : Image.file(
                                fit: BoxFit.cover,
                                File(aliment.imageSource!),
                              )
                          : Image.asset(
                            'assets/images/no_image.png',
                            fit: BoxFit.cover,
                          ),
                ),
              ),
            ),

            SizedBox(width: 12),

            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    aliment.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text('Proteins: ${aliment.proteins} g'),
                  Text('Carbohydrates: ${aliment.carbohydrates} g'),
                  Text('Fat: ${aliment.fat} g'),
                  Text('Calories: ${aliment.calories} kcal'),
                ],
              ),
            ),

            SizedBox(width: 12),

            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        onDelete();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
