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
}
