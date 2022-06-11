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

  @override
  void initState() {
    final animationC = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 10,
      duration: const Duration(seconds: 10),
    );

    animationC.addListener(() {
      _controller.angleX = animationC.value;
      _controller.angleZ = animationC.value;
    });

    animationC.repeat();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          height: 400,
          child: ObjectWidget(
            source: ObjectSource.fromAssets("assets/cube.obj"),
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
