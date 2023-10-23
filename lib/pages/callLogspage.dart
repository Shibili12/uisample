import 'package:audioplayers/audioplayers.dart';
import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class CallLogsscreen extends StatefulWidget {
  const CallLogsscreen({super.key});

  @override
  State<CallLogsscreen> createState() => _CallLogsscreenState();
}

class _CallLogsscreenState extends State<CallLogsscreen> {
  List<CallLogEntry> callLogs = [];
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _fetchCallLogs();
  }

  Future<void> _fetchCallLogs() async {
    final status = await Permission.phone.request();
    if (status.isGranted) {
      callLogs = (await CallLog.get()).toList();
      setState(() {});
    } else {
      // Handle the case where permission is denied by the user.
    }
  }

  Future<void> _playRecordings(String filepath) async {
    await audioPlayer.stop();
    final result = await audioPlayer.play;
    if (result == 1) {}
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
        title: Text("Call Logs"),
      ),
      body: SafeArea(
        child: ListView.separated(
          itemBuilder: (context, index) {
            final callLog = callLogs[index];
            final recordingFilePath =
                "/storage/emulated/0/CallRecordings/call1.mp3";
            return ListTile(
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
              subtitle: Text(callLog.number ?? ""),
              trailing: Wrap(
                direction: Axis.vertical,
                children: [
                  Text(
                    _getFormattedDuration(callLog),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
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
              onTap: () {
                _playRecordings(recordingFilePath);
              },
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: callLogs.length,
        ),
      ),
    );
  }
}
