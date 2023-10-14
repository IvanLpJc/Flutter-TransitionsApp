import 'package:flutter/material.dart';

enum TransitionType { sliding, scaling, rotating, fading, mixed }

navigationPushAnimated(BuildContext context,
    {TransitionType transitionType = TransitionType.sliding,
    required Widget nextPage,
    Offset beginOffset = const Offset(0.5, 1.0),
    Offset endOffset = Offset.zero,
    double beginDouble = 0.0,
    double endDouble = 1.0,
    // TransitionType? firstTransition,
    // TransitionType? secondTransition,
    Curve curve = Curves.linear}) {
  Route route;

  switch (transitionType) {
    case TransitionType.sliding:
      route = _createSlidingTransitionRoute(
          nextPage, beginOffset, endOffset, curve);
      break;
    case TransitionType.scaling:
      route =
          _createScaleTransitionRoute(nextPage, beginDouble, endDouble, curve);
      break;
    case TransitionType.rotating:
      route = _createRotationTransitionRoute(
          nextPage, beginDouble, endDouble, curve);
      break;
    case TransitionType.fading:
      route =
          _createFadeTransitionRoute(nextPage, beginDouble, endDouble, curve);
      break;
    // case TransitionType.mixed:
    //   route =
    //       _createMixedTransitionRoute(nextPage, beginDouble, endDouble, curve);
    //   break;

    default:
      route = _createSlidingTransitionRoute(
          nextPage, beginOffset, endOffset, curve);
  }

  Navigator.push(context, route);
}

Route _createSlidingTransitionRoute(
    Widget nextPage, Offset begin, Offset end, Curve animationCurve) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    // transitionDuration: Duration(seconds: 2),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: animationCurve);

      return SlideTransition(
        position:
            Tween<Offset>(begin: begin, end: end).animate(curvedAnimation),
        child: child,
      );
    },
  );
}

Route _createScaleTransitionRoute(
    Widget nextPage, double begin, double end, Curve animationCurve) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    // transitionDuration: Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: animationCurve);

      return ScaleTransition(
        scale: Tween<double>(begin: begin, end: end).animate(curvedAnimation),
        child: nextPage,
      );
    },
  );
}

Route _createRotationTransitionRoute(
    Widget nextPage, double begin, double end, Curve animationCurve) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    // transitionDuration: Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: animationCurve);

      return RotationTransition(
        turns: Tween<double>(begin: begin, end: end).animate(curvedAnimation),
        child: nextPage,
      );
    },
  );
}

Route _createFadeTransitionRoute(
    Widget nextPage, double begin, double end, Curve animationCurve) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    // transitionDuration: Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: animationCurve);

      return FadeTransition(
        opacity: Tween<double>(begin: begin, end: end).animate(curvedAnimation),
        child: nextPage,
      );
    },
  );
}

// ignore: unused_element
Route _createMixedTransitionRoute(
    Widget nextPage,
    double begin,
    double end,
    Curve animationCurve,
    TransitionType firstTransition,
    TransitionType secondTransition) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => nextPage,
    // transitionDuration: Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation =
          CurvedAnimation(parent: animation, curve: animationCurve);

      return RotationTransition(
        turns: Tween<double>(begin: begin, end: end).animate(curvedAnimation),
        child: FadeTransition(
          opacity:
              Tween<double>(begin: begin, end: end).animate(curvedAnimation),
          child: nextPage,
        ),
      );
    },
  );
}
