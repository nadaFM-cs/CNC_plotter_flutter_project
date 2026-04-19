import 'package:cnc_plotter/constant/color.dart';
import 'package:cnc_plotter/constant/image_const.dart';
import 'package:cnc_plotter/cubit/prompt_state.dart';
import 'package:cnc_plotter/screens/choosescreen.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PromptCubit, PromptState>(
      listener: (context, state) {
        if (state is PromptError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }

        if (state is PromptSentSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully sent'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Choosescreen()),
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
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: state.screenState != PromptScreenState.inputPrompt
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (state.screenState == PromptScreenState.inputEdits) {
                        context.read<PromptCubit>().goBackToImage();
                      } else {
                        context.read<PromptCubit>().goBackToPrompt();
                      }
                    },
                  )
                : null,
          ),
         body: Stack(
  children: [
    _buildCurrentScreen(context, state),

    if (state is PromptLoading)
      Container(
        color: Colors.black26,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
  ],
),
        );
      },
    );
  }

  Widget _buildCurrentScreen(BuildContext context, PromptState state) {
    return switch (state.screenState) {
      PromptScreenState.inputPrompt => _buildPromptInput(context),
      PromptScreenState.showImage =>
        _buildImageDisplay(context, state.imageUrl),
      PromptScreenState.inputEdits => _buildEditsInput(context),
    };
  }

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
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: maincolor, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final prompt = _promptController.text.trim();
                if (prompt.isEmpty) return;

                context.read<PromptCubit>().sendPrompt(prompt);
              },
              child: const Text(
                'Generate',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                 child: imageUrl != null
    ? ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      )
    : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text(
            "Waiting for AI image...",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
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
                  label: Text(
                    'Edit',
                    style: TextStyle(color: maincolor),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showConfirmationDialog(context),
                  icon: const Icon(Icons.send, color: Colors.white),
                  label: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
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
          TextField(
            controller: _editsController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Write your edits...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
              ),
              onPressed: () {
                final edits = _editsController.text.trim();
                if (edits.isEmpty) return;

                context.read<PromptCubit>().sendEdits(edits);
              },
              child: const Text(
                'Send Edit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    final cubit = context.read<PromptCubit>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Send image for G-code?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.goToEdits();
            },
            child: const Text('EDIT'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              cubit.sendFinalImageForGCode();
            },
            child: const Text('SEND'),
          ),
        ],
      ),
    );
  }
}