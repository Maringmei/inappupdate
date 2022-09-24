import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class InAppUpdates extends StatefulWidget {
  const InAppUpdates({Key? key}) : super(key: key);
  @override
  State<InAppUpdates> createState() => _InAppUpdatesState();
}

class _InAppUpdatesState extends State<InAppUpdates> {
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
        if (_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable) {
          showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Update available'),
                content:
                    const Text('Update the app to continue using this app'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Update'),
                    onPressed: () {
                      InAppUpdate.performImmediateUpdate()
                          .catchError((e) => showSnack(e.toString()));
                    },
                  ),
                ],
              );
            },
          );
        }
      });
    }).catchError((e) {
      print(e.toString());
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
    print("DDDDDDDDDDDDDdd");
    // widget.someOtherObject.addListener(update);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_updateInfo?.updateAvailability ==
                    UpdateAvailability.updateAvailable
                ? "Update Available"
                : "The App is UP TO DATE")
            // ElevatedButton(
            //   child: Text('Perform immediate update'),
            //   onPressed: _updateInfo?.updateAvailability ==
            //           UpdateAvailability.updateAvailable
            //       ? () {
            //           InAppUpdate.performImmediateUpdate()
            //               .catchError((e) => showSnack(e.toString()));
            //         }
            //       : null,
            // ),
            // ElevatedButton(
            //   child: Text('Start flexible update'),
            //   onPressed: _updateInfo?.updateAvailability ==
            //           UpdateAvailability.updateAvailable
            //       ? () {
            //           InAppUpdate.startFlexibleUpdate().then((_) {
            //             setState(() {
            //               _flexibleUpdateAvailable = true;
            //             });
            //           }).catchError((e) {
            //             showSnack(e.toString());
            //           });
            //         }
            //       : null,
            // ),
            // ElevatedButton(
            //   child: Text('Complete flexible update'),
            //   onPressed: !_flexibleUpdateAvailable
            //       ? null
            //       : () {
            //           InAppUpdate.completeFlexibleUpdate().then((_) {
            //             showSnack("Success!");
            //           }).catchError((e) {
            //             showSnack(e.toString());
            //           });
            //         },
            // )
          ],
        ),
      ),
    );
  }
}
