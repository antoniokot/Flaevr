import 'package:flutter/material.dart';

class SliverScaffold extends StatefulWidget {
  final ScrollController controller;
  final ScrollPhysics physics;
  final List<Widget> slivers;
  final double initialScrollOffset;
  final double borderRadius;

  final double expandedHeight;

  /// Changes edge behavior to account for [SliverAppBar.pinned].
  ///
  /// Hides the edge when the [ScrollController.offset] reaches the collapsed
  /// height of the [SliverAppBar] to prevent it from overlapping the app bar.
  final bool hasPinnedAppBar;

  SliverScaffold(
      {@required this.expandedHeight,
      this.controller,
      this.physics,
      this.slivers,
      this.hasPinnedAppBar,
      this.initialScrollOffset,
      this.borderRadius}) {
    assert(expandedHeight != null);
    assert(hasPinnedAppBar != null);
    assert(initialScrollOffset != null);
    assert(borderRadius != null);
  }

  @override
  _SliverScaffoldState createState() => _SliverScaffoldState();
}

class _SliverScaffoldState extends State<SliverScaffold> {
  ScrollController ctrl;

  @override
  void initState() {
    super.initState();

    ctrl = widget.controller ??
        ScrollController(initialScrollOffset: this.widget.initialScrollOffset);
    ctrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      ctrl.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        CustomScrollView(
          controller: ctrl,
          physics: widget.physics,
          slivers: widget.slivers,
        ),
        _buildEdge(),
      ],
    );
  }

  _buildEdge() {
    var borderRadius = widget.borderRadius;
    var edgeHeight = borderRadius;
    var paddingTop = MediaQuery.of(context).padding.top;

    var defaultOffset = (paddingTop + widget.expandedHeight) - edgeHeight;

    var top = defaultOffset;
    var edgeSize = edgeHeight;

    if (ctrl.hasClients) {
      double offset = ctrl.offset;
      top -= offset > 0 ? offset : 0;
      if (widget.hasPinnedAppBar) {
        // Hide edge to prevent overlapping the toolbar during scroll.
        var breakpoint = widget.expandedHeight - kToolbarHeight - edgeHeight;

        if (offset >= breakpoint) {
          edgeSize = edgeHeight - (offset - breakpoint);
          if (edgeSize < 0) {
            edgeSize = 0;
          }

          top += (edgeHeight - edgeSize);
        }
      }
    }

    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Container(
        height: edgeSize,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
