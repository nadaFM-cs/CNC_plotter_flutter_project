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
  List <List<CustomItem>> strokes =[];
  List <CustomItem>currentStroke=[];
  double smoothingFactor = 0.2;
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
            currentStroke = [];
            currentStroke.add(CustomItem(
                offset: details.localPosition,
                paint: Paint()
                  ..color = selectColor
                  ..strokeWidth =Font));
          });
        },
          onPanUpdate: (details) {
            final newPoint = details.localPosition;

            if (currentStroke.isEmpty) return;

            final lastPoint = currentStroke.last.offset;

            final smoothPoint = Offset(
              lastPoint.dx + (newPoint.dx - lastPoint.dx) * smoothingFactor,
              lastPoint.dy + (newPoint.dy - lastPoint.dy) * smoothingFactor,
            );

            setState(() {
              currentStroke.add(
                CustomItem(
                  offset: smoothPoint,
                  paint: Paint()
                    ..color = selectColor
                    ..strokeWidth = Font
                    ..strokeCap = StrokeCap.round
                    ..strokeJoin = StrokeJoin.round
                    ..style = PaintingStyle.stroke,
                ),
              );
            });
          },
        onPanEnd: (details){
          setState(() {
            strokes.add(currentStroke);
            currentStroke =[];
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
                painter: namePainter(
                  strokes: strokes,
                  currentStroke: currentStroke,
                ),
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
                      if(strokes.isNotEmpty) IconButton(
                          onPressed: (){
                            setState(() {
                                  strokes.removeLast();
                            });
                          },
                          icon: Icon(
                            Icons.settings_backup_restore_outlined,
                            color:  Color(0xFF7C3FB1),
                          )
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
                              strokes.clear();
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
  List <List<CustomItem>>strokes = [];
  List <CustomItem>currentStroke=[];

  namePainter({
    required this.strokes,
    required this.currentStroke,
  });


  @override
  void paint(Canvas canvas, Size size){
    for(var stroke in strokes){
      for (int i = 0; i < stroke.length - 1; i++) {
        canvas.drawLine(
          stroke[i].offset,
          stroke[i + 1].offset,
          stroke[i].paint,
        );
      }
    }

    for(int i =0; i < currentStroke.length - 1; i++){
      canvas.drawLine(
        currentStroke[i].offset,
        currentStroke[i + 1].offset,
        currentStroke[i].paint,
      );
    }
  }

  @override
  bool shouldRepaint( namePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(namePainter oldDelegate) => false;
}

class CustomItem{
  Offset offset;
  Paint paint;
  CustomItem({ required this.offset, required this.paint});
}
