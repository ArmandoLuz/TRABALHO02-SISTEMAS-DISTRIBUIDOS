import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isNear = false;
  bool securityEnabled = false;
  late List<CameraDescription> cameras;
  StreamSubscription<int>? _proximitySubscription;
  final AudioPlayer _audioPlayer = AudioPlayer();
  CameraController? _cameraController;
  Timer? _debounceTimer;
  bool _isPlayingAlarm = false;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    cameras = await availableCameras();
    _cameraController = CameraController(
      cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras[0]),
      ResolutionPreset.medium,
    );
    await _cameraController?.initialize();
  }

  void _toggleSecurity(bool enable) {
    setState(() {
      securityEnabled = enable;
    });
    if (securityEnabled) {
      _initProximitySensor();
    } else {
      _proximitySubscription?.cancel();
      _stopAlarm();
    }
  }

  void _initProximitySensor() {
    _proximitySubscription = ProximitySensor.events.listen((event) {
      if (!securityEnabled) return;

      if (_debounceTimer?.isActive ?? false) return;

      _debounceTimer = Timer(Duration(milliseconds: 800), () {
        setState(() {
          isNear = event < 2; // Ajuste a sensibilidade
        });

        if (isNear) {
          _captureAndSendImage();
          _playAlarm();
        }
      });
    });
  }

  Future<void> _captureAndSendImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    final XFile file = await _cameraController!.takePicture();
    await _sendToServer(File(file.path));
  }

  Future<void> _sendToServer(File imageFile) async {
    Socket? socket;
    try {
      socket = await Socket.connect('192.168.10.16', 5000);
      Uint8List imageBytes = await imageFile.readAsBytes();
      socket.add(imageBytes);
      await socket.flush();
      print("Imagem enviada com sucesso via socket!");
    } catch (e) {
      print("Erro ao enviar imagem via socket: $e");
    } finally {
      socket?.destroy();
    }
  }

  void _playAlarm() async {
    if (_isPlayingAlarm) return;
    _isPlayingAlarm = true;

    await _audioPlayer.setSourceAsset("alarm.mp3");
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
    _audioPlayer.play(AssetSource("alarm.mp3"));
  }

  void _stopAlarm() async {
    if (_isPlayingAlarm) {
      await _audioPlayer.stop();
      _isPlayingAlarm = false;
    }
  }

  @override
  void dispose() {
    _proximitySubscription?.cancel();
    _audioPlayer.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Segurança por Proximidade')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                securityEnabled ? 'Segurança Ativada' : 'Segurança Desativada',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _toggleSecurity(true),
                child: Text('Ativar Segurança'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _toggleSecurity(false),
                child: Text('Desligar Segurança'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}