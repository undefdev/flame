import 'package:flame/anchor.dart';
import 'package:flame/extensions/offset.dart';
import 'package:flame/extensions/vector2.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/components/position_component.dart';
import 'package:flame/components/mixins/dragable.dart';

void main() {
  final widget = Container(
    padding: const EdgeInsets.all(0),
    color: const Color(0xFFA9A9A9),
    child: GameWidget(
      game: MyGame(),
    ),
  );

  runApp(widget);
}

class DragableSquare extends PositionComponent with Dragable {
  @override
  bool debugMode = true;
  bool _isDragging = false;

  DragableSquare({Vector2 position}) {
    size = Vector2.all(100);
    this.position = position ?? Vector2.all(100);
  }

  @override
  void update(double dt) {
    super.update(dt);
    debugColor = _isDragging ? Colors.greenAccent : Colors.purple;
  }

  Vector2 dragDeltaPosition;
  @override
  bool onReceiveDrag(DragEvent event) {
    event.onUpdate = (DragUpdateDetails details) {
      if (!_isDragging) {
        _isDragging = true;
        dragDeltaPosition =
            event.initialPosition.toVector2() - position.clone();
      }
      position = details.localPosition.toVector2() - dragDeltaPosition;
    };
    event.onEnd = (DragEndDetails details) {
      _isDragging = false;
    };
    return true;
  }
}

class MyGame extends BaseGame with HasDragableComponents {
  MyGame() {
    add(DragableSquare()..anchor = Anchor.topLeft);
    add(DragableSquare()..y = 350);
  }
}
