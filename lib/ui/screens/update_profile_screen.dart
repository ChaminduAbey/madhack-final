import 'dart:async';

import 'package:client_app/constants/colors.dart';
import 'package:client_app/controllers/signup_controller.dart';
import 'package:client_app/main.dart';
import 'package:client_app/models/profile.dart';
import 'package:client_app/providers/user_provider.dart';
import 'package:client_app/services/auth_service.dart';
import 'package:client_app/ui/screens/home_screen.dart';
import 'package:client_app/ui/views/custom_loading_dialog.dart';
import 'package:client_app/ui/views/popups.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/update_profile_controller.dart';
import '../views/select_upload_image_view.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String routeName = '/update';
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final UpdateProfileController _updateProfileController =
      UpdateProfileController();

  @override
  void initState() {
    Profile profile = getIt.get<UserProvider>().profile;
    _nameController.text = profile.name;
    _phoneController.text = profile.contactNo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

      CustomLoadingDialog.show(navigatorKey.currentContext!,
          message: "Updating Profile. Please wait...");

      final User user = FirebaseAuth.instance.currentUser!;

      final currentProfile = getIt.get<UserProvider>().profile;

      final Profile profile = Profile(
          photo: currentProfile.photo,
          isLandlord: currentProfile.isLandlord,
          name: user.displayName ?? "",
          contactNo: _phoneController.text,
          id: user.uid);

      await _updateProfileController.updateProfile(profile: profile);

      CustomLoadingDialog.hide(navigatorKey.currentContext!);

      navigatorKey.currentState!.pop();

      Popups.showSnackbar(
          context: navigatorKey.currentContext!, message: "Profile updated");
    } catch (ex) {
      CustomLoadingDialog.hide(navigatorKey.currentContext!);
      Popups.showSnackbar(
          context: navigatorKey.currentContext!, message: "An error occurred");

      rethrow;
    }
  }
}
