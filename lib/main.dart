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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final mesh = const Mesh(
    [
      /// South
      Polygon([
        Vector3D(0, 0, 0),
        Vector3D(0, 1, 0),
        Vector3D(1, 1, 0),
      ]),
      Polygon([
        Vector3D(0, 0, 0),
        Vector3D(1, 1, 0),
        Vector3D(1, 0, 0),
      ]),

      /// East
      Polygon([
        Vector3D(1, 0, 0),
        Vector3D(1, 1, 0),
        Vector3D(1, 1, 1),
      ]),
      Polygon([
        Vector3D(1, 0, 0),
        Vector3D(1, 1, 1),
        Vector3D(1, 0, 1),
      ]),

      /// North
      Polygon([
        Vector3D(1, 0, 1),
        Vector3D(1, 1, 1),
        Vector3D(0, 1, 1),
      ]),
      Polygon([
        Vector3D(1, 0, 1),
        Vector3D(0, 1, 1),
        Vector3D(0, 0, 1),
      ]),

      /// West
      Polygon([
        Vector3D(0, 0, 1),
        Vector3D(0, 1, 1),
        Vector3D(0, 1, 0),
      ]),
      Polygon([
        Vector3D(0, 0, 1),
        Vector3D(0, 1, 0),
        Vector3D(0, 0, 0),
      ]),

      /// Top
      Polygon([
        Vector3D(0, 1, 0),
        Vector3D(0, 1, 1),
        Vector3D(1, 1, 1),
      ]),
      Polygon([
        Vector3D(0, 1, 0),
        Vector3D(1, 1, 1),
        Vector3D(1, 1, 0),
      ]),

      /// Bottom
      Polygon([
        Vector3D(1, 0, 1),
        Vector3D(0, 0, 1),
        Vector3D(0, 0, 0),
      ]),
      Polygon([
        Vector3D(1, 0, 1),
        Vector3D(0, 0, 0),
        Vector3D(1, 0, 0),
      ]),
    ],
  );

  final _controller = ObjectViewController();

  @override
  void initState() {
    final animationC = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 10,
      duration: const Duration(seconds: 10),
    );

    _controller.mesh = mesh;

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
          child: ModelWidget(
            controller: _controller,
          ),
        ),
      ),
    );
  }
}
