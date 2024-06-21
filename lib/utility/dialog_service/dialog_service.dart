import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global/widget/loader.dart';

class DialogService {
  Future<bool> confirmAlertDialogWithoutTitle(
      String title, String message, String cancel, String accept) async {
    bool action = false;
    await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            child: IntrinsicWidth(
              child: IntrinsicHeight(
                child: Column(
                  children: <Widget>[
                    title != ''
                        ? const SizedBox(
                            height: 20,
                          )
                        : const SizedBox(
                            height: 0,
                          ),
                    title != ''
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      message,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ButtonTheme(
                            minWidth: 100.0,
                            height: 35.0,
                            child: MaterialButton(
                                highlightColor: Colors.transparent,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.grey, width: 1),
                                    borderRadius: BorderRadius.circular(4)),
                                color: Colors.white,
                                onPressed: () {
                                  action = false;
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    cancel,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        ButtonTheme(
                            minWidth: 100.0,
                            height: 35.0,
                            child: MaterialButton(
                                highlightColor: Colors.blue,
                                elevation: 1,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                color: Colors.blue,
                                onPressed: () {
                                  action = true;
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    accept,
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return action;
  }

  Future<void> showLoader() async {
    return showDialog<void>(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => false,
              child: const Center(
                child: Loader(),
              ));
        });
  }

  void closeLoader() => Navigator.of(Get.context!).pop();
}
