import 'package:cnc_plotter/constant/app_config.dart';
import 'package:cnc_plotter/constant/color.dart';
import 'package:cnc_plotter/core/services/api_service.dart';
import 'package:cnc_plotter/screens/prompt.dart';
import 'package:cnc_plotter/screens/sketch_pad.dart';
import 'package:cnc_plotter/screens/upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/sketch_cubit.dart';

class Choosescreen extends StatelessWidget {
  const Choosescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 100),
                  Text(
                    "CNCr@ft",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: maincolor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Draw,Convert And Plot it",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: maincolor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            height: 500,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: maincolor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Choose your way to express!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 80),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
               
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => SketchCubit(ApiService(AppConfig.baseUrl))..resetState(),
                              child: const SketchpadScreen(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.brush, color: maincolor),
                      label: Text("Paint", style: TextStyle(color: maincolor.withOpacity(0.7))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(250, 50),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                      ),
                    ),

                    SizedBox(height: 50),

                  
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => SketchCubit(ApiService(AppConfig.baseUrl))..resetState(),
                              child: const UploadScreen(),
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.image, color: maincolor),
                      label: Text("Upload Image", style: TextStyle(color: maincolor.withOpacity(0.7))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(250, 50),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(20),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PromptScreen(),
                          ),
                        );
                      },
                      icon: Icon(Icons.text_fields, color: maincolor),
                      label: Text(
                        "Prompt",
                        style: TextStyle(color: maincolor.withOpacity(0.7)),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        minimumSize: Size(250, 50),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}