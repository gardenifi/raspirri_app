// ignore_for_file: hash_and_equals

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
    return '{$id, $ssid, $password}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WifiNetwork &&
      other.id == id &&
      other.ssid == ssid &&
      other.password == password;
  }

  // @override
  // int get hashCode => id.hashCode ^ ssid.hashCode ^ password.hashCode;
}
