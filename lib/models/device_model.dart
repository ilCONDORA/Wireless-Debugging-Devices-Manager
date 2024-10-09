// Enumerations that represent the different names of the individual properties.
enum DevicePropertiesKeys {
  // These are the names of the properties for the Device model.
  completeIpAddress,
  customName,
  serialNumber,
  model,
  manufacturer,
  androidVersion,
  isConnected,
  // These are the names of the properties for other things.
  ipAddress,
  tcpipPort,
  positionId,
}

/// Model for the device.
class DeviceModel {
  final int positionId;
  final String completeIpAddress;
  final String customName;
  final String serialNumber;
  final String model;
  final String manufacturer;
  final String androidVersion;
  final bool isConnected;

  /// Constructor for creating a Device instance.
  DeviceModel({
    required this.positionId,
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
      positionId: json[DevicePropertiesKeys.positionId.toString()] as int,
      completeIpAddress:
          json[DevicePropertiesKeys.completeIpAddress.toString()] as String,
      customName: json[DevicePropertiesKeys.customName.toString()] as String,
      serialNumber:
          json[DevicePropertiesKeys.serialNumber.toString()] as String,
      model: json[DevicePropertiesKeys.model.toString()] as String,
      manufacturer:
          json[DevicePropertiesKeys.manufacturer.toString()] as String,
      androidVersion:
          json[DevicePropertiesKeys.androidVersion.toString()] as String,
      isConnected: json[DevicePropertiesKeys.isConnected.toString()] as bool,
    );
  }

  /// Converts a Device instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      DevicePropertiesKeys.positionId.toString(): positionId,
      DevicePropertiesKeys.completeIpAddress.toString(): completeIpAddress,
      DevicePropertiesKeys.customName.toString(): customName,
      DevicePropertiesKeys.serialNumber.toString(): serialNumber,
      DevicePropertiesKeys.model.toString(): model,
      DevicePropertiesKeys.manufacturer.toString(): manufacturer,
      DevicePropertiesKeys.androidVersion.toString(): androidVersion,
      DevicePropertiesKeys.isConnected.toString(): isConnected,
    };
  }

  /// Creates a copy of the current DeviceModel with the option to modify specific properties.
  /// If a property is not provided, the current value is retained.
  /// This method is used to create a new instance of DeviceModel with modified properties.
  DeviceModel copyWith({
    int? positionId,
    String? completeIpAddress,
    String? customName,
    bool? isConnected,
  }) {
    return DeviceModel(
      positionId: positionId ?? this.positionId,
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
    ${DevicePropertiesKeys.positionId.toString()}: $positionId,
    ${DevicePropertiesKeys.completeIpAddress.toString()}: $completeIpAddress,
    ${DevicePropertiesKeys.customName.toString()}: $customName,
    ${DevicePropertiesKeys.serialNumber.toString()}: $serialNumber,
    ${DevicePropertiesKeys.model.toString()}: $model,
    ${DevicePropertiesKeys.manufacturer.toString()}: $manufacturer,
    ${DevicePropertiesKeys.androidVersion.toString()}: $androidVersion,
    ${DevicePropertiesKeys.isConnected.toString()}: $isConnected
  }
''';
}
