import 'dart:async';

class DialogService {
  Function(String title, String message, String confirmText, bool fixed) _showDialogListener;
  Completer _dialogCompleter;

  /// Registers a callback function. Typically to show the dialog
  void registerDialogListener(Function showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  /// Calls the dialog listener and returns a Future that will wait for dialogComplete.
  Future showDialog(String title, String message, {String confirmText = 'OK', bool fixed = false}) {
    _dialogCompleter = Completer<bool>();
    _showDialogListener(title, message, confirmText, fixed);
    return _dialogCompleter.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  void dialogComplete(bool confirm) {
    _dialogCompleter.complete(confirm);
    _dialogCompleter = null;
  }
}