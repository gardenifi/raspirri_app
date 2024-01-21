class WifiNetwork {
  final int id;
  final String ssid;
  final String? password;

  WifiNetwork(
    this.id,
    this.ssid,
    this.password,
  );

  WifiNetwork.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        ssid = json['ssid'],
        password = json['password'] ?? '';

  Map<String, dynamic> toJson() => {
        'id': id,
        'ssid': ssid,
        'password': password ?? '',
      };
  @override
  String toString() {
    return '{$id, $ssid, $password?? ""}';
  }
}
