import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Robot extends StatefulWidget {
  const Robot({Key? key}) : super(key: key);

  @override
  State<Robot> createState() => _RobotState();
}

class _RobotState extends State<Robot> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Robot"),
        ),
        body: const ModelViewer(
          backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
          src: 'assets/output_model.gltf',
          alt: 'A 3D model of an astronaut',
          autoRotate: true,
          disableZoom: true,
          autoPlay: true,
        ),
      ),
    );
  }
}
