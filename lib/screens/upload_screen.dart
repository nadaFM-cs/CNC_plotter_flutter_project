import 'package:cnc_plotter/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constant/image_const.dart';
import '../cubit/sketch_cubit.dart';
import '../cubit/sketch_state.dart';


class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _UploadBody();
  }
}

class _UploadBody extends StatefulWidget {
  const _UploadBody();

  @override
  State<_UploadBody> createState() => _UploadBodyState();
}

class _UploadBodyState extends State<_UploadBody> {

  void _showSendDialog(BuildContext context, SketchCubit cubit) {
    showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Ready to Send?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Do you want to edit your image or send it?'),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          OutlinedButton.icon(
            onPressed: () => Navigator.of(ctx).pop(),
            icon: const Icon(Icons.edit),
            label: const Text('EDIT'),
            style: OutlinedButton.styleFrom(
              foregroundColor: maincolor,
              side: BorderSide(color: maincolor),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await cubit.sendUploadedImageToApi(
                  cubit.state.backgroundFile!
              );
            },
            icon: const Icon(Icons.send),
            label: const Text('SEND'),
            style: ElevatedButton.styleFrom(
              backgroundColor: maincolor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SketchCubit>();

    return BlocConsumer<SketchCubit, SketchState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ));
        }
        if (state.isSentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Image sent successfully!'),
            backgroundColor: Colors.green,
          ));
        }
      },
      builder: (context, state) {
        if (state.isSending) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: maincolor),
                  SizedBox(height: 16),
                  Text('Sending image...',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Upload Image',
                style: TextStyle(color: Colors.white)),
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
                    child: AspectRatio(
                      aspectRatio: kA4WidthPx / kA4HeightPx,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: state.backgroundFile == null
                              ? Border.all(color: maincolor, width: 3)
                              : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: state.backgroundFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(state.backgroundFile!),
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined,
                                        color: maincolor, size: 60),
                                    SizedBox(height: 8),
                                    Text('A4 Format (595 × 842 px)',
                                        style: TextStyle(
                                            color: maincolor, fontSize: 12)),
                                  ],
                                ),
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
                          child: const Icon(Icons.camera_alt,
                              color: Colors.black, size: 32),
                        ),
                      ),
                      const SizedBox(width: 24),
                      _buildCircleButton(
                        icon: Icons.send,
                        color: maincolor,
                        iconColor: Colors.black,
                        onTap: () {
                          if (state.backgroundFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select an image first!'),
                                backgroundColor: maincolor,
                              ),
                            );
                            return;
                          }
                          _showSendDialog(context, cubit);
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
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: iconColor, size: 26),
      ),
    );
  }
}