import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mathcanvas/features/canvas/domain/models/canvas_transform.dart';
import 'package:vector_math/vector_math_64.dart';

void main() {
  group('CanvasTransform Unit Tests', () {
    test('Identity transform (zoom = 1.0, offset = zero)', () {
      const transform = CanvasTransform(
        offset: Offset.zero,
        zoom: 1.0,
      );

      const worldPoint = Offset(100, 200);
      final screenPoint = transform.worldToScreen(worldPoint);
      expect(screenPoint, const Offset(100, 200));

      final backToWorld = transform.screenToWorld(screenPoint);
      expect(backToWorld, worldPoint);
    });

    test('Scaling only (zoom = 2.0, offset = zero)', () {
      const transform = CanvasTransform(
        offset: Offset.zero,
        zoom: 2.0,
      );

      const worldPoint = Offset(100, 200);
      final screenPoint = transform.worldToScreen(worldPoint);
      expect(screenPoint, const Offset(200, 400));

      final backToWorld = transform.screenToWorld(screenPoint);
      expect(backToWorld, worldPoint);
    });

    test('Translation only (zoom = 1.0, offset = (50, 100))', () {
      const transform = CanvasTransform(
        offset: Offset(50, 100),
        zoom: 1.0,
      );

      const worldPoint = Offset(10, 20);
      final screenPoint = transform.worldToScreen(worldPoint);
      // (10 + 50) * 1 = 60, (20 + 100) * 1 = 120
      expect(screenPoint, const Offset(60, 120));

      final backToWorld = transform.screenToWorld(screenPoint);
      expect(backToWorld, worldPoint);
    });

    test('Combined scaling and translation (zoom = 2.0, offset = (50, 100))', () {
      const transform = CanvasTransform(
        offset: Offset(50, 100),
        zoom: 2.0,
      );

      const worldPoint = Offset(10, 20);
      final screenPoint = transform.worldToScreen(worldPoint);
      // (10 + 50) * 2 = 120, (20 + 100) * 2 = 240
      expect(screenPoint, const Offset(120, 240));

      final backToWorld = transform.screenToWorld(screenPoint);
      expect(backToWorld, worldPoint);
    });

    test('visibleWorldRect calculation', () {
      const transform = CanvasTransform(
        offset: Offset(50, 100),
        zoom: 2.0,
      );

      // Screen size: 800 x 600
      // topLeft world coordinate: screenToWorld(0, 0) = Offset(0/2 - 50, 0/2 - 100) = Offset(-50, -100)
      // bottomRight world coordinate: screenToWorld(800, 600) = Offset(800/2 - 50, 600/2 - 100) = Offset(350, 200)
      final rect = transform.visibleWorldRect(const Size(800, 600));
      expect(rect.left, -50.0);
      expect(rect.top, -100.0);
      expect(rect.right, 350.0);
      expect(rect.bottom, 200.0);

      // With margin of 10.0 world units
      final rectWithMargin = transform.visibleWorldRect(
        const Size(800, 600),
        margin: 10.0,
      );
      expect(rectWithMargin.left, -60.0);
      expect(rectWithMargin.top, -110.0);
      expect(rectWithMargin.right, 360.0);
      expect(rectWithMargin.bottom, 210.0);
    });

    test('transformMatrix validation', () {
      const transform = CanvasTransform(
        offset: Offset(50, 100),
        zoom: 2.0,
      );

      final expectedMatrix = Matrix4.identity()
        ..scaleByVector3(Vector3(2.0, 2.0, 1.0))
        ..translateByVector3(Vector3(50.0, 100.0, 0.0));

      expect(transform.transformMatrix, expectedMatrix);
    });
  });
}
