import 'package:flutter/material.dart';

final Animatable<Offset> slideInTransition = Tween<Offset>(
  begin: Offset(-30.0, 0.0),
  end: Offset.zero,
).chain(CurveTween(curve: Easing.legacy));
final Animatable<Offset> slideInTransition2 = Tween<Offset>(
  begin: Offset(30.0, 0.0),
  end: Offset.zero,
).chain(CurveTween(curve: Easing.legacy));

final Animatable<double> fadeInTransition = CurveTween(
  curve: Easing.legacyDecelerate,
).chain(CurveTween(curve: const Interval(0.3, 1.0)));
