import 'package:client_app/main.dart';
import 'package:client_app/models/property.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/ui/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../utils/utils.dart';

class ViewPropertyScreenArgs {
  final Property property;

  ViewPropertyScreenArgs({required this.property});
}

class ViewPropertyScreen extends StatefulWidget {
  static const String routeName = "/view-property";
  const ViewPropertyScreen({super.key});

  @override
  State<ViewPropertyScreen> createState() => _ViewPropertyScreenState();
}

class _ViewPropertyScreenState extends State<ViewPropertyScreen> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ViewPropertyScreenArgs;
    final Property property = args.property;
    return Scaffold(
      appBar: AppBar(
        title: Text(property.name),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  final User user = await getIt<AuthService>().getFBUser();
                  final roomUid = getChatRoomId(user.uid, property.ownerUid);

                  FirebaseChatCore.instance.room(roomUid).listen((event) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatScreen(room: event)));
                  }).onError((error) async {
                    //room doesnt exit create it
                    final room = await FirebaseChatCore.instance
                        .createRoom(types.User(id: property.ownerUid));

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatScreen(room: room)));
                  });
                },
                child: Text("Send Message"))
          ],
        ),
      )),
    );
  }
}
