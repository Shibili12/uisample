import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:call_log/call_log.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CallLogsscreen extends StatefulWidget {
  const CallLogsscreen({super.key});

  @override
  State<CallLogsscreen> createState() => _CallLogsscreenState();
}

class _CallLogsscreenState extends State<CallLogsscreen>
    with TickerProviderStateMixin {
  List<CallLogEntry> callLogs = [];
  List<AudioPlayer> audioPlayers = [];
  List<Uint8List> pickedFiles = [];
  List<bool> isPlaying = [];
  List<Duration> duration = [];
  List<Duration> position = [];
  int currentlyPlayingIndex = -1;
  late SharedPreferences preferences;
  late String username;
  late bool newpath;
  late String path;
  List<bool> selectedCallLogs = [];
  bool isShareButtonClicked = false;
  bool isSelectAllChecked = false;
  Map<int, double> tileOffsets = {};

  final audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();

    check_user_set_path();
    // pickandstoreFiles();
    _fetchCallLogs();

    getuser();
  }

  void check_user_set_path() async {
    preferences = await SharedPreferences.getInstance();
    newpath = preferences.getBool('newpath') ?? true;
    if (newpath == false) {
      setState(() {
        path = preferences.getString('filePathKey')!;
      });
    } else {
      pickandstoreFiles();
    }
  }

  Future<void> pickandstoreFiles() async {
    preferences = await SharedPreferences.getInstance();

    final status = await Permission.storage.request();
    if (status.isGranted) {
      String? directoryPath = await FilePicker.platform.getDirectoryPath();
      if (directoryPath != null) {
        await preferences.setString('filePathKey', directoryPath);
        await preferences.setBool('newpath', false);
        Directory directory = Directory(directoryPath);
        List<FileSystemEntity> files = directory.listSync();
        for (FileSystemEntity file in files) {
          if (file is File) {
            String filePath = file.path;
            Uint8List? content = await readFromfile(filePath);

            pickedFiles.add(content!);
          }
        }
      }
    }
    setState(() {});
  }

  void getuser() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username')!;
    });
  }

  Future<void> _fetchCallLogs() async {
    final status = await Permission.phone.request();
    if (status.isGranted) {
      callLogs = (await CallLog.get()).toList();

      setState(() {
        audioPlayers = List.generate(callLogs.length, (index) => AudioPlayer());
        isPlaying = List.generate(callLogs.length, (index) => false);
        duration = List.generate(callLogs.length, (index) => Duration.zero);
        position = List.generate(callLogs.length, (index) => Duration.zero);
        selectedCallLogs = List.generate(callLogs.length, (index) => false);
      });
    } else {}
  }

  Future<Uint8List?> readFromfile(String pickedFilePath) async {
    try {
      File file = File(pickedFilePath);

      if (pickedFilePath.endsWith('.mp3')) {
        Uint8List content = await file.readAsBytes();
        return content;
      }
    } catch (e) {
      print('Error reading file: $e');
    }
  }

  void _playRecordings(Uint8List pickedFil, int index) async {
    if (currentlyPlayingIndex == index) {
      audioPlayers[index].pause();
      setState(() {
        isPlaying[index] = false;
        currentlyPlayingIndex = -1;
      });
    } else {
      Uint8List audioData = pickedFil;
      String audioFilePath = await createTemporaryAudioFile(audioData);

      audioPlayers[index].play(DeviceFileSource(audioFilePath));
      setState(() {
        isPlaying[index] = true;
        currentlyPlayingIndex = index;
      });
      audioPlayers[index].onDurationChanged.listen((newduration) {
        setState(() {
          duration[index] = newduration;
        });
      });
      audioPlayers[index].onPositionChanged.listen((newPosition) {
        setState(() {
          position[index] = newPosition;
        });
      });
    }
  }

  Future<void> seekAudio(int index, double value) async {
    final positionDuration = Duration(seconds: value.toInt());
    await audioPlayers[index].seek(positionDuration);
  }

  String _getFormattedDuration(CallLogEntry callLog) {
    final int duration = callLog.duration ?? 0;
    final Duration d1 = Duration(seconds: duration);
    String formattedDuration = "";
    if (d1.inHours > 0) {
      formattedDuration += "${d1.inHours}h ";
    }
    if (d1.inMinutes > 0) {
      formattedDuration += "${d1.inMinutes}m ";
    }
    if (d1.inSeconds > 0) {
      formattedDuration += "${d1.inSeconds}s";
    }
    return formattedDuration.isNotEmpty ? formattedDuration : "0s";
  }

  @override
  Widget build(BuildContext context) {
    int index = 0;
    // final now = DateTime.now();
    // final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final year = DateFormat('y').format(
        DateTime.fromMillisecondsSinceEpoch(callLogs[index].timestamp!));
    final month = DateFormat('MMM').format(
        DateTime.fromMillisecondsSinceEpoch(callLogs[index].timestamp!));
    final day = DateFormat('d').format(
        DateTime.fromMillisecondsSinceEpoch(callLogs[index].timestamp!));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Call Logs"),
        actions: [
          IconButton(
            onPressed: () async {
              if (isShareButtonClicked) {
                await shareSelectedCallLogsOnWhatsApp();
              }
              setState(() {
                isShareButtonClicked = !isShareButtonClicked;
                isSelectAllChecked = false;
              });
            },
            icon: Icon(Icons.share_outlined),
          ),
          IconButton(
            onPressed: () async {
              final pdfBytes = await genarateCallLogPdf(callLogs);
              // print(pdfBytes);
              await savePdfToStorage(pdfBytes, 'calllogs_report');
            },
            icon: Icon(Icons.ios_share_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            isShareButtonClicked
                ? Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Select All'),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 800),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: Checkbox(
                            key: ValueKey<bool>(isSelectAllChecked),
                            value: isSelectAllChecked,
                            onChanged: (value) {
                              setState(() {
                                isSelectAllChecked = value ?? false;
                                selectedCallLogs = List.generate(
                                    callLogs.length,
                                    (index) => isSelectAllChecked);
                                tileOffsets = Map.fromIterable(
                                  List.generate(
                                      callLogs.length, (index) => index),
                                  key: (index) => index,
                                  value: (_) => isSelectAllChecked ? 8.0 : 0.0,
                                );
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Expanded(
              child: SizedBox(
                height: 700,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final callLog = callLogs[index];

                    return TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale:
                                1.0 + (tileOffsets[index] ?? 0) / 100 * value,
                            child: ExpansionTile(
                              leading: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    // flex: 1,
                                    child: Text(
                                      year,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.yellow[600],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      day,
                                      style: TextStyle(
                                          fontSize: 25,
                                          color: Colors.blue[600],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    // flex: 1,
                                    child: Text(
                                      month,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.red[600],
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              title: Text(callLog.name ?? "Unknown"),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(callLog.number ?? ""),
                                  // Text(pickedFiles[index].name)
                                ],
                              ),
                              key: ValueKey(index),
                              trailing: Container(
                                width: 70,
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _getFormattedDuration(callLog),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: Icon(
                                        Icons.call,
                                        size: 20,
                                        color: callLog.callType ==
                                                CallType.incoming
                                            ? Colors.blue
                                            : callLog.callType ==
                                                    CallType.outgoing
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    ),
                                    Expanded(
                                      child: isShareButtonClicked
                                          ? Checkbox(
                                              value: selectedCallLogs[index],
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedCallLogs[index] =
                                                      value ?? false;
                                                  isSelectAllChecked =
                                                      !selectedCallLogs
                                                          .contains(false);
                                                  tileOffsets[index] =
                                                      selectedCallLogs[index]
                                                          ? 3.0
                                                          : 0.0;
                                                });
                                              },
                                            )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              ),
                              children: [
                                // pickedFiles.isEmpty
                                //     ? SizedBox(
                                //         child: Center(
                                //           child: Text("No recordings Available"),
                                //         ),
                                //       )
                                //     :
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        print(pickedFiles[index]);
                                        _playRecordings(
                                            pickedFiles[index], index);
                                      },
                                      icon: Icon(isPlaying[index]
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                    ),
                                    Expanded(
                                      flex: 6,
                                      child: Slider(
                                        min: 0,
                                        max: duration[index]
                                            .inSeconds
                                            .toDouble(),
                                        value: position[index]
                                            .inSeconds
                                            .toDouble(),
                                        onChanged: (value) {
                                          seekAudio(index, value);
                                        },
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Text(formattime(duration[index] -
                                            position[index]))),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  },
                  // separatorBuilder: (context, index) => const Divider(),
                  itemCount: callLogs.length,
                ),
              ),
            ),
            // pickedFiles.isEmpty
            //     ? SizedBox(
            //         height: 100,
            //         width: double.infinity,
            //         child: Padding(
            //           padding: const EdgeInsets.all(13.0),
            //           child: ElevatedButton(
            //               onPressed: () {
            //                 pickandstoreFiles();
            //                 print(pickedFiles.length);
            //               },
            //               child: const Text("data")),
            //         ),
            //       )
            //     : const SizedBox(),
          ],
        ),
      ),
    );
  }

  String formattime(Duration duration) {
    String twodigit(int n) => n.toString().padLeft(2, '0');
    final hours = twodigit(duration.inHours);
    final minutes = twodigit(duration.inMinutes.remainder(60));
    final seconds = twodigit(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(':');
  }

  @override
  void dispose() {
    for (final player in audioPlayers) {
      player.dispose();
    }

    super.dispose();
  }

  Future<Uint8List> genarateCallLogPdf(List<CallLogEntry> callLogs) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(build: (context) {
      return [
        pw.Header(
          level: 0,
          child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("User : $username"),
                pw.Text(
                    "Date : ${DateFormat('dd-MM-yyyy').format(DateTime.now())}"),
              ]),
        ),
        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(children: [
              pw.Text("Name",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Number",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Type",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("date",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Time",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text("Duration",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ]),
            for (final callLog in callLogs)
              pw.TableRow(
                children: [
                  pw.Text(callLog.name ?? "Unknown"),
                  pw.Text(callLog.number ?? ""),
                  pw.Text(callLog.callType.toString().split('.').last),
                  pw.Text(DateFormat('yyyy-MM-dd').format(
                      DateTime.fromMillisecondsSinceEpoch(callLog.timestamp!))),
                  pw.Text(DateFormat('HH:mm:ss').format(
                      DateTime.fromMillisecondsSinceEpoch(callLog.timestamp!))),
                  pw.Text('${callLog.duration} seconds'),
                ],
              ),
          ],
        ),
      ];
    }));

    final bytes = await pdf.save();

    return bytes;
  }

  Future<void> savePdfToStorage(Uint8List pdfBytes, String fileName) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir?.path}/$fileName.pdf');
      await file.writeAsBytes(pdfBytes);
      await OpenFile.open(file.path);
    }
  }

  Future<String> createTemporaryAudioFile(Uint8List uint8List) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/temp_audio.mp3');

    await file.writeAsBytes(uint8List);

    return file.path;
  }

  Future<void> shareSelectedCallLogsOnWhatsApp() async {
    List<CallLogEntry> selectedLogs = [];
    for (int i = 0; i < callLogs.length; i++) {
      if (selectedCallLogs[i]) {
        selectedLogs.add(callLogs[i]);
      }
    }

    if (selectedLogs.isEmpty) {
      return;
    }

    String callLogsText = '';

    for (var callLog in selectedLogs) {
      callLogsText += "Name: ${callLog.name ?? 'Unknown'}\n";
      callLogsText += "Number: ${callLog.number ?? ''}\n";

      callLogsText += "\n";
    }

    String encodedText = Uri.encodeComponent(callLogsText);

    String whatsappUrl = "whatsapp://send?text=$encodedText";

    launchUrlString(whatsappUrl);
  }
}
