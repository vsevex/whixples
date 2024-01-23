import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ping/whixp_service.dart';

part 'state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  WhixpService? _service;

  HomeCubit initialize({required String jabberID, required String password}) {
    _service = WhixpService()..initialize(jabberID, password);
    return this;
  }

  void _onConnect() =>
      emit(state.copyWith(isConnected: true, isLoading: false));

  void connect() {
    emit(state.copyWith(isLoading: true));

    if (_service != null) {
      _service!.whixp.addEventHandler('sessionStart', (_) => _onConnect());
      _service!.whixp.addEventHandler<String>(
        'disconnected',
        (condition) => emit(state.copyWith(isLoading: false)),
      );
      _service!.whixp.addEventHandler<String>(
        'failedAuthentication',
        (condition) => emit(state.copyWith(isLoading: false)),
      );
      _service!.whixp.addEventHandler<Object>(
        'connectionFailed',
        (data) => emit(state.copyWith(isLoading: false)),
      );
      _service!.connect();
    }
  }

  void sendPing(String jid) {
    emit(state.copyWith(pinging: true));

    void emitState({bool pinging = false, bool pingFailed = false}) {
      emit(
        state.copyWith(
          pingedJID: jid,
          pinging: pinging,
          pingFailed: pingFailed,
        ),
      );
    }

    _service!.sendPing(
      jid,
      callback: (iq) => emitState(),
      failureCallback: (_) => emitState(pingFailed: true),
      timeoutCallback: () => emitState(pingFailed: true),
    );
  }
}
