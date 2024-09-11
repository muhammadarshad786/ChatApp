import 'package:flutter/material.dart';

class CustomePageRoute extends PageRouteBuilder {
  final Widget child;

  CustomePageRoute({required this.child})
      : super(
          transitionDuration: Duration(seconds: 3),
          pageBuilder: (context, animation, secondaryAnimation) {
            return child;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
    
            const begin = 0.0;
            const end = 1.0;
            const curve = Curves.easeInOut;

            var tween = Tween<double>(begin: begin, end: end);
            var curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            var scaleAnimation = tween.animate(curvedAnimation);

            return ScaleTransition(
              scale: scaleAnimation,
              child: child,
            );
          },
        );
}
