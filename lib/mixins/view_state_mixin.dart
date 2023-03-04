import 'package:flutter/material.dart';

enum ViewStates { busy, idle, error, noRecords }

mixin ViewStateMixin<T extends StatefulWidget> on State<T> {
  ViewStates viewState = ViewStates.busy;

  void setViewState(ViewStates viewState) {
    if (mounted) {
      setState(() {
        this.viewState = viewState;
      });
    }
  }

  void setBusy() {
    setViewState(ViewStates.busy);
  }

  void setIdle() {
    setViewState(ViewStates.idle);
  }

  void setError() {
    setViewState(ViewStates.error);
  }

  bool get isBusy => viewState == ViewStates.busy;
  bool get isIdle => viewState == ViewStates.idle;
  bool get isError => viewState == ViewStates.error;
  bool get isNoRecords => viewState == ViewStates.noRecords;
}
