import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/detection_header_widget.dart';
import './widgets/detection_image_widget.dart';
import './widgets/detection_info_card_widget.dart';
import './widgets/related_objects_widget.dart';

class DetectionResultsScreen extends StatefulWidget {
  const DetectionResultsScreen({Key? key}) : super(key: key);

  @override
  State<DetectionResultsScreen> createState() => _DetectionResultsScreenState();
}

class _DetectionResultsScreenState extends State<DetectionResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Mock detection data
  final Map<String, dynamic> detectionData = {
    "objectName": "Coffee Mug",
    "confidence": 0.87,
    "category": "Kitchen Item",
    "description":
        "A ceramic coffee mug with a handle, commonly used for drinking hot beverages like coffee, tea, or hot chocolate. This appears to be a standard-sized mug with a smooth finish.",
    "imageUrl":
        "https://images.unsplash.com/photo-1514228742587-6b1558fcf93a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "timestamp": DateTime.now(),
  };

  final List<Map<String, dynamic>> relatedObjects = [
    {
      "name": "Tea Cup",
      "category": "Kitchen Item",
      "imageUrl":
          "https://images.unsplash.com/photo-1544787219-7f47ccb76574?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "name": "Water Bottle",
      "category": "Kitchen Item",
      "imageUrl":
          "https://images.unsplash.com/photo-1602143407151-7111542de6e8?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "name": "Plate",
      "category": "Kitchen Item",
      "imageUrl":
          "https://images.unsplash.com/photo-1578662996442-48f60103fc96?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "name": "Spoon",
      "category": "Utensil",
      "imageUrl":
          "https://images.unsplash.com/photo-1606787366850-de6330128bfc?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _announceDetectionResult();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
  }

  void _announceDetectionResult() {
    // Simulate voice announcement for accessibility
    Future.delayed(const Duration(milliseconds: 500), () {
      final String announcement =
          "Detection complete. Found ${detectionData['objectName']} with ${((detectionData['confidence'] as double) * 100).toStringAsFixed(1)} percent confidence. ${detectionData['description']}";

      // Announce to screen readers
      SemanticsService.announce(
        announcement,
        TextDirection.ltr,
      );
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _handleBackPressed() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/main-camera-screen');
  }

  void _handleDetectAgain() {
    HapticFeedback.mediumImpact();
    Navigator.pushReplacementNamed(context, '/main-camera-screen');
  }

  void _handleSaveToHistory() {
    HapticFeedback.lightImpact();

    // Simulate saving to history
    Fluttertoast.showToast(
      msg: "Detection saved to history",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: Colors.white,
      fontSize: 16.sp,
    );

    // Announce save action
    SemanticsService.announce(
      "Detection result saved to history",
      TextDirection.ltr,
    );
  }

  void _handleShareResult() {
    HapticFeedback.lightImpact();

    // Simulate sharing functionality
    final String shareText =
        "I detected a ${detectionData['objectName']} with ${((detectionData['confidence'] as double) * 100).toStringAsFixed(1)}% confidence using Blind Assistant app.";

    Fluttertoast.showToast(
      msg: "Sharing detection result",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.primaryLight,
      textColor: Colors.white,
      fontSize: 16.sp,
    );

    // Announce share action
    SemanticsService.announce(
      "Detection result shared",
      TextDirection.ltr,
    );
  }

  void _handleRelatedObjectTap(Map<String, dynamic> object) {
    HapticFeedback.lightImpact();

    final String objectName = object['name'] as String;
    Fluttertoast.showToast(
      msg: "Selected $objectName",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.primaryLight,
      textColor: Colors.white,
      fontSize: 16.sp,
    );

    // Announce selection
    SemanticsService.announce(
      "Selected related object: $objectName",
      TextDirection.ltr,
    );
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.mediumImpact();

    // Simulate re-analyzing the image
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      // Update confidence slightly to simulate re-analysis
      detectionData['confidence'] =
          (detectionData['confidence'] as double) + 0.02;
      if ((detectionData['confidence'] as double) > 1.0) {
        detectionData['confidence'] = 0.85;
      }
    });

    Fluttertoast.showToast(
      msg: "Image re-analyzed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.successColor,
      textColor: Colors.white,
      fontSize: 16.sp,
    );

    // Announce re-analysis
    SemanticsService.announce(
      "Image re-analyzed with updated results",
      TextDirection.ltr,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.primaryLight,
          backgroundColor: AppTheme.lightTheme.colorScheme.surface,
          child: CustomScrollView(
            slivers: [
              // Header Section
              SliverToBoxAdapter(
                child: DetectionHeaderWidget(
                  detectedItemName: detectionData['objectName'] as String,
                  onBackPressed: _handleBackPressed,
                ),
              ),

              // Main Content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(height: 3.h),

                    // Detection Image
                    DetectionImageWidget(
                      imageUrl: detectionData['imageUrl'] as String?,
                      objectName: detectionData['objectName'] as String,
                    ),

                    // Detection Information Card
                    DetectionInfoCardWidget(
                      objectName: detectionData['objectName'] as String,
                      confidenceLevel: detectionData['confidence'] as double,
                      category: detectionData['category'] as String,
                      description: detectionData['description'] as String,
                    ),

                    // Action Buttons
                    ActionButtonsWidget(
                      onDetectAgain: _handleDetectAgain,
                      onSaveToHistory: _handleSaveToHistory,
                      onShareResult: _handleShareResult,
                    ),

                    // Related Objects Section
                    RelatedObjectsWidget(
                      relatedObjects: relatedObjects,
                      onObjectTap: _handleRelatedObjectTap,
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Floating Settings Button
      floatingActionButton: Semantics(
        label: "Open settings",
        button: true,
        child: FloatingActionButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pushNamed(context, '/settings-screen');
          },
          backgroundColor: AppTheme.primaryLight,
          child: CustomIconWidget(
            iconName: 'settings',
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
