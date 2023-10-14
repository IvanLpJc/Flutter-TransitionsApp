import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:transitions_app/helpers/helpers.dart';
import 'package:transitions_app/ui/pages/second_page.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({Key? key}) : super(key: key);

  List<ActionButton> _getActionButtons(BuildContext context) {
    return [
      ActionButton(
        // icon: const Icon(Icons.sledding),
        text: 'Slide',
        onPressed: () => navigationPushAnimated(
          context,
          transitionType: TransitionType.sliding,
          nextPage: const SecondPage(),
        ),
      ),
      ActionButton(
        // icon: const Icon(Icons.published_with_changes_outlined),
        text: 'Rotate',
        onPressed: () => navigationPushAnimated(
          context,
          transitionType: TransitionType.rotating,
          nextPage: const SecondPage(),
        ),
      ),
      ActionButton(
        // icon: const Icon(Icons.add_ic_call_outlined),
        text: 'Fade',
        onPressed: () => navigationPushAnimated(
          context,
          transitionType: TransitionType.fading,
          nextPage: const SecondPage(),
        ),
      ),
      ActionButton(
        // icon: const Icon(Icons.scale),
        text: 'Scale',
        onPressed: () => navigationPushAnimated(
          context,
          transitionType: TransitionType.scaling,
          nextPage: const SecondPage(),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Page"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('First Page'),
      ),
      // ),
      floatingActionButton: ExpandableFab(
          initialOpen: false,
          distance: 112,
          children: [..._getActionButtons(context)]),
    );
  }
}

class ExpandableFab extends StatefulWidget {
  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
        value: _open ? 1.0 : 0.0);
    _expandAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.easeOutQuad);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);

    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
            directionInDegrees: angleInDegrees,
            maxDistance: widget.distance,
            progress: _expandAnimation,
            child: widget.children[i]),
      );
    }
    return children;
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
            // shape: const CircleBorder(),
            shape: const RoundedRectangleBorder(),
            clipBehavior: Clip.antiAlias,
            elevation: 4,
            child: InkWell(
              onTap: _toggle,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                // child: Icon(
                //   Icons.close,
                //   color: Theme.of(context).primaryColor,
                // ),
                child: Text("Close"),
              ),
            )),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform:
            Matrix4.diagonal3Values(_open ? 0.7 : 1.0, _open ? 0.7 : 1.0, 1.0),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 250),
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          child: FloatingActionButton.extended(
            onPressed: _toggle,
            label: const Text("Transitions"),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final String? text;

  const ActionButton({super.key, this.onPressed, this.icon, this.text})
      : assert(icon == null || text == null, "Insert either icon or text");

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: text != null
          ? ElevatedButton(onPressed: onPressed, child: Text(text!))
          : icon != null
              ? IconButton(
                  onPressed: onPressed,
                  icon: icon!,
                  color: theme.colorScheme.onSecondary,
                )
              : Container(),
    );
  }
}

class _ExpandingActionButton extends StatelessWidget {
  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  const _ExpandingActionButton(
      {required this.directionInDegrees,
      required this.maxDistance,
      required this.progress,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
            directionInDegrees * (math.pi / 180.0),
            progress.value * maxDistance);

        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
