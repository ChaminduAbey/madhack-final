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
import 'package:client_app/ui/screens/update_profile_screen.dart';
import 'package:client_app/ui/screens/view_property_screen.dart';
import 'package:client_app/ui/screens/splash_screen.dart';
import 'package:client_app/ui/views/error_view.dart';
import 'package:client_app/ui/views/image_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

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
      final User user = getIt.get<AuthService>().getFBUser();
      final Profile profile = userProvider.profile;
      return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: [
            GestureDetector(
              onTap: () {
                navigatorKey.currentState!
                    .pushNamed(UpdateProfileScreen.routeName);
              },
              child: Container(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white),
                padding: const EdgeInsets.all(2.0),
                margin: const EdgeInsets.only(right: 16.0),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ImageWidget(
                      height: 40,
                      width: 40,
                      imageUrl: profile.photo.url,
                      hash: profile.photo.blurhash),
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: surfaceColor,
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: ImageWidget(
                        imageUrl: profile.photo.url,
                        hash: profile.photo.blurhash,
                        width: 80,
                        height: 80,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      userProvider.profile.name,
                      style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text("Home"),
                onTap: () {
                  navigatorKey.currentState!.pop();
                },
              ),
              ListTile(
                title: Text("Profile"),
                onTap: () {
                  navigatorKey.currentState!.pop();
                  navigatorKey.currentState!
                      .pushNamed(UpdateProfileScreen.routeName);
                },
              ),
              Expanded(child: Container()),
              ListTile(
                title: const Text(
                  "Logout",
                  style: TextStyle(color: primaryColor),
                ),
                onTap: () async {
                  // timeDilation = 1.0;
                  await getIt.get<AuthService>().signOut();
                  navigatorKey.currentState!
                      .pushReplacementNamed(SplashScreen.routeName);
                },
                trailing: Icon(
                  Icons.logout,
                  color: primaryColor,
                ),
              ),
            ],
          ),
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
                      return AnimationLimiter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < rooms.length; i++)
                              buildRoomCard(i, rooms[i]),
                          ],
                        ),
                      );
                    }),
                  ),
      );
    });
  }

  Widget buildRoomCard(int index, Property property) {
    final List<Profile> profiles =
        Provider.of<UserProvider>(context, listen: false).profiles;
    final Profile ownerProfile =
        profiles.where((element) => element.id == property.ownerUid).first;

    final width = MediaQuery.of(context).size.width;

    final heightOfImage = width * 2 / 3;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
          verticalOffset: 50.0,
          child: FadeInAnimation(
            child: InkWell(
              onTap: () {
                navigatorKey.currentState!.pushNamed(
                    ViewPropertyScreen.routeName,
                    arguments: ViewPropertyScreenArgs(
                        property: property, landlordProfile: ownerProfile));
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
                          imageUrl: property.images.first.url,
                          hash: property.images.first.blurhash),
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
                                  Hero(
                                    tag:
                                        "profile-image/${ownerProfile.id}-${property.id}",
                                    child: Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          color: Colors.white),
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: ImageWidget(
                                            height: 80,
                                            width: 80,
                                            imageUrl: ownerProfile.photo.url,
                                            hash: ownerProfile.photo.blurhash),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    ownerProfile.name,
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                        color: darkColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("LKR ${property.price}",
                                        style: GoogleFonts.poppins(
                                            color: darkColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20))
                                  ],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(child: Text(property.description)),
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
          ),
        ),
      ),
    );
  }
}
