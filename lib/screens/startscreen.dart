import 'package:cnc_plotter/constant/color.dart';
import 'package:cnc_plotter/screens/choosescreen.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "Images/start.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),

      
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(" Sketch your idea!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: maincolor.withOpacity(0.9),
                      letterSpacing: 1.2,
                      
                     ),
                    ),
                    SizedBox(height: 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2b4736),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Choosescreen(),
                  ),
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