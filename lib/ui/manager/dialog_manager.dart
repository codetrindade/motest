import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:moveme/core/base/dialog_service.dart';
import 'package:moveme/locator.dart';

class DialogManager extends StatefulWidget {
  final Widget child;

  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();
  Flushbar _flush;

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(String title, String message, String confirmText, bool fixed) {
    _flush = Flushbar(
      title: title.length != 0 ? title : null,
      message: message,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      animationDuration: Duration(milliseconds: 300),
      duration: fixed ? null : Duration(seconds: 5),
      onStatusChanged: (FlushbarStatus status) {
        //print(status);
      },
      mainButton: confirmText.length == 0
          ? null
          : FlatButton(
        onPressed: () {
          _dialogService.dialogComplete(true);
          _flush.dismiss(true);
        },
        child: Text(confirmText, style: TextStyle(color: Colors.blue)),
      ),
    )..show(context);
    //Modal.showMessage(context, title, message);
  }
}
