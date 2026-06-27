import 'package:flutter/material.dart';
import '../../domain/models/graph_data.dart';
import 'graph_chart_painter.dart';

/// A draggable, interactive graph card rendered on the canvas.
///
/// Renders a native 2D chart with isolated gesture handling
/// for internal pan/zoom and tap-to-inspect value readout.
class GraphCardWidget extends StatefulWidget {
  /// The graph data to render.
  final GraphData graphData;

  /// Called when the user pans/zooms within the graph and the x-range changes.
  final ValueChanged<({double xMin, double xMax})>? onRangeChanged;

  /// Called when the user requests a re-fetch with the new range.
  final void Function(String expressionId, double xMin, double xMax)?
      onRefreshRequested;

  /// Creates a [GraphCardWidget].
  const GraphCardWidget({
    super.key,
    required this.graphData,
    this.onRangeChanged,
    this.onRefreshRequested,
  });

  @override
  State<GraphCardWidget> createState() => _GraphCardWidgetState();
}

class _GraphCardWidgetState extends State<GraphCardWidget> {
  /// Current inspected point (local coordinates within chart).
  Offset? _inspectedPoint;

  /// Tracks the initial focal point for pan gestures.
  double? _panStartXMin;
  double? _panStartXMax;

  /// Current x-range (can deviate from widget data during interaction).
  late double _currentXMin;
  late double _currentXMax;

  /// Tracks the scale start for pinch-zoom.
  double? _scaleStartXMin;
  double? _scaleStartXMax;

  @override
  void initState() {
    super.initState();
    _currentXMin = widget.graphData.xRangeMin;
    _currentXMax = widget.graphData.xRangeMax;
  }

  @override
  void didUpdateWidget(GraphCardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.graphData.expressionId != widget.graphData.expressionId) {
      _currentXMin = widget.graphData.xRangeMin;
      _currentXMax = widget.graphData.xRangeMax;
      _inspectedPoint = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 240,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _parseColor(widget.graphData.color).withValues(alpha: 0.4),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: _parseColor(widget.graphData.color).withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          // Absorb gestures so canvas doesn't pan
          onTapDown: _handleTapDown,
          onTapUp: (_) {},
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          onScaleEnd: _handleScaleEnd,
          behavior: HitTestBehavior.opaque,
          child: CustomPaint(
            painter: GraphChartPainter(
              graphData: widget.graphData.copyWith(
                xRangeMin: _currentXMin,
                xRangeMax: _currentXMax,
              ),
              inspectedPoint: _inspectedPoint,
            ),
            size: const Size(320, 240),
          ),
        ),
      ),
    );
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _inspectedPoint = details.localPosition;
    });
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _panStartXMin = _currentXMin;
    _panStartXMax = _currentXMax;
    _scaleStartXMin = _currentXMin;
    _scaleStartXMax = _currentXMax;

    // Clear inspection on interaction start
    setState(() {
      _inspectedPoint = null;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_panStartXMin == null || _panStartXMax == null) return;

    final range = _panStartXMax! - _panStartXMin!;

    if (details.scale != 1.0 && _scaleStartXMin != null) {
      // Pinch zoom: scale the range around the center
      final scaleRange = (_scaleStartXMax! - _scaleStartXMin!) / details.scale;
      final center = (_scaleStartXMin! + _scaleStartXMax!) / 2;
      setState(() {
        _currentXMin = center - scaleRange / 2;
        _currentXMax = center + scaleRange / 2;
      });
    } else {
      // Pan: translate the range
      // Map pixel delta to data delta
      const chartWidth = 320.0 - 48.0 - 16.0; // marginLeft + marginRight
      final dataDeltaPerPixel = range / chartWidth;
      final dx = details.focalPointDelta.dx * dataDeltaPerPixel;

      setState(() {
        _currentXMin -= dx;
        _currentXMax -= dx;
      });
    }

    widget.onRangeChanged?.call((xMin: _currentXMin, xMax: _currentXMax));
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    // Request refresh with new range if it changed significantly
    if (_panStartXMin != null && _panStartXMax != null) {
      final dMin = (_currentXMin - _panStartXMin!).abs();
      final dMax = (_currentXMax - _panStartXMax!).abs();
      final range = _panStartXMax! - _panStartXMin!;

      if ((dMin + dMax) / range > 0.05) {
        widget.onRefreshRequested?.call(
          widget.graphData.expressionId,
          _currentXMin,
          _currentXMax,
        );
      }
    }

    _panStartXMin = null;
    _panStartXMax = null;
    _scaleStartXMin = null;
    _scaleStartXMax = null;
  }

  Color _parseColor(String hex) {
    try {
      final buffer = StringBuffer();
      if (hex.startsWith('#')) {
        buffer.write('FF');
        buffer.write(hex.substring(1));
      } else {
        buffer.write('FF');
        buffer.write(hex);
      }
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }
}
