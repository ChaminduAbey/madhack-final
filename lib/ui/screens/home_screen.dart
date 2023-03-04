import 'dart:developer';

import 'package:client_app/controllers/home_controller.dart';
import 'package:client_app/main.dart';
import 'package:client_app/mixins/view_state_mixin.dart';
import 'package:client_app/models/cdn_image.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/models/university.dart';
import 'package:client_app/providers/room_provider.dart';
import 'package:client_app/providers/user_provider.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/ui/screens/view_property_screen.dart';
import 'package:client_app/ui/screens/splash_screen.dart';
import 'package:client_app/ui/views/error_view.dart';
import 'package:client_app/ui/views/image_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/property.dart';
import 'add_room_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ViewStateMixin {
  final HomeController _controller = HomeController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        setBusy();

        await _controller.init();

        setIdle();
      } catch (ex) {
        log(ex.toString());
        setError();
        rethrow;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (context, UserProvider userProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            IconButton(
              onPressed: () async {
                await getIt.get<AuthService>().signOut();
                navigatorKey.currentState!
                    .pushReplacementNamed(SplashScreen.routeName);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        floatingActionButton: userProvider.profile.isLandlord
            ? FloatingActionButton.extended(
                onPressed: () {
                  navigatorKey.currentState!.pushNamed(AddRoomScreen.routeName);
                },
                label: Text("Add Property"),
                icon: Icon(Icons.add),
              )
            : null,
        body: isBusy
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : isError
                ? ErrorView()
                : Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Consumer<RoomProvider>(
                          builder: (context, RoomProvider roomProvider, child) {
                        final List<University> universities =
                            roomProvider.universities;
                        final List<Property> rooms = roomProvider.rooms;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var room in rooms)
                              InkWell(
                                onTap: () {
                                  navigatorKey.currentState!.pushNamed(
                                      ViewPropertyScreen.routeName,
                                      arguments: ViewPropertyScreenArgs(
                                          property: room));
                                },
                                child: Card(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ImageWidget(
                                        hash: room.images.first.blurhash,
                                        imageUrl: room.images.first.url,
                                        width: 200,
                                        height: 200,
                                      ),
                                      Text(room.name),
                                      Text(room.address),
                                      Text(room.price.toString()),
                                      Text(room.description),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
      );
    });
  }
}
