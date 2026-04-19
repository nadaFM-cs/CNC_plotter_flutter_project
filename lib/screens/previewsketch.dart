import 'dart:typed_data';

import 'package:cnc_plotter/cubit/sketch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constant/color.dart';
import '../constant/image_const.dart';

class PreviewScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const PreviewScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Preview A4"),
      ),
     body: Column(
  children: [
    Expanded(
      child: Center(
        child: AspectRatio(
          aspectRatio: kA4WidthPx / kA4HeightPx,
          child: Container(
            color: Colors.white,
            child: Image.memory(
              imageBytes,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    ),

    Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.edit),
            label: const Text("Edit"),
          ),
          ElevatedButton.icon(
            onPressed: () => _showConfirmDialog(context),
            icon: const Icon(Icons.send),
            label: const Text("Send"),
          ),
        ],
      ),
    ),
  ],
),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm "),
        content: const Text("Are you sure you want to send the sketch?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);

              context.read<SketchCubit>().sendSketchToApi(imageBytes);

              Navigator.pop(context); 
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}