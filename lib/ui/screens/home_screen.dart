import 'dart:developer';

import 'package:client_app/api_endpoints.dart';
import 'package:client_app/main.dart';
import 'package:client_app/models/cdn_image.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/providers/user_provider.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/firestore_fetch_service.dart';
import 'package:client_app/services/user_service.dart';
import 'package:client_app/ui/views/image_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";
  CdnImage? image;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        final User user = getIt<AuthService>().getFBUser();
        name = user.displayName!;
        final Profile profile = getIt<UserProvider>().profile!;

        image = profile.photo;
        setState(() {});
      } catch (ex) {
        log(ex.toString());
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
        floatingActionButton: userProvider.profile!.isLandlord
            ? FloatingActionButton.extended(
                onPressed: () {},
                label: Text("Add Property"),
                icon: Icon(Icons.add),
              )
            : null,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hi, " + name),
              if (image != null)
                AspectRatio(
                    aspectRatio: 1,
                    child: ImageWidget(
                        imageUrl: image!.url, hash: image!.blurhash))
            ],
          ),
        ),
      );
    });
  }
}
