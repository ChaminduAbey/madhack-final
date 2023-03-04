import 'package:client_app/models/room.dart';
import 'package:flutter/material.dart';

class RoomViewScreenArgs {
  final Room room;

  RoomViewScreenArgs({required this.room});
}

class RoomViewScreen extends StatefulWidget {
  static const String routeName = "/room-view";
  const RoomViewScreen({super.key});

  @override
  State<RoomViewScreen> createState() => _RoomViewScreenState();
}

class _RoomViewScreenState extends State<RoomViewScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RoomViewScreenArgs;
    final Room room = args.room;
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [],
        ),
      )),
    );
  }
}
