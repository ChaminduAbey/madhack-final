import 'dart:async';

import 'package:client_app/controllers/add_room_controller.dart';
import 'package:client_app/main.dart';
import 'package:client_app/models/cdn_image.dart';
import 'package:client_app/models/faculty_room_time.dart';
import 'package:client_app/models/university.dart';
import 'package:client_app/providers/room_provider.dart';
import 'package:client_app/ui/views/custom_loading_dialog.dart';
import 'package:client_app/ui/views/pick_count_view.dart';
import 'package:client_app/ui/views/popups.dart';
import 'package:client_app/ui/views/select_upload_image_view.dart';
import 'package:flutter/material.dart';

import '../../mixins/view_state_mixin.dart';
import '../../models/faculty.dart';
import '../../utils/common_validators.dart';
import '../views/error_view.dart';

class AddRoomScreen extends StatefulWidget {
  static const String routeName = '/add-room';
  const AddRoomScreen({super.key});

  @override
  State<AddRoomScreen> createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> with ViewStateMixin {
  final AddRoomController _addRoomController = AddRoomController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      try {
        setBusy();
        _addRoomController.init();

        setIdle();
      } catch (ex) {
        setError();
      }
    });
    super.initState();
  }

  int bedsCount = 1;
  int bathroomsCount = 1;
  int kitchensCount = 1;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<FacultyRoomTime> _facultyRoomTimes = [];

  Completer<SelectImagesViewController> _selectImagesViewControllerCompleter =
      Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Property"),
      ),
      body: isBusy
          ? Center(child: CircularProgressIndicator())
          : isError
              ? ErrorView()
              : Builder(builder: (context) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            validator: valueRequired,
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: "Name",
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            validator: valueRequired,
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: "Description",
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            validator: valueRequired,
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Price",
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            validator: valueRequired,
                            controller: _addressController,
                            decoration: InputDecoration(
                              labelText: "Address",
                            ),
                          ),
                          const SizedBox(height: 16),
                          PickCountView(
                              count: bedsCount,
                              onCountChanged: (value) {
                                setState(() {
                                  bedsCount = value;
                                });
                              },
                              label: "Beds"),
                          const SizedBox(height: 16),
                          PickCountView(
                              count: bathroomsCount,
                              onCountChanged: (value) {
                                setState(() {
                                  bathroomsCount = value;
                                });
                              },
                              label: "Bathrooms"),
                          const SizedBox(height: 16),
                          PickCountView(
                              count: kitchensCount,
                              onCountChanged: (value) {
                                setState(() {
                                  kitchensCount = value;
                                });
                              },
                              label: "Kitchens"),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const Expanded(
                                  child: Text(
                                      "Approx Travelling Time to Faculty")),
                              TextButton(
                                  onPressed: () {
                                    showFacultyPicker(context);
                                  },
                                  child: const Text("Add"))
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (_facultyRoomTimes.isEmpty)
                            const Text("No faculty added"),
                          if (_facultyRoomTimes.isNotEmpty)
                            ..._facultyRoomTimes.map((e) => Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(e.faculty.name),
                                          Text(e.duration.inMinutes.toString() +
                                              " mins"),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _facultyRoomTimes.remove(e);
                                          });
                                        },
                                        icon: Icon(Icons.delete))
                                  ],
                                )),
                          const SizedBox(height: 16),
                          Text("Images"),
                          const SizedBox(height: 16),
                          SelectUploadImagesView(
                              onControllerReady: (controller) =>
                                  _selectImagesViewControllerCompleter
                                      .complete(controller),
                              uploadFolder: "rooms",
                              maxImages: 10),
                          const SizedBox(height: 16),
                          ElevatedButton(
                              onPressed: () {
                                addRoom();
                              },
                              child: Text("Add Room"))
                        ],
                      ),
                    ),
                  );
                }),
    );
  }

  void showFacultyPicker(BuildContext context) {
    final List<University> universities =
        getIt.get<RoomProvider>().universities;
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _PickFacultyBottomSheet(
            universities: universities,
            onFacultySelected: (Faculty faculty) {
              showDurationPicker(context, faculty);
            },
          );
        });
  }

  void showDurationPicker(BuildContext context, Faculty faculty) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return _PickDurationBottomView(
            faculty: faculty,
            onDurationSelected: (duration) {
              setState(() {
                _facultyRoomTimes
                    .removeWhere((element) => element.faculty.id == faculty.id);

                _facultyRoomTimes
                    .add(FacultyRoomTime(faculty: faculty, duration: duration));
              });
            },
          );
        });
  }

  void addFacultyRoomTime() {
    final RoomProvider roomProvider = getIt.get<RoomProvider>();
    setState(() {
      _facultyRoomTimes.add(FacultyRoomTime(
          faculty: roomProvider.universities[0].faculties.first,
          duration: Duration(minutes: 10)));
    });
  }

  Future<void> addRoom() async {
    try {
      if (_formKey.currentState!.validate()) {
        final SelectImagesViewController selectImagesViewController =
            await _selectImagesViewControllerCompleter.future;

        if (await selectImagesViewController.isImageSelected() == false) {
          Popups.showSnackbar(
              context: context, message: "Please atleast 1 image");
          return;
        }

        if (_facultyRoomTimes.isEmpty) {
          Popups.showSnackbar(
              context: context,
              message: "Please add faculty atleast 1 travelling time");
          return;
        }

        CustomLoadingDialog.show(context, message: "Uploading images");

        final List<CdnImage> images =
            await selectImagesViewController.uploadImages();

        CustomLoadingDialog.hide(context);

        CustomLoadingDialog.show(context);
        await _addRoomController.addRoom(
          name: _nameController.text,
          description: _descriptionController.text,
          price: _priceController.text,
          address: _addressController.text,
          bedsCount: bedsCount,
          bathroomsCount: bathroomsCount,
          facultyRoomTimes: _facultyRoomTimes,
          images: images,
          kitchensCount: kitchensCount,
        );

        CustomLoadingDialog.hide(context);
        Navigator.of(context).pop();
      }
    } catch (ex) {
      CustomLoadingDialog.hide(context);
      Popups.showSnackbar(context: context, message: "Error adding room");
    }
  }
}

class _PickFacultyBottomSheet extends StatefulWidget {
  final List<University> universities;
  final Function(Faculty) onFacultySelected;

  const _PickFacultyBottomSheet({
    super.key,
    required this.universities,
    required this.onFacultySelected,
  });

  @override
  State<_PickFacultyBottomSheet> createState() =>
      _PickFacultyBottomSheetState();
}

class _PickFacultyBottomSheetState extends State<_PickFacultyBottomSheet> {
  late List<bool> _isExpanded;

  @override
  void initState() {
    _isExpanded = List.generate(widget.universities.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      builder: ((context, scrollController) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const Text("Select University & Faculty"),
                const SizedBox(height: 16),
                ExpansionPanelList(
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _isExpanded[index] = !isExpanded;
                    });
                  },
                  children: [
                    for (int i = 0; i < widget.universities.length; i++)
                      ExpansionPanel(
                        headerBuilder: (context, isExpanded) =>
                            Text(widget.universities[i].name),
                        body: Column(
                          children: [
                            ...widget.universities[i].faculties
                                .map((e) => ListTile(
                                      title: Text(e.name),
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        widget.onFacultySelected(e);
                                      },
                                    ))
                          ],
                        ),
                        isExpanded: _isExpanded[i],
                      )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class _PickDurationBottomView extends StatefulWidget {
  final Faculty faculty;
  final Function(Duration) onDurationSelected;
  const _PickDurationBottomView({
    super.key,
    required this.faculty,
    required this.onDurationSelected,
  });

  @override
  State<_PickDurationBottomView> createState() =>
      _PickDurationBottomViewState();
}

class _PickDurationBottomViewState extends State<_PickDurationBottomView> {
  int count = 5;
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.8,
      builder: ((context, scrollController) => Container(
          color: Colors.white,
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            children: [
              const Text("Select Duration"),
              const SizedBox(height: 16),
              PickCountView(
                  count: count,
                  onCountChanged: (x) {
                    setState(() {
                      count = x;
                    });
                  },
                  label: "Select Duration"),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {
                    widget.onDurationSelected(Duration(minutes: count));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add"))
            ],
          ))),
    );
  }
}
