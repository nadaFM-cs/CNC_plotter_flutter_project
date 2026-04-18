import 'package:cnc_plotter/constant/color.dart';
import 'package:cnc_plotter/constant/image_const.dart';
import 'package:cnc_plotter/cubit/prompt_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/prompt_cubit.dart';

class PromptScreen extends StatelessWidget {
  const PromptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PromptCubit(),
      child: const _PromptScreenBody(),
    );
  }
}

class _PromptScreenBody extends StatefulWidget {
  const _PromptScreenBody();

  @override
  State<_PromptScreenBody> createState() => _PromptScreenBodyState();
}

class _PromptScreenBodyState extends State<_PromptScreenBody> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _editsController = TextEditingController();

  @override
  void dispose() {
    _promptController.dispose();
    _editsController.dispose();
    super.dispose();
  }

  void _showConfirmationDialog(BuildContext context) {
    final cubit = context.read<PromptCubit>();
    showDialog(
      barrierColor: Colors.black54,
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirmation',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content:
            const Text('Are you sure you want to send the image?'),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              cubit.goToEdits();
            },
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
            onPressed: () {
              Navigator.of(ctx).pop();
              cubit.sendFinalImageForGCode();
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
    return BlocConsumer<PromptCubit, PromptState>(
      listener: (context, state) {
        if (state is PromptError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red),
          );
        }
        if (state is PromptSentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully sent '),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              switch (state.screenState) {
                PromptScreenState.inputPrompt => 'Write Your Prompt',
                PromptScreenState.showImage => 'Here is Your Image',
                PromptScreenState.inputEdits => 'Write Your Edits',
              },
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            leading: state.screenState != PromptScreenState.inputPrompt
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (state.screenState ==
                          PromptScreenState.inputEdits) {
                        context.read<PromptCubit>().goBackToImage();
                      } else {
                        context.read<PromptCubit>().goBackToPrompt();
                      }
                    },
                  )
                : null,
          ),
          body: state is PromptLoading
              ? _buildLoading()
              : _buildCurrentScreen(context, state),
        );
      },
    );
  }

  Widget _buildCurrentScreen(BuildContext context, PromptState state) =>
      switch (state.screenState) {
        PromptScreenState.inputPrompt => _buildPromptInput(context),
        PromptScreenState.showImage =>
          _buildImageDisplay(context, state.imageUrl),
        PromptScreenState.inputEdits => _buildEditsInput(context),
      };

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Processing...', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPromptInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _promptController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your prompt here...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: maincolor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final prompt = _promptController.text.trim();
                if (prompt.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please write a prompt first')),
                  );
                  return;
                }
                context.read<PromptCubit>().sendPrompt(prompt);
              },
             
              label: const Text('Generate',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageDisplay(BuildContext context, String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
            
                aspectRatio: kA4WidthPx / kA4HeightPx,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                      
                        fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.broken_image,
                                size: 64, color: Colors.grey),
                          ),
                        )
                      : const Center(child: Text('No image available')),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () =>
                      context.read<PromptCubit>().goToEdits(),
                  icon: Icon(Icons.edit, color: maincolor),
                  label: Text('Edit',
                      style:
                          TextStyle(color: maincolor, fontSize: 16)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: maincolor, width: 2),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showConfirmationDialog(context),
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Send',
                      style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditsInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Write your edit here:',
            style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _editsController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your edit here...',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: maincolor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final edits = _editsController.text.trim();
                if (edits.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Please write your edit first')),
                  );
                  return;
                }
                context.read<PromptCubit>().sendEdits(edits);
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Send Edit',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}