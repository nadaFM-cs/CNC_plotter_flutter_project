import 'package:cnc_plotter/constant/app_config.dart';
import 'package:cnc_plotter/constant/color.dart';
import 'package:cnc_plotter/screens/choose_screen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = AppConfig.ip;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showIPDialog();
    });
  }

  void _showIPDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (cntxt) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Server Configuration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter the server IP address:'),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'IP Address',
                  hintText: '192.168.X.X',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.wifi),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  AppConfig.changeIP(controller.text);
                  Navigator.pop(cntxt);
                }
              },
              child: const Text('Save & Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset("Images/start.jpg", fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.3)),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " Sketch your idea!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: maincolor.withOpacity(0.9),
                    letterSpacing: 1.2,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2b4736),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Choosescreen()),
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
