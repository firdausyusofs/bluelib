class DeviceInfo {
  String deviceName;
  String address;
  int rssi;
  double distance;
  String updatedAt;

  DeviceInfo({
    this.deviceName = "",
    this.address = "",
    this.rssi = 0,
    this.distance = 0.0,
    this.updatedAt = "",
  });

  factory DeviceInfo.fromMap(Map<dynamic, dynamic> map) {
    return DeviceInfo(
      deviceName: map['name'],
      address: map['address'],
      rssi: map['rssi'],
      distance: map['distance'],
      updatedAt: map['updated_at'],
    );
  }
}
