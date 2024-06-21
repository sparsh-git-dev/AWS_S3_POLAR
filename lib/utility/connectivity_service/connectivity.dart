import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _subscription;

  // void startMonitoring() {
  //   _subscription = _connectivity.onConnectivityChanged.listen((result) async {
  //     if (result != ConnectivityResult.none) {
  //       await _syncData();
  //     }
  //   });
  // }

  // Future<void> _syncData() async {
  //   final localData = await LocalDatabase.instance.fetchFormData();
  //   if (localData.isNotEmpty) {
  //     final response = await http.post(
  //       Uri.parse('https://chatbot-api.grampower.com/flutter-assignment/push'),
  //       body: json.encode({'data': localData}),
  //       headers: {'Content-Type': 'application/json'},
  //     );
  //     if (response.statusCode == 200) {
  //       // Clear local data after successful sync
  //     }
  //   }
  // }

  // void dispose() {
  //   _subscription?.cancel();
  // }
}

class InternetConnectivity {
  static Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi));
  }
}
