import 'dart:io';
import 'dart:typed_data';

import 'package:cnc_plotter/cubit/sketch_cubit.dart';
import 'package:cnc_plotter/cubit/sketch_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constant/color.dart';
import '../constant/image_const.dart';
import 'countdown_screen.dart';

class PreviewScreen extends StatelessWidget {
  final File imageFile;

  const PreviewScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SketchCubit, SketchState>(
        listener: (context, state) {
          if (state.isSentSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => CountdownScreen(
                  timeString: state.estimatedTime ?? '0:05:00',
                ),
              ),
            );
          }


          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
      child: Scaffold(
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
                    child: Image.file(imageFile),
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
      ),
    );
  }

  void _showConfirmDialog(BuildContext context) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (ctx) =>
          AlertDialog(
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

                  context.read<SketchCubit>().sendSketchToApi(imageFile);

                },
                child: const Text("Confirm"),
              ),
            ],
          ),
    );
  }
}