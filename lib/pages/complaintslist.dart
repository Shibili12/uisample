import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uisample/model/complaints.dart';
import 'package:uisample/pages/complaintpage.dart';

class Complaintslist extends StatefulWidget {
  const Complaintslist({super.key});

  @override
  State<Complaintslist> createState() => _ComplaintslistState();
}

class _ComplaintslistState extends State<Complaintslist> {
  List<Complaint> complaints = [];
  late Box<Complaint> complaintBox;
  List<AudioPlayer> audioPlayer = [];
  List<bool> isPlaying = [];
  List<Duration> duration = [];
  List<Duration> position = [];
  int currentlyPlayingIndex = -1;

  void retrieveComplaints() async {
    complaintBox = await Hive.openBox('complaints');
    List<Complaint> retrievedcomplaints = complaintBox.values.toList();
    setState(() {
      complaints = retrievedcomplaints;
      audioPlayer = List.generate(complaints.length, (index) => AudioPlayer());
      isPlaying = List.generate(complaints.length, (index) => false);
      duration = List.generate(complaints.length, (index) => Duration());
      position = List.generate(complaints.length, (index) => Duration());
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveComplaints();
  }

  void playAudio(String audioPath, int index) {
    // Listen for player state changes
    audioPlayer[index].onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying[index] = state == PlayerState.playing;
      });
    });

    // Listen for player position changes
    audioPlayer[index].onPositionChanged.listen((Duration newPosition) {
      setState(() {
        position[index] = newPosition;
      });
    });

    // Listen for player duration changes
    audioPlayer[index].onDurationChanged.listen((Duration newDuration) {
      setState(() {
        duration[index] = newDuration;
      });
    });
    audioPlayer[index].play(DeviceFileSource(audioPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Complaints"),
        elevation: 0,
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final year = DateFormat('y').format(DateTime.now());
          final month = DateFormat('MMM').format(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(complaints[index].id!)));
          final day = DateFormat('d').format(
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(complaints[index].id!)));

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
            title: Text(complaints[index].name),
            subtitle: Text(complaints[index].remarks),
            children: [
              TextButton(
                onPressed: () async {
                  final output =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (contex) => Complaintpage(
                                complaints: [complaints[index]],
                              )));
                  if (output) {
                    retrieveComplaints();
                  }
                },
                child: Text("Edit"),
              ),
              complaints[index].audiopath == null
                  ? SizedBox(
                      child: Center(
                        child: Text("No audio"),
                      ),
                    )
                  : Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            playAudio(complaints[index].audiopath!, index);
                            print("audio:" +
                                complaints[index].audiopath.toString());
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
                            value: position[index]
                                .inSeconds
                                .toDouble()
                                .clamp(0, duration[index].inSeconds.toDouble()),
                            onChanged: (value) {
                              seekAudio(index, value);
                            },
                          ),
                        ),
                      ],
                    )
            ],
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: complaints.length,
      ),
    );
  }

  Future<void> seekAudio(int index, double value) async {
    final positionDuration = Duration(seconds: value.toInt());
    await audioPlayer[index].seek(positionDuration);
  }
}
