import 'dart:async';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:vector_math/vector_math.dart';

class QiblaState {
  final String location;
  final double direction;
  final String feedback;
  final bool hasPermission;
  final bool isLoading;
  final String? error;
  final double? compassHeading;
  
  const QiblaState({
    required this.location,
    required this.direction,
    required this.feedback,
    this.hasPermission = false,
    this.isLoading = true,
    this.error,
    this.compassHeading,
  });

  QiblaState copyWith({
    String? location,
    double? direction,
    String? feedback,
    bool? hasPermission,
    bool? isLoading,
    String? error,
    double? compassHeading,
  }) {
    return QiblaState(
      location: location ?? this.location,
      direction: direction ?? this.direction,
      feedback: feedback ?? this.feedback,
      hasPermission: hasPermission ?? this.hasPermission,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      compassHeading: compassHeading ?? this.compassHeading,
    );
  }
}

class QiblaNotifier extends StateNotifier<QiblaState> {
  StreamSubscription<CompassEvent>? _compassSubscription;
  static const double kaabaLat = 21.4225;
  static const double kaabaLng = 39.8262;
  
  QiblaNotifier()
      : super(const QiblaState(
          location: 'Fetching location...',
          direction: 0.0,
          feedback: 'Requesting permissions...',
          isLoading: true,
        )) {
    _init();
  }

  Future<void> _init() async {
    try {
      final permission = await _checkLocationPermission();
      if (!permission) {
        state = state.copyWith(
          hasPermission: false,
          isLoading: false,
          error: 'Location permission denied',
          feedback: 'Please enable location permissions to find Qibla direction',
        );
        return;
      }

      state = state.copyWith(hasPermission: true, isLoading: true);
      await _startLocationUpdates();
      _startCompassUpdates();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error initializing: $e',
        feedback: 'An error occurred while setting up Qibla finder',
      );
    }
  }

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> _startLocationUpdates() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      final qiblaDirection = _calculateQiblaDirection(
        position.latitude,
        position.longitude,
      );
      
      state = state.copyWith(
        location: 'Lat: ${position.latitude.toStringAsFixed(4)}, '
                 'Lng: ${position.longitude.toStringAsFixed(4)}',
        direction: qiblaDirection,
        isLoading: false,
        feedback: 'Point your device towards the arrow',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error getting location: $e',
        feedback: 'Failed to get your location',
      );
    }
  }

  void _startCompassUpdates() {
    if (FlutterCompass.events == null) {
      state = state.copyWith(
        error: 'Device does not support compass',
        feedback: 'Compass not available on this device',
      );
      return;
    }

    _compassSubscription = FlutterCompass.events?.listen((event) {
      if (event.heading != null) {
        state = state.copyWith(compassHeading: event.heading);
      }
    });
  }

  double _calculateQiblaDirection(double lat, double lng) {
    // Convert to radians
    final latRad = radians(lat);
    final lngRad = radians(lng);
    final kaabaLatRad = radians(kaabaLat);
    final kaabaLngRad = radians(kaabaLng);

    // Calculate Qibla direction using the great circle formula
    final y = math.sin(kaabaLngRad - lngRad);
    final x = math.cos(latRad) * math.tan(kaabaLatRad) -
             math.sin(latRad) * math.cos(kaabaLngRad - lngRad);
    
    var qiblaDirection = degrees(math.atan2(y, x));
    // Normalize to 0-360
    qiblaDirection = (qiblaDirection + 360) % 360;
    
    return qiblaDirection;
  }

  void refresh() => _init();

  @override
  void dispose() {
    _compassSubscription?.cancel();
    super.dispose();
  }
}

final qiblaProvider = StateNotifierProvider<QiblaNotifier, QiblaState>(
  (ref) => QiblaNotifier(),
); 