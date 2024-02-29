class MqttBroker {
  final String host;
  final int port;
  final String user;
  final String pass;

  MqttBroker(this.host, this.port, this.user, this.pass);

  MqttBroker.fromJson(json)
      : host = json['host'],
        port = json['port'],
        user = json['user'],
        pass = json['pass'];

  @override
  String toString() {
    return '{$host, $port, $user, $pass}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MqttBroker &&
      other.host == host &&
      other.port == port &&
      other.user == user &&
      other.pass == pass;
  }

  // @override
  // int get hashCode {
  //   return host.hashCode ^
  //     port.hashCode ^
  //     user.hashCode ^
  //     pass.hashCode;
  // }
}
