import 'package:flutter/cupertino.dart';

class Empty extends LeafRenderObjectWidget {
  const Empty({Key? key}) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return EmptyRender();
  }
}

class EmptyRender extends RenderBox {
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.biggest;
  }

  @override
  void performLayout() {
    size = getDryLayout(constraints);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    return;
  }
}
