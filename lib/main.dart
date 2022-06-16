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
      title: "3D Demo",
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

class _MyHomePageState extends State<MyHomePage> {
  final _controller = ObjectViewController();

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
                source: ObjectSource.fromAssets("assets/man.obj"),
                controller: _controller
                  ..offset = 10
                  ..translation = const Offset(0, -100),
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
                  animation: _controller,
                  builder: (context, snapshot) {
                    return Slider(
                      value: _controller.angleY + 2 * pi,
                      min: 0,
                      max: 4 * pi,
                      onChanged: (value) {
                        _controller.angleY = value - 2 * pi;
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
