import 'package:flutter/cupertino.dart';

// in core/utils/custom_page_route.dart

enum PageTransitionType {
  fade,
  scale,
  slideRight,
  slideLeft,
  slideUp,
  slideDown,
  fadeAndScale,
  // Add more transition types as needed
}

class CustomPageRoute extends PageRouteBuilder {
  final Widget child;
  final PageTransitionType type;
  final Duration duration;
  final Curve curve;

  CustomPageRoute({
    required this.child,
    this.type = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            switch (type) {
              case PageTransitionType.fade:
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );

              case PageTransitionType.scale:
                return ScaleTransition(
                  scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(parent: animation, curve: curve)),
                  child: child,
                );

              case PageTransitionType.slideRight:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: curve)),
                  child: child,
                );

              case PageTransitionType.slideLeft:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: curve)),
                  child: child,
                );

              case PageTransitionType.slideUp:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: curve)),
                  child: child,
                );

              case PageTransitionType.slideDown:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: curve)),
                  child: child,
                );

              case PageTransitionType.fadeAndScale:
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                        CurvedAnimation(parent: animation, curve: curve)),
                    child: child,
                  ),
                );
            }
          },
        );
}
