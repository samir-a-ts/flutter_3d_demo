import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_object/flutter_object.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '3D Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final _controller = ObjectViewController();

  late AnimationController animationC;

  @override
  void initState() {
    animationC = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 10,
    );

    animationC.addListener(() {
      _controller.angleX = animationC.value;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 400,
              height: 400,
              child: ObjectWidget(
                source: ObjectSource.fromAssets("assets/FinalBaseMesh.obj"),
                controller: _controller
                  ..offset = 12
                  ..angleZ = 0,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: SizedBox(
                width: 400,
                height: 20,
                child: AnimatedBuilder(
                  animation: animationC,
                  builder: (context, snapshot) {
                    return Slider(
                      value: _controller.angleX,
                      min: 0.0,
                      max: 10.0,
                      onChanged: (_) {
                        animationC.value = _;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
