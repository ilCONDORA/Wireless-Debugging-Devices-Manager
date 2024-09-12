/// Model for the device.
class DeviceModel {
  final String ipAddress;
  final int port;
  final String customName;
  final String serialNumber;
  final String model;
  final String manufacturer;
  final String androidVersion;
  final bool isConnected;

  /// Constructor for creating a Device instance.
  DeviceModel({
    required this.ipAddress,
    required this.port,
    required this.customName,
    required this.serialNumber,
    required this.model,
    required this.manufacturer,
    required this.androidVersion,
    required this.isConnected,
  });

  /// Create a Device instance from a JSON map.
  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      ipAddress: json['ipAddress'] as String,
      port: json['port'] as int,
      customName: json['customName'] as String,
      serialNumber: json['serialNumber'] as String,
      model: json['model'] as String,
      manufacturer: json['manufacturer'] as String,
      androidVersion: json['androidVersion'] as String,
      isConnected: json['isConnected'] as bool,
    );
  }

  /// Converts a Device instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'ipAddress': ipAddress,
      'port': port,
      'customName': customName,
      'serialNumber': serialNumber,
      'model': model,
      'manufacturer': manufacturer,
      'androidVersion': androidVersion,
      'isConnected': isConnected,
    };
  }

  /// Creates a copy of the current DeviceModel with the option to modify specific properties.
  /// If a property is not provided, the current value is retained.
  /// This method is used to create a new instance of DeviceModel with modified properties.
  DeviceModel copyWith({
    String? ipAddress,
    int? port,
    String? customName,
  }) {
    return DeviceModel(
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      customName: customName ?? this.customName,
      serialNumber: serialNumber,
      model: model,
      manufacturer: manufacturer,
      androidVersion: androidVersion,
      isConnected: isConnected,
    );
  }
}
