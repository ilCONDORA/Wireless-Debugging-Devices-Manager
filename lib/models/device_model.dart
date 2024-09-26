/// Model for the device.
class DeviceModel {
  final String completeIpAddress;
  final String customName;
  final String serialNumber;
  final String model;
  final String manufacturer;
  final String androidVersion;
  final bool isConnected;

  /// Constructor for creating a Device instance.
  DeviceModel({
    required this.completeIpAddress,
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
      completeIpAddress: json['completeIpAddress'] as String,
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
      'completeIpAddress': completeIpAddress,
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
    String? completeIpAddress,
    String? customName,
    bool? isConnected,
  }) {
    return DeviceModel(
      completeIpAddress: completeIpAddress ?? this.completeIpAddress,
      customName: customName ?? this.customName,
      serialNumber: serialNumber,
      model: model,
      manufacturer: manufacturer,
      androidVersion: androidVersion,
      isConnected: isConnected ?? this.isConnected,
    );
  }

  @override
  String toString() => '''
DeviceModel: {
    completeIpAddress: $completeIpAddress,
    customName: $customName,
    serialNumber: $serialNumber,
    model: $model,
    manufacturer: $manufacturer,
    androidVersion: $androidVersion,
    isConnected: $isConnected
  }
''';
}
