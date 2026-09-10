import 'package:flutter/foundation.dart';

import '../../data/repositories/device_repository.dart';
import '../../data/services/device_realtime_service.dart';

class DeviceTrackingController extends ChangeNotifier {
  DeviceTrackingController({required this.repository, DeviceRealtimeService? realtime}) : realtime = realtime ?? DeviceRealtimeService();

  final DeviceRepository repository;
  final DeviceRealtimeService realtime;
  int? _petId;
  List<DeviceModel> _devices = [];
  bool _loading = false;
  String? _error;
  List<String> _alerts = [];
  List<DeviceAlertModel> _deviceAlerts = [];

  List<DeviceModel> get devices => List.unmodifiable(_devices);
  bool get loading => _loading;
  String? get error => _error;
  List<String> get alerts => List.unmodifiable(_alerts);
  List<DeviceAlertModel> get deviceAlerts => List.unmodifiable(_deviceAlerts);
  DeviceModel? get activeDevice => _devices.isEmpty ? null : _devices.first;

  Future<void> load(int petId) async {
    _petId = petId;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final devices = await repository.listDevices(petId);
      final alerts = await repository.listAlerts(petId);
      if (_petId == petId) { _devices = devices; _deviceAlerts = alerts; }
      if (_petId == petId) await realtime.subscribe(petId: petId, deviceIds: devices.map((d) => d.id).toList(), reconcile: () => _reconcile(petId));
    } catch (error) {
      _error = error.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _reconcile(int petId) async {
    if (_petId != petId) return;
    final devices = await repository.listDevices(petId);
    final alerts = await repository.listAlerts(petId);
    if (_petId != petId) return;
    _devices = devices; _deviceAlerts = alerts; notifyListeners();
  }

  Future<bool> pairDemo(int petId) async {
    if (_loading) return false;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final device = await repository.pairDevice(
        petId: petId,
        name: 'Petto Demo GPS Collar',
        identifier: 'PETTO-DEMO-$petId',
      );
      _petId = petId;
      _devices = [device, ..._devices.where((item) => item.id != device.id)];
      return true;
    } catch (error) {
      _error = error.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> simulateTelemetry({bool anomaly = false}) async {
    final device = activeDevice;
    if (device == null || _loading) return false;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final result = await repository.ingestTelemetry(
        deviceId: device.id,
        samples: [
          {
            'lat': 18.796263,
            'lng': 98.961291,
            'speed_kmh': anomaly ? 60.0 : 4.2,
          },
          {
            'lat': 18.796820,
            'lng': 98.962010,
            'speed_kmh': anomaly ? 62.0 : 5.1,
          },
          if (anomaly)
            {
              'lat': 18.797200,
              'lng': 98.962500,
              'speed_kmh': 61.0,
            },
        ],
        batteryPercent: anomaly ? 18 : 82,
        sessionDurationMinutes: anomaly ? null : 18,
        sessionDistanceMeters: anomaly ? null : 1100,
        sessionId: anomaly ? null : 'demo-${device.id}-${DateTime.now().millisecondsSinceEpoch}',
      );
      _devices = [
        result.device,
        ..._devices.where((item) => item.id != result.device.id),
      ];
      _alerts = result.anomalies;
      if (_petId != null) _deviceAlerts = await repository.listAlerts(_petId!);
      return true;
    } catch (error) {
      _error = error.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> acknowledge(int alertId) async {
    final updated = await repository.acknowledgeAlert(alertId);
    final index = _deviceAlerts.indexWhere((a) => a.id == alertId);
    if (index >= 0) _deviceAlerts[index] = updated;
    notifyListeners();
  }

  Future<bool> unpair() async {
    final device = activeDevice;
    if (device == null || _loading) return false;
    _loading = true;
    notifyListeners();
    try {
      await repository.unpairDevice(device.id);
      _devices = _devices.where((item) => item.id != device.id).toList();
      _alerts = [];
      return true;
    } catch (error) {
      _error = error.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void clearForAccount() {
    realtime.close();
    _petId = null;
    _devices = [];
    _alerts = [];
    _deviceAlerts = [];
    _loading = false;
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() { realtime.close(); super.dispose(); }
}
