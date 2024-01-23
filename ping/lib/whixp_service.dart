import 'package:whixp/whixp.dart';

class WhixpService {
  WhixpService();

  late final Whixp whixp;
  late final Ping _ping;
  late final ServiceDiscovery _disco;

  void initialize(String jabberID, String password) {
    whixp = Whixp(
      jabberID,
      password,
      host: '192.168.0.128',
      logger: Log(
        enableWarning: true,
        enableError: true,
      ),
      maxReconnectionAttempt: 1,
      onBadCertificateCallback: (cert) => true,
    );

    _ping = Ping();
    _disco = ServiceDiscovery();
    whixp
      ..registerPlugin(_disco)
      ..registerPlugin(_ping);
  }

  void connect() => whixp.connect();

  void sendPing(
    String jid, {
    void Function(IQ iq)? callback,
    void Function(StanzaError error)? failureCallback,
    void Function()? timeoutCallback,
  }) {
    _ping.sendPing(
      JabberID(jid),
      callback: callback,
      failureCallback: failureCallback,
      timeoutCallback: timeoutCallback,
    );
  }
}
