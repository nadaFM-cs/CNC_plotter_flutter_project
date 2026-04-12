
import 'package:cnc_plotter/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/sketch_cubit.dart';
import '../cubit/sketch_state.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cubit = context.read<SketchCubit>(); 

    return BlocBuilder<SketchCubit, SketchState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text("Upload Image", style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.85,
                      height: screenHeight * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: state.backgroundImage == null
                            ? Border.all(color: maincolor, width: 3)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: state.backgroundImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory( 
                                state.backgroundImage!,
                                fit: BoxFit.contain,
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_outlined,
                                color: maincolor,
                                size: 60,
                              ),
                            ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      _buildCircleButton(
                        icon: Icons.photo_library,
                        onTap: () => cubit.pickImage(fromCamera: false),
                      ),

                      const SizedBox(width: 24),

                    
                      GestureDetector(
                        onTap: () => cubit.pickImage(fromCamera: true),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: maincolor, width: 3),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                      ),

                      const SizedBox(width: 24),

                    
                      _buildCircleButton(
                        icon: Icons.send,
                        color: maincolor,
                        iconColor: Colors.black,
                        onTap: () {
                          if (state.backgroundImage == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(' Please select an image first!'),
                                backgroundColor: maincolor,
                              ),
                            );
                            
                          }
                         
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white24,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(icon, color: iconColor, size: 26),
      ),
    );
  }
}