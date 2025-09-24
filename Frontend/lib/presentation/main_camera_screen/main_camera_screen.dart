import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/camera_controls_widget.dart';
import './widgets/detection_button_widget.dart';
import './widgets/detection_history_sheet_widget.dart';
import './widgets/detection_mode_indicator_widget.dart';
import './widgets/detection_overlay_widget.dart';

class MainCameraScreen extends StatefulWidget {
  const MainCameraScreen({Key? key}) : super(key: key);

  @override
  State<MainCameraScreen> createState() => _MainCameraScreenState();
}

class _MainCameraScreenState extends State<MainCameraScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  // Camera related variables
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  bool _isDetecting = false;
  bool _isFlashOn = false;
  double _zoomLevel = 1.0;

  // Detection related variables
  String _currentMode = 'Objects';
  List<String> _detectionModes = ['Objects', 'Currency', 'People'];
  List<Map<String, dynamic>> _detectedObjects = [];
  List<Map<String, dynamic>> _detectionHistory = [];
  String _lastAnnouncement = '';

  // UI state variables
  bool _isHistorySheetVisible = false;
  bool _isContinuousMode = false;

  // Animation controllers
  late AnimationController _borderAnimationController;
  late Animation<Color?> _borderColorAnimation;

  // Mock detection data
  final List<Map<String, dynamic>> _mockObjectDetections = [
    {
      'name': 'Coffee Mug',
      'x': 0.3,
      'y': 0.4,
      'confidence': 0.95,
      'type': 'object'
    },
    {
      'name': 'Smartphone',
      'x': 0.6,
      'y': 0.2,
      'confidence': 0.88,
      'type': 'object'
    },
    {'name': 'Book', 'x': 0.1, 'y': 0.7, 'confidence': 0.92, 'type': 'object'},
  ];

  final List<Map<String, dynamic>> _mockCurrencyDetections = [
    {
      'name': '₹500 Note',
      'x': 0.4,
      'y': 0.5,
      'confidence': 0.97,
      'type': 'currency'
    },
    {
      'name': '₹10 Coin',
      'x': 0.2,
      'y': 0.3,
      'confidence': 0.85,
      'type': 'currency'
    },
  ];

  final List<Map<String, dynamic>> _mockPeopleDetections = [
    {
      'name': 'Person',
      'x': 0.5,
      'y': 0.3,
      'confidence': 0.93,
      'type': 'person'
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _initializeCamera();
    _announceScreenReady();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _borderAnimationController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  void _initializeAnimations() {
    _borderAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _borderColorAnimation = ColorTween(
      begin: AppTheme.primaryLight,
      end: AppTheme.accentColor,
    ).animate(CurvedAnimation(
      parent: _borderAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeCamera() async {
    try {
      if (!await _requestCameraPermission()) {
        _announceText(
            'Camera permission denied. Please enable camera access in settings.');
        return;
      }

      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        _announceText('No cameras found on this device.');
        return;
      }

      final camera = kIsWeb
          ? _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.front,
              orElse: () => _cameras.first)
          : _cameras.firstWhere(
              (c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => _cameras.first);

      _cameraController = CameraController(
        camera,
        kIsWeb ? ResolutionPreset.medium : ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      await _applyInitialCameraSettings();

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _announceText('Failed to initialize camera. Please try again.');
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;

    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applyInitialCameraSettings() async {
    if (_cameraController == null) return;

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      if (!kIsWeb) {
        await _cameraController!.setFlashMode(FlashMode.off);
      }
    } catch (e) {
      // Silently handle unsupported features
    }
  }

  void _announceScreenReady() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _announceText(
          'Camera ready. Tap the detection button to start identifying objects.');
    });
  }

  void _announceText(String text) {
    // In a real implementation, this would use text-to-speech
    // For now, we'll use haptic feedback and store the announcement
    HapticFeedback.lightImpact();
    _lastAnnouncement = text;

    // Add to history
    _addToHistory(text, _getCurrentModeType());

    if (kDebugMode) {
      print('TTS: $text');
    }
  }

  String _getCurrentModeType() {
    switch (_currentMode.toLowerCase()) {
      case 'currency':
        return 'currency';
      case 'people':
        return 'person';
      default:
        return 'object';
    }
  }

  void _addToHistory(String text, String type) {
    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _detectionHistory.insert(0, {
        'text': text,
        'time': timeString,
        'type': type,
        'timestamp': now,
      });

      // Keep only last 20 detections
      if (_detectionHistory.length > 20) {
        _detectionHistory = _detectionHistory.take(20).toList();
      }
    });
  }

  void _startDetection() {
    if (!_isCameraInitialized) {
      _announceText('Camera not ready. Please wait.');
      return;
    }

    setState(() {
      _isDetecting = true;
    });

    _borderAnimationController.repeat(reverse: true);
    _announceText('Detecting ${_currentMode.toLowerCase()}...');

    // Simulate detection process
    Future.delayed(const Duration(milliseconds: 2000), () {
      _performDetection();
    });
  }

  void _stopDetection() {
    setState(() {
      _isDetecting = false;
      _isContinuousMode = false;
    });

    _borderAnimationController.stop();
    _borderAnimationController.reset();
    _announceText('Detection stopped.');
  }

  void _performDetection() {
    if (!_isDetecting) return;

    List<Map<String, dynamic>> detections;
    String announcement;

    switch (_currentMode.toLowerCase()) {
      case 'currency':
        detections = List.from(_mockCurrencyDetections);
        announcement = _generateCurrencyAnnouncement(detections);
        break;
      case 'people':
        detections = List.from(_mockPeopleDetections);
        announcement = _generatePeopleAnnouncement(detections);
        break;
      default:
        detections = List.from(_mockObjectDetections);
        announcement = _generateObjectAnnouncement(detections);
        break;
    }

    setState(() {
      _detectedObjects = detections;
    });

    _announceText(announcement);
    HapticFeedback.mediumImpact();

    if (_isContinuousMode && _isDetecting) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        _performDetection();
      });
    } else {
      setState(() {
        _isDetecting = false;
      });
      _borderAnimationController.stop();
      _borderAnimationController.reset();
    }
  }

  String _generateObjectAnnouncement(List<Map<String, dynamic>> detections) {
    if (detections.isEmpty) {
      return 'No objects detected. Try moving the camera around.';
    }

    final objectNames = detections.map((d) => d['name'] as String).toList();
    if (objectNames.length == 1) {
      return 'Found: ${objectNames.first}';
    } else if (objectNames.length == 2) {
      return 'Found: ${objectNames.first} and ${objectNames.last}';
    } else {
      final lastObject = objectNames.removeLast();
      return 'Found: ${objectNames.join(', ')}, and $lastObject';
    }
  }

  String _generateCurrencyAnnouncement(List<Map<String, dynamic>> detections) {
    if (detections.isEmpty) {
      return 'No currency detected. Position the camera over Indian currency notes or coins.';
    }

    final currencyNames = detections.map((d) => d['name'] as String).toList();
    return 'Currency detected: ${currencyNames.join(', ')}';
  }

  String _generatePeopleAnnouncement(List<Map<String, dynamic>> detections) {
    if (detections.isEmpty) {
      return 'No people detected in the camera view.';
    }

    final count = detections.length;
    return count == 1 ? 'One person detected' : '$count people detected';
  }

  void _onDetectionButtonTap() {
    if (_isDetecting) {
      _stopDetection();
    } else {
      _startDetection();
    }
  }

  void _onDetectionButtonLongPress() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isContinuousMode = true;
    });
    _announceText('Continuous detection mode activated');
    _startDetection();
  }

  void _cycleDetectionMode() {
    final currentIndex = _detectionModes.indexOf(_currentMode);
    final nextIndex = (currentIndex + 1) % _detectionModes.length;

    setState(() {
      _currentMode = _detectionModes[nextIndex];
      _detectedObjects.clear();
    });

    _announceText('Detection mode changed to ${_currentMode.toLowerCase()}');
    HapticFeedback.selectionClick();
  }

  void _toggleFlash() async {
    if (_cameraController == null || kIsWeb) return;

    try {
      final newFlashMode = _isFlashOn ? FlashMode.off : FlashMode.torch;
      await _cameraController!.setFlashMode(newFlashMode);

      setState(() {
        _isFlashOn = !_isFlashOn;
      });

      _announceText(_isFlashOn ? 'Flash turned on' : 'Flash turned off');
      HapticFeedback.lightImpact();
    } catch (e) {
      _announceText('Flash not available on this device');
    }
  }

  void _onZoomChanged(double value) async {
    if (_cameraController == null || kIsWeb) return;

    try {
      await _cameraController!.setZoomLevel(value);
      setState(() {
        _zoomLevel = value;
      });
    } catch (e) {
      // Silently handle zoom errors
    }
  }

  void _openSettings() {
    Navigator.pushNamed(context, '/settings-screen');
  }

  void _replayLastAnnouncement() {
    if (_lastAnnouncement.isNotEmpty) {
      _announceText(_lastAnnouncement);
    } else {
      _announceText('No previous announcement to replay');
    }
  }

  void _onReplayAnnouncement(String text) {
    _announceText(text);
  }

  void _toggleHistorySheet() {
    setState(() {
      _isHistorySheetVisible = !_isHistorySheetVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Camera preview
            _buildCameraPreview(),

            // Detection border animation
            if (_isDetecting) _buildDetectionBorder(),

            // Detection overlays
            if (_detectedObjects.isNotEmpty)
              DetectionOverlayWidget(detectedObjects: _detectedObjects),

            // Top status bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DetectionModeIndicatorWidget(
                      currentMode: _currentMode,
                      onModeTap: _cycleDetectionMode,
                    ),
                  ],
                ),
              ),
            ),

            // Camera controls (right side)
            Positioned(
              top: 0,
              right: 0,
              bottom: 25.h,
              child: CameraControlsWidget(
                isFlashOn: _isFlashOn,
                zoomLevel: _zoomLevel,
                onFlashToggle: _toggleFlash,
                onZoomChanged: _onZoomChanged,
                onSettingsTap: _openSettings,
              ),
            ),

            // Detection button (bottom center)
            Positioned(
              bottom: 8.h,
              left: 0,
              right: 0,
              child: Center(
                child: DetectionButtonWidget(
                  isDetecting: _isDetecting,
                  onTap: _onDetectionButtonTap,
                  onLongPress: _onDetectionButtonLongPress,
                ),
              ),
            ),

            // History button (bottom left)
            Positioned(
              bottom: 10.h,
              left: 4.w,
              child: Semantics(
                label: 'Detection history',
                hint: 'View previous detections',
                button: true,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _toggleHistorySheet,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'history',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Replay button (bottom right)
            Positioned(
              bottom: 10.h,
              right: 4.w,
              child: Semantics(
                label: 'Replay last announcement',
                hint: 'Double tap detection button for same function',
                button: true,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _replayLastAnnouncement,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'replay',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Detection history bottom sheet
            if (_isHistorySheetVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _toggleHistorySheet,
                  child: Container(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {}, // Prevent tap through
                      child: DetectionHistorySheetWidget(
                        detectionHistory: _detectionHistory,
                        onReplayAnnouncement: _onReplayAnnouncement,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (!_isCameraInitialized || _cameraController == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppTheme.primaryLight,
              ),
              SizedBox(height: 2.h),
              Text(
                'Initializing camera...',
                style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _cameraController!.value.previewSize?.height ?? 1,
          height: _cameraController!.value.previewSize?.width ?? 1,
          child: CameraPreview(_cameraController!),
        ),
      ),
    );
  }

  Widget _buildDetectionBorder() {
    return AnimatedBuilder(
      animation: _borderColorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _borderColorAnimation.value ?? AppTheme.primaryLight,
              width: 4,
            ),
          ),
        );
      },
    );
  }
}
