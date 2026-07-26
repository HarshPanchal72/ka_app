import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../Classes/common_class.dart';

class InternetService {
  InternetService._();

  static final InternetService instance = InternetService._();

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  void initialize(BuildContext context) {
    _subscription?.cancel();

    _subscription = Connectivity().onConnectivityChanged.listen((_) async {
      bool hasInternet = await InternetConnection().hasInternetAccess;

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (!hasInternet) {
        CommonClass.showSnackBar(context, message: "No Internet Connection",
            backgroundColor: Colors.red, textColor: Colors.white);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("No Internet Connection"),
        //     backgroundColor: Colors.red,
        //     behavior: SnackBarBehavior.floating,
        //   ),
        // );
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}