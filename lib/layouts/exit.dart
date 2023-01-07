import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../components/backdrop.dart';
import '../controllers/blocs.dart';
import '../controllers/theme.dart';
import '../styles/colours.dart';

class Exit extends StatelessWidget {
  const Exit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    var exit = Provider.of<ExitModal>(context);
    var themes = Provider.of<AppThemes>(context);
    var theme = themes.appTheme;
    var textStyle = themes.textStyling;

    return BlocBuilder<ExitModal, bool>(
        builder: (BuildContext context, bool state) {
      return Stack(
        children: [
          state
              ? GestureDetector(
                  onTap: () {
                    exit.add(Bool.deactivate);
                  },
                  child: const BackDrop(),
                )
              : Container(),
          AnimatedPositioned(
            top: state ? 0 : screenHeight,
            bottom: state ? 0 : -screenHeight,
            left: 0,
            right: 0,
            duration: const Duration(milliseconds: 1400),
            curve: Curves.elasticOut,
            child: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Center(
                child: Container(
                  width: 320,
                  height: 200,
                  decoration: themes.pops,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 155,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "ARE YOU SURE?",
                              style: textStyle.bold25!.copyWith(color: red),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Are you certain that you want to close this app?",
                                style: textStyle.regular18,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              exit.add(Bool.deactivate);
                            },
                            child: SizedBox(
                              width: 160,
                              height: 40,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: theme.primary,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            },
                            child: SizedBox(
                              width: 160,
                              height: 40,
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: red,
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      );
    });
  }
}
