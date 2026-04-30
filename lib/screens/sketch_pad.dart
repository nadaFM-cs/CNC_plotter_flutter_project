import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cnc_plotter/constant/color.dart';
import 'package:cnc_plotter/constant/image_const.dart';
import 'package:cnc_plotter/screens/preview_sketch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/sketch_cubit.dart';
import '../cubit/sketch_state.dart';
import '../painter/sketch_painter.dart';
import 'package:path_provider/path_provider.dart';

class SketchpadScreen extends StatelessWidget {
  const SketchpadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SketchpadBody();
  }
}

class _SketchpadBody extends StatefulWidget {
  const _SketchpadBody();

  @override
  State<_SketchpadBody> createState() => _SketchpadBodyState();
}

class _SketchpadBodyState extends State<_SketchpadBody> {
  final GlobalKey _repaintKey = GlobalKey();

  Future<File> _captureAsFile() async {
    final boundary =
        _repaintKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;

    final image = await boundary!.toImage(pixelRatio: 3.0);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    final bytes = data!.buffer.asUint8List();

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/sketch.png');

    final resizedBytes = await resizeToA4Png(bytes);
    await file.writeAsBytes(resizedBytes);

    return file;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SketchCubit, SketchState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state.isSentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sketch sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SketchCubit>();

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: kA4WidthPx / kA4HeightPx,
                    child: RepaintBoundary(
                      key: _repaintKey,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: state.backgroundFile != null
                                ? Image.file(
                                    state.backgroundFile!,
                                    key: ValueKey(state.backgroundFile),
                                    fit: BoxFit.fill,
                                    gaplessPlayback: true,
                                  )
                                : Container(color: Colors.white),
                          ),
                          Positioned.fill(
                            child: GestureDetector(
                              onPanStart: (d) =>
                                  cubit.startStroke(d.localPosition),
                              onPanUpdate: (d) =>
                                  cubit.updateStroke(d.localPosition),
                              onPanEnd: (_) => cubit.endStroke(),
                              child: CustomPaint(
                                size: Size.infinite,
                                painter: SketchPainter(
                                  strokes: state.strokes,
                                  currentStroke: state.currentStroke,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 12,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: cubit.undo,
                        icon: const Icon(
                          Icons.undo,
                          size: 28,
                          color: maincolor,
                        ),
                      ),
                      IconButton(
                        onPressed: cubit.clear,
                        icon: const Icon(
                          Icons.delete,
                          size: 28,
                          color: Colors.red,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () async {
                          if (state.strokes.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please draw something first!'),
                              ),
                            );
                            return;
                          }

                          final file = await _captureAsFile();

                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PreviewScreen(imageFile: file),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 28,
                          color: maincolor,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: sketchColors.map((color) {
                          final isSelected = state.selectedColor == color;

                          return GestureDetector(
                            onTap: () => cubit.changeColor(color),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              width: isSelected ? 38 : 32,
                              height: isSelected ? 38 : 32,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(color: maincolor, width: 3)
                                    : Border.all(color: Colors.grey, width: 1),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                if (state.isSending)
                  Container(
                    color: Colors.black45,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 12),
                          Text(
                            "Sending...",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
