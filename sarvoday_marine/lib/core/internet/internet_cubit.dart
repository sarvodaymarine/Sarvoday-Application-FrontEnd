import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarvoday_marine/core/internet/internet_state.dart';
import 'internet_enum.dart';

class InternetCubit extends Cubit<InternetState> {
  final Connectivity? connectivity;
  ConnectivityResult? connectivityResults;
  StreamSubscription? connectivityStreamSubscription;

  InternetCubit({required this.connectivity}) : super(InternetLoading()) {
    monitorCheckConnection();
    monitorInternetConnection();
  }

  void monitorInternetConnection() async {
    connectivityStreamSubscription =
        connectivity!.onConnectivityChanged.listen((connectivityResult) async {
      try {
        if (connectivityResult.isEmpty &&
            connectivityResult.first == ConnectivityResult.wifi) {
          emitInternetConnected(ConnectionType.WiFi);
        } else if (connectivityResult.isEmpty &&
            connectivityResult.first == ConnectivityResult.mobile) {
          emitInternetConnected(ConnectionType.Mobile);
        } else if (connectivityResult.isEmpty &&
            connectivityResult.first == ConnectivityResult.none) {
          emitInternetDisconnected();
        }
      } on SocketException catch (_) {
        emitInternetDisconnected();
      }
    });
  }

  void monitorCheckConnection() async {
    connectivityResults = (await connectivity!.checkConnectivity())[0];
    try {
      if (connectivityResults == ConnectivityResult.wifi) {
        emitInternetConnected(ConnectionType.WiFi);
      } else if (connectivityResults == ConnectivityResult.mobile) {
        emitInternetConnected(ConnectionType.Mobile);
      } else if (connectivityResults == ConnectivityResult.none) {
        emitInternetDisconnected();
      }
    } on SocketException catch (_) {
      emitInternetDisconnected();
    }
  }

  void emitInternetConnected(ConnectionType connectionType) =>
      emit(InternetConnected(connectionType: connectionType));

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() async {
    connectivityStreamSubscription!.cancel();
    return super.close();
  }
}
