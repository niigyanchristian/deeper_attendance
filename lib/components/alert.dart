import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/theme.dart';
import '../styles/colours.dart';
import '../styles/texts.dart';

class Errors extends StatelessWidget {
  final String? errorMessage;
  final bool? error;

  const Errors({Key? key, this.errorMessage, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppThemes themes = Provider.of<AppThemes>(context);
    TextStyling textStyle = themes.textStyling;

    return AnimatedPositioned(
      top: error! ? 45 : -120,
      right: 0,
      left: 0,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      child: Center(
        child: Container(
          width: 320,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                amber,
                red,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 1],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.25),
                offset: const Offset(0.0, 5.0),
                blurRadius: 15,
                spreadRadius: -3,
              ),
            ],
          ),
          child: Center(
            child: Text(
              errorMessage!,
              style: textStyle.bold15!.copyWith(
                shadows: [
                  Shadow(
                    color: black.withOpacity(0.15),
                    offset: const Offset(0.0, 0.5),
                    blurRadius: 5.0,
                  ),
                ],
                color: white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class Success extends StatelessWidget {
  final String? message;
  final bool? success;

  const Success({
    Key? key,
    this.message,
    this.success,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themes = Provider.of<AppThemes>(context);
    var textStyle = themes.textStyling;

    return AnimatedPositioned(
      top: success! ? 45 : -120,
      right: 0,
      left: 0,
      duration: const Duration(milliseconds: 1200),
      curve: Curves.elasticOut,
      child: Center(
        child: Container(
          width: 320,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                sleepColor,
                green,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.0, 1],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(0.25),
                offset: const Offset(0.0, 5.0),
                blurRadius: 15,
                spreadRadius: -3,
              ),
            ],
          ),
          child: Center(
            child: Text(
              message!,
              style: textStyle.boldWhite16!.copyWith(
                shadows: [
                  Shadow(
                    color: black.withOpacity(0.15),
                    offset: const Offset(0.0, 0.5),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
