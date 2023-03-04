import 'dart:async';

import 'package:client_app/api_endpoints.dart';
import 'package:client_app/main.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/services/firestore_fetch_service.dart';
import 'package:client_app/ui/screens/home_screen.dart';
import 'package:client_app/ui/views/popups.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../views/select_upload_image_view.dart';

class SignupScreen extends StatefulWidget {
  static const String routeName = '/signup';
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late Completer<SelectImagesViewController> selectImagesViewController =
      Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Signup Screen"),
              Text("Almost there"),
              SelectUploadImagesView(
                uploadFolder: "profile",
                maxImages: 1,
                onControllerReady: (controller) =>
                    {selectImagesViewController.complete(controller)},
              ),
              ElevatedButton(
                onPressed: () async {
                  final controller = await selectImagesViewController.future;

                  if (await controller.isImageSelected() == false) {
                    Popups.showSnackbar(
                        context: context, message: "Please select an image");
                    return;
                  }

                  final images = await controller.uploadImages();

                  final Profile profile =
                      Profile(photo: images.first, isLandlord: false);

                  final User user = await getIt.get<AuthService>().getFBUser();

                  getIt.get<FirestoreFetchService>().setOrUpdateDocument(
                      path: ApiEndpoints.getProfile(uid: user.uid),
                      data: profile.toDocument());

                  navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
                },
                child: Text("Signup"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
