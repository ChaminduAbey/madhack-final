import 'dart:async';

import 'package:client_app/constants/colors.dart';
import 'package:client_app/controllers/signup_controller.dart';
import 'package:client_app/main.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/ui/screens/home_screen.dart';
import 'package:client_app/ui/views/custom_loading_dialog.dart';
import 'package:client_app/ui/views/popups.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    User user = getIt.get<AuthService>().getFBUser();
    _nameController.text = user.displayName ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Almost there",
                    style: GoogleFonts.poppins(
                        fontSize: 32, fontWeight: FontWeight.w600, height: 1)),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Your Name",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Your Phone Number",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                // should be in the format 0XXXXXXXXX
                TextFormField(
                  controller: _phoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number";
                    }
                    if (value.length != 10) {
                      return "Please enter a valid phone number";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your phone number (0XXXXXXXXX)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Select a profile picture",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 24),
                ),
                const SizedBox(
                  height: 8,
                ),
                SelectUploadImagesView(
                  uploadFolder: "profile",
                  maxImages: 1,
                  onControllerReady: (controller) =>
                      {selectImagesViewController.complete(controller)},
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Select account type",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 24),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: CustomSlidingSegmentedControl<bool>(
                      initialValue: isLandlord,
                      fixedWidth: (MediaQuery.of(context).size.width - 40) / 2,
                      children: {
                        false: DefaultTextStyle(
                            style: TextStyle(
                              color: isLandlord ? primaryColor : Colors.white,
                            ),
                            child: Center(child: Text("Tenant"))),
                        true: DefaultTextStyle(
                            style: TextStyle(
                              color: !isLandlord ? primaryColor : Colors.white,
                            ),
                            child: Center(child: Text("Landlord"))),
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
                ),
                const SizedBox(
                  height: 48,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      _signup();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 64, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'COMPLETE PROFILE',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    try {
      if (_formKey.currentState!.validate() == false) {
        return;
      }

      final controller = await selectImagesViewController.future;

      if (await controller.isImageSelected() == false) {
        Popups.showSnackbar(
            context: navigatorKey.currentContext!,
            message: "Please select an image");
        return;
      }

      CustomLoadingDialog.show(navigatorKey.currentContext!,
          message: "Signing up");

      final images = await controller.uploadImages();

      final User user = FirebaseAuth.instance.currentUser!;

      final Profile profile = Profile(
          photo: images.first,
          isLandlord: isLandlord,
          name: user.displayName ?? "",
          contactNo: _phoneController.text,
          id: user.uid);

      await _signupController.signup(profile: profile);

      CustomLoadingDialog.hide(navigatorKey.currentContext!);

      navigatorKey.currentState!.pushReplacementNamed(HomeScreen.routeName);
    } catch (ex) {
      CustomLoadingDialog.hide(navigatorKey.currentContext!);
      Popups.showSnackbar(
          context: navigatorKey.currentContext!, message: "An error occurred");

      rethrow;
    }
  }
}
