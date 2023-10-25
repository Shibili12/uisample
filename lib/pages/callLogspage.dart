import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:call_log/call_log.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';

class CallLogsscreen extends StatefulWidget {
  const CallLogsscreen({super.key});

  @override
  State<CallLogsscreen> createState() => _CallLogsscreenState();
}

class _CallLogsscreenState extends State<CallLogsscreen> {
  List<CallLogEntry> callLogs = [];
  List<AudioPlayer> audioPlayers = [];
  List<PlatformFile> pickedFiles = [];
  List<bool> isPlaying = [];
  List<Duration> duration = [];
  List<Duration> position = [];
  int currentlyPlayingIndex = -1;
  late SharedPreferences preferences;
  late String username;

  @override
  void initState() {
    super.initState();
    _fetchCallLogs();
    getuser();
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
      });
    } else {
      // Handle the case where permission is denied by the user.
    }
  }

  Future<void> pickandstoreFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
        setState(() {
          pickedFiles = result.files;
        });
      }
    } catch (e) {}
  }

  void _playRecordings(PlatformFile pickedFil, int index) async {
    if (currentlyPlayingIndex == index) {
      audioPlayers[index].pause();
      setState(() {
        isPlaying[index] = false;
        currentlyPlayingIndex = -1;
      });
    } else {
      audioPlayers[index].play(DeviceFileSource(pickedFil.path!));
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
    final now = DateTime.now();
    // final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final year = DateFormat('y').format(now);
    final month = DateFormat('MMM').format(now);
    final day = DateFormat('d').format(now);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Call Logs"),
        actions: [
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
            Expanded(
              child: SizedBox(
                height: 700,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final callLog = callLogs[index];

                    return ExpansionTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      trailing: Wrap(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            _getFormattedDuration(callLog),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Icon(
                            Icons.call,
                            size: 20,
                            color: callLog.callType == CallType.incoming
                                ? Colors.blue
                                : callLog.callType == CallType.outgoing
                                    ? Colors.green
                                    : Colors.red,
                          ),
                        ],
                      ),
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                _playRecordings(pickedFiles[index], index);
                              },
                              icon: Icon(isPlaying[index]
                                  ? Icons.pause
                                  : Icons.play_arrow),
                            ),
                            Expanded(
                              flex: 6,
                              child: Slider(
                                min: 0,
                                max: duration[index].inSeconds.toDouble(),
                                value: position[index].inSeconds.toDouble(),
                                onChanged: (value) {
                                  seekAudio(index, value);
                                },
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Text(formattime(
                                    duration[index] - position[index]))),
                          ],
                        )
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: callLogs.length,
                ),
              ),
            ),
            pickedFiles.isEmpty
                ? SizedBox(
                    height: 100,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: ElevatedButton(
                          onPressed: () {
                            pickandstoreFiles();
                            print(pickedFiles.length);
                          },
                          child: const Text("data")),
                    ),
                  )
                : const SizedBox(),
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
}
