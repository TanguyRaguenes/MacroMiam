import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:macromiam/ui/view_models/aliment_viewmodel.dart';
import 'package:provider/provider.dart';

class AlimentScreen extends StatefulWidget {
  @override
  State<AlimentScreen> createState() => _AlimentScreenState();
}

class _AlimentScreenState extends State<AlimentScreen> {
  @override
  Widget build(BuildContext context) {
    final AlimentViewModel alimentViewModel = context.watch<AlimentViewModel>();
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.green,
        child: Column(
          children: [
            if (alimentViewModel.alimentApiModel?.imageFrontUrl == null ||
                alimentViewModel.alimentApiModel!.imageFrontUrl!.isEmpty)
              SvgPicture.asset('assets/images/No-Image-Placeholder.svg')
            else
              Image.network(alimentViewModel.alimentApiModel!.imageFrontUrl!),
          ],
        ),
      ),
    );
  }
}
