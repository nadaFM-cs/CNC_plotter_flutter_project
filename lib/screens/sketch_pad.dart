import 'dart:ui';

import 'package:flutter/material.dart';

class Sketchpad extends StatefulWidget {
  const Sketchpad({super.key});

  @override
  State<Sketchpad> createState() => _SketchpadState();
}

class _SketchpadState extends State<Sketchpad> {
  List <Color> colors=[
    Color(0xFFFDEFB4),
    Color(0xFFFFAD9B),
    Color(0xFFFF9BB9),
    Color(0xFFFCADFF),
    Color(0xFF80A3F3),
    Color(0xFFA6E8FF),
    Color(0xFFBEFFC2),
  ];
  Color selectColor = Color(0xFFFDEFB4);
  double Font = 5.0;
  List paints=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
            List.generate(
              colors.length,
              (index) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    selectColor=colors[index];
                  });
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[index],
                    border:selectColor==colors[index]? Border.all(color: Color(0xFF7C3FB1),width: 2):null,
                  ),
                ),
              ),
            ),
            ),
        ),
        height: 50,
        width: MediaQuery.of(context).size.width-50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(1, 1)
            )
          ]
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            paints.add(CustomItem(
                offset: details.localPosition,
                paint: Paint()
                  ..color = selectColor
                  ..strokeWidth =Font));
          });
        },
        onPanUpdate: (details){
          setState(() {
            paints.add(CustomItem(
                offset: details.localPosition,
                paint: Paint()
                  ..color = selectColor
                  ..strokeWidth =Font));
          });
        },
        onPanEnd: (details){
          setState(() {
            paints.add(null);
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Stack(
            children: [
              CustomPaint(
                child: Container(),
                painter: namePainter(paints: paints),
              ),
              Positioned(
                top: 20.0,
                child:
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: Slider(
                            activeColor:     Color(0xFF7C3FB1),
                              inactiveColor: Colors.grey.shade500,
                              min: 1.0,
                              max: 50.0,
                              value: Font,
                              onChanged: (value){
                                setState(() {
                                  Font =value;
                                });
                              }
                        ),
                      ),
                      if(paints.isNotEmpty) IconButton(
                          onPressed: (){
                            setState(() {
                              paints.removeLast();
                              paints.removeLast();
                              paints.add(null);
                            });
                          },
                          icon: Icon(Icons.settings_backup_restore_outlined,color:  Color(0xFF7C3FB1),)
                      ),

                      SizedBox(
                        width: 40,
                      ),

                      ElevatedButton.icon(
                          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(
                              Colors.white
                          )
                          ),
                        onPressed: (){
                            setState(() {
                              paints.clear();
                            });
                        },
                        label: Text(
                        "Clear",
                        style: TextStyle(
                            color:  Color(0xFF7C3FB1)
                        ),
                      )
                        ,icon: Icon(Icons.cancel_outlined,
                        color:  Color(0xFF7C3FB1),),
                      )
                    ],
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class namePainter extends CustomPainter{
  List paints = [];
  namePainter({required this.paints});
  @override
  void paint(Canvas canvas, Size size){
    for(var i = 0; i< paints.length; i++){
        if(paints[i]!= null && paints[i+1]!= null){
          canvas.drawLine(paints[i].offset, paints[i+1].offset, paints[i].paint);
        }else if(paints[i] != null && paints[i+1] == null){
          canvas.drawPoints(
              PointMode.points, [paints[i].offset], paints[i].paint);
        }
    }
  }

  @override
  bool shouldRepaint(namePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(namePainter oldDelegate) => false;
}

class CustomItem{
  Offset offset;
  Paint paint;
  CustomItem({ required this.offset, required this.paint});
}