import 'dart:async';

import 'package:client_app/constants/colors.dart';
import 'package:client_app/controllers/signup_controller.dart';
import 'package:client_app/main.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/ui/screens/home_screen.dart';
import 'package:client_app/ui/views/popups.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
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
  bool isLandlord = false;
  final SignupController _signupController = SignupController();
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: CustomSlidingSegmentedControl<bool>(
                  initialValue: isLandlord,
                  children: {
                    false: DefaultTextStyle(
                        style: TextStyle(
                          color: isLandlord ? primaryColor : Colors.white,
                        ),
                        child: Text("Tenant")),
                    true: DefaultTextStyle(
                        style: TextStyle(
                          color: !isLandlord ? primaryColor : Colors.white,
                        ),
                        child: Text("Landlord")),
                  },
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.3),
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                        offset: Offset(
                          0.0,
                          2.0,
                        ),
                      ),
                    ],
                  ),
                  customSegmentSettings:
                      CustomSegmentSettings(highlightColor: Colors.white),
                  onValueChanged: (v) {
                    setState(() {
                      isLandlord = v;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final controller = await selectImagesViewController.future;

                  if (await controller.isImageSelected() == false) {
                    Popups.showSnackbar(
                        context: navigatorKey.currentContext!,
                        message: "Please select an image");
                    return;
                  }

                  final images = await controller.uploadImages();

                  final Profile profile =
                      Profile(photo: images.first, isLandlord: isLandlord);

                  await _signupController.signup(profile: profile);

                  navigatorKey.currentState!
                      .pushReplacementNamed(HomeScreen.routeName);
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
