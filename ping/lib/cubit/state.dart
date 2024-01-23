part of 'cubit.dart';

class HomeState {
  const HomeState({
    this.isConnected = false,
    this.isLoading = false,
    this.pinging = false,
    this.pingFailed = false,
    this.pingedJID,
  });

  final bool isConnected;
  final bool isLoading;
  final bool pinging;
  final bool pingFailed;
  final String? pingedJID;

  HomeState copyWith({
    bool? isConnected,
    bool? isLoading,
    bool? pinging,
    bool? pingFailed,
    String? pingedJID,
  }) =>
      HomeState(
        isLoading: isLoading ?? this.isLoading,
        isConnected: isConnected ?? this.isConnected,
        pinging: pinging ?? this.pinging,
        pingedJID: pingedJID ?? this.pingedJID,
        pingFailed: pingFailed ?? this.pingFailed,
      );

  @override
  bool operator ==(Object other) =>
      other is HomeState &&
      isLoading == other.isLoading &&
      isConnected == other.isConnected &&
      pinging == other.pinging &&
      pingFailed == other.pingFailed &&
      pingedJID == other.pingedJID;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      isConnected.hashCode ^
      pinging.hashCode ^
      pingFailed.hashCode ^
      pingedJID.hashCode;
}
