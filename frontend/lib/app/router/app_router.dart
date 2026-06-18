import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mathcanvas/features/notebook/presentation/screens/home_screen.dart';
import 'package:mathcanvas/features/canvas/presentation/screens/canvas_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/notebook/:id',
        name: 'canvas',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CanvasScreen(notebookId: id);
        },
      ),
    ],
  );
});
