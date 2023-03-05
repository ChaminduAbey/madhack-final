import 'package:client_app/constants/colors.dart';
import 'package:client_app/controllers/view_property_controller.dart';
import 'package:client_app/main.dart';
import 'package:client_app/mixins/view_state_mixin.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/models/property.dart';
import 'package:client_app/models/university.dart';
import 'package:client_app/providers/room_provider.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/ui/screens/chat_screen.dart';
import 'package:client_app/ui/views/error_view.dart';
import 'package:client_app/ui/views/image_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/university.dart';
import '../../utils/utils.dart';

class ViewPropertyScreenArgs {
  final Property property;
  final Profile landlordProfile;

  ViewPropertyScreenArgs(
      {required this.property, required this.landlordProfile});
}

class ViewPropertyScreen extends StatefulWidget {
  static const String routeName = "/view-property";
  const ViewPropertyScreen({super.key});

  @override
  State<ViewPropertyScreen> createState() => _ViewPropertyScreenState();
}

class _ViewPropertyScreenState extends State<ViewPropertyScreen>
    with ViewStateMixin {
  final ViewPropertyController _viewPropertyController =
      ViewPropertyController();

  @override
  void initState() {
    viewState = ViewStates.idle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ViewPropertyScreenArgs;
    final Property property = args.property;
    final Profile landlordProfile = args.landlordProfile;

    final width = MediaQuery.of(context).size.width;

    final imageHeight = width * 0.75;

    return Scaffold(
      floatingActionButton: Container(
        width: width - 32,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  onPressed: () {
                    openChatRoom(context: context, property: property);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Lets Talk",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.chat,
                        size: 20,
                      ),
                    ],
                  )),
            ),
            const SizedBox(
              width: 16,
            ),

            // call button now
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                  ),
                  onPressed: () {
                    // landlord phone number is in format 0XXXXXXXXXX
                    // so we need to remove the 0
                    // and add the country code +94

                    final Uri launchTele =
                        Uri.parse("tel:${landlordProfile.contactNo}");

                    canLaunchUrl(launchTele).then((value) {
                      if (value) {
                        launchUrl(launchTele);
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Call",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.call,
                        size: 20,
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
      body: isBusy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isError
              ? ErrorView()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(40),
                          ),
                          child: ImageWidget(
                              imageUrl: property.images.first.url,
                              hash: property.images.first.blurhash),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: imageHeight - 48,
                          ),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Hero(
                                    tag:
                                        "profile-image/${landlordProfile.id}-${property.id}",
                                    child: Container(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          color: Colors.white),
                                      padding: const EdgeInsets.all(2.0),
                                      child: Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                        ),
                                        child: ImageWidget(
                                            height: 64,
                                            width: 64,
                                            imageUrl: landlordProfile.photo.url,
                                            hash:
                                                landlordProfile.photo.blurhash),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        args.landlordProfile.name,
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "Landlord",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Material(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: surfaceColor,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 24),
                                            child: Column(
                                              children: [
                                                Icon(Icons.bed_sharp),
                                                Text(
                                                    "${property.numberOfBeds} Beds"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: surfaceColor,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 24),
                                            child: Column(
                                              children: [
                                                Icon(Icons.shower_sharp),
                                                Text(
                                                    "${property.numberOfBathrooms} Baths"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: surfaceColor,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 24),
                                            child: Column(
                                              children: [
                                                Icon(Icons.soup_kitchen_sharp),
                                                Text(
                                                    "${property.numberOfKitchens} Kitchens"),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 16,
                                    ),

                                    Text(
                                      "Rent",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24),
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Text(
                                      "LKR ${property.price}",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),

                                    //property description

                                    Text(
                                      "Description",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24),
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Text(
                                      property.description,
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.grey,
                                          fontSize: 16),
                                    ),

                                    const SizedBox(
                                      height: 16,
                                    ),

                                    Text(
                                      "Photo Gallery",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24),
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    SizedBox(
                                      height: 150,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount: property.images.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0,
                                                  top: 8,
                                                  bottom: 8),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                child: ImageWidget(
                                                    imageUrl: property
                                                        .images[index].url,
                                                    hash: property.images[index]
                                                        .blurhash),
                                              ),
                                            );
                                          }),
                                    ),

                                    const SizedBox(
                                      height: 16,
                                    ),

                                    //property description

                                    Text(
                                      "Approx Travel Times",
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24),
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    for (var i = 0;
                                        i < property.facultyRoomTimes.length;
                                        i++)
                                      Builder(builder: (context) {
                                        final List<University> universities =
                                            Provider.of<RoomProvider>(context,
                                                    listen: false)
                                                .universities;

                                        final University university =
                                            universities.firstWhere((element) =>
                                                element.id ==
                                                property.facultyRoomTimes[i]
                                                    .faculty.universityId);

                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${university.name}",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "${property.facultyRoomTimes[i].faculty.name} - ${property.facultyRoomTimes[i].duration.inMinutes} minutes",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        );
                                      }),

                                    const SizedBox(
                                      height: 64,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 32,
                        left: 16,
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            padding: const EdgeInsets.all(0.0),
                            child: const BackButton(
                              color: primaryColor,
                            )),
                      ),
                    ],
                  ),
                ),
    );
  }

  Future<void> openChatRoom({
    required Property property,
    required BuildContext context,
  }) async {
    final User user = await getIt<AuthService>().getFBUser();
    final roomUid = getChatRoomId(user.uid, property.ownerUid);

    FirebaseChatCore.instance.room(roomUid).listen((event) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatScreen(room: event)));
    }).onError((error) async {
      //room doesnt exit create it
      final room = await FirebaseChatCore.instance
          .createRoom(types.User(id: property.ownerUid));

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ChatScreen(room: room)));
    });
  }
}
