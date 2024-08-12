import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../utils/logger_service.dart';

class BluetoothService {
  BluetoothConnection? _connection;

  // Scans for paired Bluetooth devices
  Future<List<BluetoothDevice>> scanForDevices() async {
    try {
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      LoggerService.info('Scanned devices: ${devices.map((d) => d.name).toList()}');
      return devices;
    } catch (e) {
      LoggerService.error('Error scanning for Bluetooth devices: $e');
      throw Exception('Error scanning for Bluetooth devices: $e');
    }
  }

  // Connects to a Bluetooth device
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      LoggerService.info('Connected to device: ${device.name}');
    } catch (e) {
      LoggerService.error('Failed to connect to device: $e');
      throw Exception('Failed to connect to device: $e');
    }
  }

  // Disconnects from the connected Bluetooth device
  Future<void> disconnectFromDevice() async {
    try {
      await _connection?.close();
      LoggerService.info('Disconnected from Bluetooth device');
      _connection = null;
    } catch (e) {
      LoggerService.error('Failed to disconnect from device: $e');
      throw Exception('Failed to disconnect from device: $e');
    }
  }

  // Sends data to the connected Bluetooth device
  Future<void> sendData(String data) async {
    try {
      _connection?.output.add(Uint8List.fromList(data.codeUnits));
      await _connection?.output.allSent;
      LoggerService.info('Data sent: $data');
    } catch (e) {
      LoggerService.error('Failed to send data: $e');
      throw Exception('Failed to send data: $e');
    }
  }

  // Receives data from the connected Bluetooth device
  Stream<String> receiveData() async* {
    try {
      _connection?.input?.listen((Uint8List data) {
        final receivedData = String.fromCharCodes(data);
        LoggerService.info('Data received: $receivedData');
        yield receivedData;
      });
    } catch (e) {
      LoggerService.error('Failed to receive data: $e');
      throw Exception('Failed to receive data: $e');
    }
  }

  // Checks if a device is connected
  bool isConnected() {
    return _connection != null;
  }
}
