import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化通知插件
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  
  runApp(MyApp(notificationsPlugin: flutterLocalNotificationsPlugin));
}

class MyApp extends StatelessWidget {
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  
  const MyApp({Key? key, required this.notificationsPlugin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
        title: '功能演示应用',
        notificationsPlugin: notificationsPlugin,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.notificationsPlugin,
  }) : super(key: key);

  final String title;
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // 初始化相机
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('没有可用的相机')),
      );
      return;
    }

    // 使用前置摄像头进行人脸识别
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
    );

    try {
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('相机初始化失败: $e')),
      );
    }
  }

  // 人脸识别功能
  Future<void> _startFaceRecognition() async {
    // 请求相机权限
    final status = await Permission.camera.request();
    if (status.isGranted) {
      await _initializeCamera();
      if (_isCameraInitialized) {
        // 打开人脸识别页面
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FaceRecognitionScreen(
              cameraController: _cameraController!,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('需要相机权限才能进行人脸识别')),
      );
    }
  }

  // 发送系统通知
  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    
    await widget.notificationsPlugin.show(
      0,
      '系统通知',
      '这是一条来自Flutter应用的系统通知',
      platformChannelSpecifics,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('通知已发送')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _startFaceRecognition,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('人脸识别', style: TextStyle(fontSize: 18)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showNotification,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('系统通知', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

// 人脸识别页面
class FaceRecognitionScreen extends StatefulWidget {
  final CameraController cameraController;

  const FaceRecognitionScreen({
    Key? key,
    required this.cameraController,
  }) : super(key: key);

  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _startDetection();
  }

  Future<void> _startDetection() async {
    setState(() {
      _isDetecting = true;
    });
    
    // 这里是模拟人脸识别过程
    // 实际应用中，您需要集成专门的人脸识别库
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      setState(() {
        _isDetecting = false;
      });
      
      // 模拟识别成功
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('人脸识别成功')),
      );
      
      // 延迟返回
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('人脸识别'),
      ),
      body: Column(
        children: [
          Expanded(
            child: CameraPreview(widget.cameraController),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: _isDetecting
                ? const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('正在进行人脸识别，请保持面部在屏幕中央'),
                    ],
                  )
                : const Text('识别完成'),
          ),
        ],
      ),
    );
  }
}
