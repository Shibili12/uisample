import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uisample/model/complaints.dart';
import 'package:uisample/model/enquiry.dart';
import 'package:uisample/model/selectedproduct.dart';
import 'package:record/record.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

class Complaintpage extends StatefulWidget {
  const Complaintpage({super.key});

  @override
  State<Complaintpage> createState() => _ComplaintpageState();
}

class _ComplaintpageState extends State<Complaintpage> {
  TextEditingController dateinput = TextEditingController();
  TextEditingController expdate = TextEditingController();
  TextEditingController timecontroller = TextEditingController();
  TextEditingController remarktext = TextEditingController();
  TextEditingController primary = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController secondary = TextEditingController();
  TextEditingController whatsapp = TextEditingController();
  TextEditingController outside = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController refered = TextEditingController();
  TextEditingController taguser = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController assigned = TextEditingController();
  late Box<Enquiry> enquiryBox;
  List<Enquiry> enquirylist = [];
  List<Enquiry> suggestionList = [];
  late Box<Selectedproducts> selectedproductsBox;
  List<Selectedproducts> productselected = [];
  late Box<Complaint> complaintBox;
  List<Complaint> savedcomplaints = [];
  final record = AudioRecorder();
  bool isRecording = false;
  String audioFilepath = "";
  File? _selectedFile;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  List<File> _selectedFiles = [];
  List<String> selectedMediaList = [];
  bool _isCompressing = false;
  List<int> _selectedFileStates = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadEnquiryData();
    complaintBox = Hive.box<Complaint>('complaints');
    savedcomplaints = complaintBox.values.toList();
  }

  Future<void> statRecording() async {
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String fileName = 'audio_file_$timestamp.mp3';
    String customPath =
        (await getApplicationDocumentsDirectory()).path + fileName;
    if (await record.hasPermission()) {
      await record.start(RecordConfig(), path: customPath);
      setState(() {
        isRecording = true;
      });
    }
  }

  Future<void> stopRecording() async {
    String? path = await record.stop();
    setState(() {
      isRecording = false;
      audioFilepath = path!;
    });
  }

  void loadEnquiryData(String searchTerm) async {
    enquiryBox = await Hive.openBox<Enquiry>('enquiryBox');
    enquirylist = enquiryBox.values.toList();

    setState(() {
      suggestionList = enquirylist
          .where((enquiry) =>
              enquiry.primarynumber.startsWith(searchTerm) &&
              enquiry.primarynumber != searchTerm)
          .toList();
    });
  }

  void loadProductsForEnquiry(String enquiryId) async {
    selectedproductsBox =
        await Hive.openBox<Selectedproducts>('selectedProducts');
    productselected = selectedproductsBox.values
        .where((product) => product.enquiryId == enquiryId)
        .toList();

    // Update the product list in your UI
    setState(() {
      // Update the product list in your UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Complaints"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              onPopup(context);
            },
            icon: Icon(Icons.attach_file_rounded),
          ),
          IconButton(
            onPressed: isRecording == true ? stopRecording : statRecording,
            icon:
                Icon(isRecording == true ? Icons.stop_circle : Icons.mic_none),
          ),
          TextButton(
            onPressed: () {
              addComplaintToHive();
              Navigator.of(context).pop();
            },
            child: Text(
              "ADD",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Autocomplete<Enquiry>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        return suggestionList
                            .where((enquiry) => enquiry.primarynumber
                                .contains(textEditingValue.text))
                            .toList();
                      },
                      onSelected: (Enquiry selectedEnquiry) {
                        setState(() {
                          primary.text = selectedEnquiry.primarynumber;
                          name.text = selectedEnquiry.name;
                          secondary.text = selectedEnquiry.secondarynumber;
                          whatsapp.text = selectedEnquiry.whatsappnumber;
                          outside.text = selectedEnquiry.outsidemob;
                          email.text = selectedEnquiry.email;
                          dateinput.text = selectedEnquiry.followdate;
                          timecontroller.text = selectedEnquiry.followtime;
                          expdate.text = selectedEnquiry.expclosure;
                          source.text = selectedEnquiry.source;
                          assigned.text = selectedEnquiry.assigneduser;
                          taguser.text = selectedEnquiry.taguser;
                          location.text = selectedEnquiry.location;
                          refered.text = selectedEnquiry.referedby;
                        });
                        var enqid;
                        for (var key in enquiryBox.keys) {
                          var value = enquiryBox.get(key);
                          if (suggestionList.contains(value)) {
                            enqid = key.toString();
                            loadProductsForEnquiry(enqid);
                          }
                        }
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        return TextFormField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onFieldSubmitted: (String value) {
                            if (primary.text != "") {
                              textEditingController.text = primary.text;
                            }
                            onFieldSubmitted();
                          },
                          onChanged: (String value) {
                            loadEnquiryData(value);
                          },
                          decoration: InputDecoration(
                            labelText: "Primary Number",
                          ),
                        );
                      },
                      optionsViewBuilder: (
                        BuildContext context,
                        AutocompleteOnSelected<Enquiry> onSelected,
                        Iterable<Enquiry> options,
                      ) {
                        return Material(
                          elevation: 4.0,
                          child: SizedBox(
                            height: 200.0,
                            child: ListView.builder(
                              padding: EdgeInsets.all(8.0),
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Enquiry enquiry =
                                    options.elementAt(index);
                                return ListTile(
                                  title: Text(enquiry.name),
                                  subtitle: Text(enquiry.primarynumber),
                                  onTap: () {
                                    onSelected(enquiry);
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: "Name",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: secondary,
                    decoration:
                        const InputDecoration(labelText: "secondary Number"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: whatsapp,
                    decoration: const InputDecoration(
                      labelText: "Whatsapp number",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: outside,
                    decoration: const InputDecoration(
                        labelText: "Outside Coubtry  mob"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: email,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: dateinput,
                    decoration: const InputDecoration(labelText: "Follow date"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: timecontroller,
                    decoration: const InputDecoration(
                      labelText: "Follow time",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: expdate,
                    decoration: const InputDecoration(labelText: "Exp closure"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: source,
                    decoration: const InputDecoration(
                      labelText: "Source",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: assigned,
                    decoration:
                        const InputDecoration(labelText: "Assigned user"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: taguser,
                    decoration: const InputDecoration(
                      labelText: "Tag user",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: location,
                    decoration: const InputDecoration(labelText: "Location"),
                  ),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: refered,
                    decoration: const InputDecoration(
                      labelText: "Reffered by",
                    ),
                  ),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: remarktext,
                    decoration: const InputDecoration(
                      labelText: "Remarks",
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: productselected.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(productselected[index].title),
                  subtitle: Text("${productselected[index].price}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addComplaintToHive() async {
    final primarynumber = primary.text;
    final leadname = name.text;
    final secondarynumber = secondary.text;
    final whatsappnumber = whatsapp.text;
    final outsideno = outside.text;
    final emailid = email.text;
    final followdate = dateinput.text;
    final followtime = timecontroller.text;
    final expclosure = expdate.text;
    final sources = source.text;
    final assigneduser = assigned.text;
    final tag = taguser.text;
    final loc = location.text;
    final refer = refered.text;
    final remark = remarktext.text;
    final complaintmodel = Complaint(
      primarynumber: primarynumber,
      name: leadname,
      secondarynumber: secondarynumber,
      whatsappnumber: whatsappnumber,
      outsidemob: outsideno,
      followdate: followdate,
      followtime: followtime,
      expclosure: expclosure,
      source: sources,
      assigneduser: assigneduser,
      taguser: tag,
      location: loc,
      referedby: refer,
      email: emailid,
      remarks: remark,
      audiopath: audioFilepath,
      // mediapath: selectedMediaList,
    );
    await complaintBox.add(complaintmodel);
    setState(() {
      savedcomplaints.add(complaintmodel);
    });
    primary.clear();
    name.clear();
    secondary.clear();
    whatsapp.clear();
    outside.clear();
    email.clear();
    dateinput.clear();
    timecontroller.clear();
    expdate.clear();
    source.clear();
    assigned.clear();
    taguser.clear();
    location.clear();
    refered.clear();
    remarktext.clear();
  }

  Future<File> compressImage(File file) async {
    Uint8List? uint8List = await FlutterImageCompress.compressWithFile(
      file.path,
      minWidth: 200,
      minHeight: 200,
      quality: 85,
    );

    if (uint8List != null) {
      List<int> compressedBytes = uint8List.cast<int>();
      File compressedFile = File('${file.path}_compressed.jpg');
      await compressedFile.writeAsBytes(compressedBytes);

      return compressedFile;
    } else {
      // Handle the case where compression failed
      throw Exception('Image compression failed');
    }
  }

  Future<File?> compressVideo(File file) async {
    try {
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.MediumQuality,
      );

      if (mediaInfo != null && mediaInfo.path != null) {
        return File(mediaInfo.path!);
      } else {
        // Handle the case where compression failed or mediaInfo is null
        return null;
      }
    } catch (e) {
      // Handle compression failure
      print("Video compression failed: $e");
      return null;
    }
  }

  Future<void> onPopup(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            content: SizedBox(
              width: 200,
              height: _selectedFiles.isNotEmpty ? 300 : 100,
              child: _selectedFiles.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          label: Text("Image"),
                          onPressed: () {
                            Navigator.of(context).pop('image');
                          },
                          icon: Icon(Icons.image),
                        ),
                        TextButton.icon(
                          label: Text("Video"),
                          onPressed: () {
                            Navigator.of(context).pop('video');
                          },
                          icon: Icon(Icons.video_collection_outlined),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _selectedFiles.length,
                            itemBuilder: (context, index) {
                              print("rebuilded");
                              final file = _selectedFiles[index];
                              late bool isSelected;
                              isSelected = _selectedFileStates.contains(index);
                              print(isSelected.toString());
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Container(
                                    height: 100,
                                    width: _isImage(file.path) ? 80 : 200,
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: _isImage(file.path)
                                        ? Image.file(file, fit: BoxFit.cover)
                                        : _buildVideoPlayer(file),
                                  ),
                                  Positioned(
                                    top: 1.0,
                                    right: 1.0,
                                    child: Checkbox(
                                      value: isSelected,
                                      onChanged: (value) {
                                        print(value.toString());
                                        setState(() {
                                          isSelected = value ?? false;
                                          if (isSelected) {
                                            _selectedFileStates.add(index);
                                          } else {
                                            _selectedFileStates.remove(index);
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  for (var file in _selectedFiles) {
                                    selectedMediaList.add(file.path);
                                  }
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(Icons.check_rounded)),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedFiles.removeWhere(
                                    (file) => _selectedFileStates
                                        .contains(_selectedFiles.indexOf(file)),
                                  );
                                  _selectedFileStates.clear();
                                });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  allowMultiple: true,
                                  type: FileType.custom,
                                  allowedExtensions: [
                                    'jpg',
                                    'jpeg',
                                    'png',
                                    'gif',
                                    'mp4',
                                    'mov',
                                    'avi'
                                  ],
                                );
                                if (result != null && result.files.isNotEmpty) {
                                  List<File?> compressedFiles = [];
                                  for (PlatformFile file in result.files) {
                                    String filePath = file.path!;
                                    File? compressedFile;
                                    if (_isImage(filePath)) {
                                      compressedFile =
                                          await compressImage(File(filePath));
                                    } else {
                                      compressedFile =
                                          await compressVideo(File(filePath));
                                    }
                                    compressedFiles.add(compressedFile);
                                  }
                                  compressedFiles
                                      .removeWhere((file) => file == null);
                                  _selectedFiles
                                      .addAll(compressedFiles.cast<File>());

                                  setState(() {});
                                  Navigator.of(context).pop();
                                }
                              },
                              icon: Icon(Icons.attach_file_rounded),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );

    if (result != null) {
      if (result == 'image') {
        await picImage(ImageSource.gallery);
      } else if (result == 'video') {
        await picVideo(ImageSource.gallery);
      }
    }
  }

  Future<void> picImage(ImageSource source) async {
    final picker = ImagePicker();

    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      for (var pickedFile in pickedFiles) {
        File compressedFile = await compressImage(File(pickedFile.path));
        _selectedFiles.add(compressedFile);
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Images uploaded")));
    }

    setState(() {});
  }

  Future<void> picVideo(ImageSource gallery) async {
    final picker = ImagePicker();
    setState(() {
      // Set a flag to indicate that video compression is in progress
      _isCompressing = true;
    });
    final pickedFile = await picker.pickVideo(source: gallery);

    if (pickedFile != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
        barrierDismissible: false,
      );
      File? compressedFile = await compressVideo(File(pickedFile.path));
      setState(() {
        _isCompressing = false; // Reset the flag
      });
      Navigator.of(context).pop();
      _selectedFiles.add(compressedFile!);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Video uploaded")));
    }
    setState(() {});
  }

  bool _isImage(String path) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = path.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  Widget _buildVideoPlayer(File file) {
    // return SingleChildScrollView(
    //   child: Column(
    //     children: _selectedFiles.map((file) {
    VideoPlayerController videoPlayerController =
        VideoPlayerController.file(file);
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
    );
    return GestureDetector(
      onTap: () {
        // Navigate to full screen when the video is tapped
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Chewie(
                controller: chewieController.copyWith(
                  videoPlayerController: VideoPlayerController.file(file),
                  aspectRatio: 16 / 9,
                  autoPlay: true,
                  looping: false,
                  allowFullScreen: false,
                ),
              ),
            ),
          ),
        ));
      },
      child: Chewie(
        controller: chewieController,
      ),
    );
  }
}
