import 'package:cnc_plotter/constant/color.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/sketch_cubit.dart';
import '../cubit/sketch_state.dart';
import '../painter/sketch_painter.dart';

class SketchpadScreen extends StatelessWidget {
  const SketchpadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SketchCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<SketchCubit, SketchState>(
          builder: (context, state) {
            final cubit = context.read<SketchCubit>();

            return Stack(
              children: [
            

            if (state.backgroundImage != null)
              Positioned.fill(
                key: ValueKey(state.backgroundImage),   
                child: Image.memory(
                  state.backgroundImage!,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  gaplessPlayback: true,                 
                ),
              )
            else
              Container(color: Colors.white),
                        
                Positioned.fill(
                  child: GestureDetector(
                    onPanStart: (d) => cubit.startStroke(d.localPosition),
                    onPanUpdate: (d) => cubit.updateStroke(d.localPosition),
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

            
                Positioned(
                            top: 40,
                            left: 20,
                            right: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                          
                               
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: cubit.undo,
                                      icon: const Icon(Icons.undo, size: 28),
                                    ),
                                    IconButton(
                                      onPressed: cubit.clear,      
                                      icon: const Icon(Icons.delete, size: 28, color: Colors.red),
                                      tooltip: 'Delete All',
                                    ),
                                 IconButton(
                                        onPressed: () {
                                          if (state.strokes.isEmpty) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text(' Please draw something first!'),
                                                backgroundColor: maincolor,
                                              ),
                                            );
                                            return;
                                          }
                                       
                                        },
                                        icon: const Icon(Icons.send, size: 28, color: maincolor),
                                        
                                      ),
                                  ],
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
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
                                    ? Border.all(color: Colors.black, width: 3)
                                    : Border.all(color: Colors.grey.shade400, width: 1.5),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: color.withOpacity(0.6),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        )
                                      ]
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 100,
                  left: 40,
                  right: 40,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Slider(
                      value: state.strokeWidth,
                      min: 1.0,
                      max: 40.0,
                      divisions: 39,
                      label: state.strokeWidth.round().toString(),
                      onChanged: cubit.changeStrokeWidth,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}