import 'dart:developer';

import 'package:client_app/constants/colors.dart';
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
import 'package:google_fonts/google_fonts.dart';
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
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16, top: 16, bottom: 64),
                    child: Consumer<RoomProvider>(
                        builder: (context, RoomProvider roomProvider, child) {
                      final List<University> universities =
                          roomProvider.universities;
                      final List<Property> rooms = roomProvider.rooms;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var room in rooms) buildRoomCard(room),
                        ],
                      );
                    }),
                  ),
      );
    });
  }

  Widget buildRoomCard(Property room) {
    final List<Profile> profiles =
        Provider.of<UserProvider>(context, listen: false).profiles;
    final Profile ownerProfile =
        profiles.where((element) => element.id == room.ownerUid).first;

    final width = MediaQuery.of(context).size.width;

    final heightOfImage = width * 2 / 3;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        onTap: () {
          navigatorKey.currentState!.pushNamed(ViewPropertyScreen.routeName,
              arguments: ViewPropertyScreenArgs(property: room));
        },
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Stack(
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: ImageWidget(
                    imageUrl: room.images.first.url,
                    hash: room.images.first.blurhash),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: heightOfImage - 64,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ImageWidget(
                                    height: 80,
                                    width: 80,
                                    imageUrl: ownerProfile.photo.url,
                                    hash: ownerProfile.photo.blurhash),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              ownerProfile.name,
                              style: GoogleFonts.poppins(
                                  color: darkColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            )
                          ],
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("LKR ${room.price}",
                                  style: GoogleFonts.poppins(
                                      color: darkColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 24))
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: Text(room.description)),
                        IgnorePointer(
                          child: IconButton(
                              style: IconButton.styleFrom(
                                  backgroundColor: surfaceColor),
                              onPressed: () {},
                              icon: Icon(
                                Icons.arrow_forward_ios,
                                color: primaryColor,
                              )),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
