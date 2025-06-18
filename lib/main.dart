// main.dart
import 'package:flutter/material.dart';
// IMPORTANT: This code is specifically tailored for desktop_webview_window version ^0.6.1
// If your pubspec.yaml uses an older version, you MUST update it to ^0.6.1
// and run 'flutter pub get' for this code to work correctly.
import 'package:desktop_webview_window/desktop_webview_window.dart';
import 'dart:io' show Platform, exit;
// Note: path_provider is no longer strictly needed for userDataFolderWindows in ^0.6.1
// as getWebviewPaths() provides it directly. However, it doesn't hurt to keep it if used elsewhere.
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


// This part is crucial for 'desktop_webview_window' to initialize correctly.
// It must be placed directly in your `main.dart` file.
// It handles the creation of the webview's title bar widget.
Future<void> main(List<String> args) async {
  // Ensure Flutter engine is initialized before any Flutter-specific calls.
  WidgetsFlutterBinding.ensureInitialized();

  // If the arguments indicate a webview title bar should be run, handle it and exit.
  // This is part of the package's internal mechanism to manage webview windows.
  if (runWebViewTitleBarWidget(args)) {
    return;
  }

  // Run your main Flutter application.
  runApp(const MyApp());
}

// The root widget of your Flutter application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shaharia.me Desktop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          centerTitle: true,
        ),
      ),
      home: const DesktopWebApp(),
    );
  }
}

// The main desktop web app widget
class DesktopWebApp extends StatefulWidget {
  const DesktopWebApp({super.key});

  @override
  State<DesktopWebApp> createState() => _DesktopWebAppState();
}

class _DesktopWebAppState extends State<DesktopWebApp> {
  Webview? _webview;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  String _currentUrl = 'https://www.shaharia.me';
  final TextEditingController _urlController = TextEditingController();
  bool _webviewReady = false;

  @override
  void initState() {
    super.initState();
    _urlController.text = _currentUrl;
    _initializeWebview();
  }

  Future<void> _initializeWebview() async {
    // Check if running on web platform
    if (kIsWeb) {
      setState(() {
        _hasError = true;
        _errorMessage = 'This app is designed for desktop platforms only. Please run on Windows, macOS, or Linux.';
        _isLoading = false;
      });
      return;
    }

    try {
      // Check for WebView availability on Windows
      if (Platform.isWindows && !await WebviewWindow.isWebviewAvailable()) {
        setState(() {
          _hasError = true;
          _errorMessage = 'WebView2 Runtime is not installed. Please install it to use this app.';
          _isLoading = false;
        });
        return;
      }

      // Get the user data directory for the webview
      final userDataDir = await getApplicationSupportDirectory();
      
      // Create a new WebviewWindow instance
      _webview = await WebviewWindow.create(
        configuration: CreateConfiguration(
          windowHeight: 900,
          windowWidth: 1400,
          title: "Shaharia.me - Desktop Browser",
          userDataFolderWindows: userDataDir.path,
        ),
      );

      // Add listener for webview close event
      _webview!.onClose.then((_) {
        debugPrint("WebView closed!");
        // Don't exit the app, just mark webview as closed
        setState(() {
          _webviewReady = false;
        });
      });

      // Load the website
      _webview!.launch(_currentUrl);
      
      setState(() {
        _isLoading = false;
        _webviewReady = true;
      });

    } catch (e) {
      debugPrint("Error launching webview: $e");
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load the website: $e';
        _isLoading = false;
      });
    }
  }

  void _navigateToUrl() {
    final url = _urlController.text.trim();
    if (url.isNotEmpty && _webview != null) {
      setState(() {
        _currentUrl = url.startsWith('http') ? url : 'https://$url';
        _urlController.text = _currentUrl;
      });
      _webview!.launch(_currentUrl);
    }
  }

  void _openNewWebview() {
    _initializeWebview();
  }

  void _refresh() {
    if (_webview != null) {
      _webview!.launch(_currentUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20),
                    const Text(
                      'Loading Shaharia.me...',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Preparing your desktop experience',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Error',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _hasError = false;
                        _errorMessage = '';
                      });
                      _initializeWebview();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Main desktop app interface
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Shaharia.me Desktop App',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          // Status indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: _webviewReady ? Colors.green[100] : Colors.orange[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _webviewReady ? Icons.check_circle : Icons.pending,
                  size: 16,
                  color: _webviewReady ? Colors.green[700] : Colors.orange[700],
                ),
                const SizedBox(width: 4),
                Text(
                  _webviewReady ? 'Connected' : 'Disconnected',
                  style: TextStyle(
                    fontSize: 12,
                    color: _webviewReady ? Colors.green[700] : Colors.orange[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // URL Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.link, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: 'Enter URL...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onSubmitted: (_) => _navigateToUrl(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _navigateToUrl,
                  child: const Text('Go'),
                ),
              ],
            ),
          ),
          // Main content area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _webviewReady
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.web,
                            size: 48,
                            color: Colors.green,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Website is loaded in a separate window',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Look for the Shaharia.me window',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.web,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No active webview',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Click the button below to open a new window',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: _openNewWebview,
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Open Website Window'),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}

// Custom WebviewWidget for embedding webview content
class WebviewWidget extends StatelessWidget {
  final Webview? webview;

  const WebviewWidget({super.key, this.webview});

  @override
  Widget build(BuildContext context) {
    if (webview == null) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.web,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Website content will be embedded here',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Loading Shaharia.me...',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // For now, we'll show a placeholder since embedding webview directly
    // in Flutter widgets requires additional setup
    return Container(
      color: Colors.white,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.web,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'Website content is embedded in this window',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Shaharia.me is loaded in the background',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}