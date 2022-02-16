import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotmies_partner/call_ui/components/rounded_button.dart';
import 'package:spotmies_partner/providers/chat_provider.dart';
import 'package:spotmies_partner/providers/theme_provider.dart';

// import '../constants.dart';
import '../size.config.dart';

class CallingUi extends StatefulWidget {
  CallingUi(
      {@required this.isInComingScreen,
      this.image = "",
      this.name = "unknown",
      this.onAccept,
      this.onHangUp,
      this.onMic,
      this.onReject,
      this.onSpeaker});
  final bool? isInComingScreen;
  final String? image;
  final String? name;
  final Function? onAccept;
  final Function? onReject;
  final Function? onHangUp;
  final Function? onMic;
  final Function? onSpeaker;

  @override
  _CallingUiState createState() => _CallingUiState();
}

class _CallingUiState extends State<CallingUi> {
  ChatProvider? chatProvider;
  String screenType = '';
  bool clickMic = false;
  bool clickSpeaker = false;
  callStatus(state) {
    switch (state) {
      case 0:
        return "connecting...";
      case 1:
        return "Calling...";
      case 2:
        return "Ringing...";
      case 3:
        return "Connected";
      case 6:
        return "Terminated....";
      default:
        return "connecting...";
    }
  }

  changeScreen(screenName) {
    setState(() {
      screenType = screenName;
    });
  }

  String formatedTime(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        getParsedTime(min.toString()) + ":" + getParsedTime(sec.toString());

    return parsedTime;
  }

  @override
  initState() {
    setState(() {
      screenType = (widget.isInComingScreen!) ? "incoming" : "outgoing";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Consumer<ChatProvider>(builder: (context, data, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Uri.parse(widget.image!).isAbsolute //need to put url validator
                ? Image.network(
                    widget.image!,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/full_image.png",
                    fit: BoxFit.cover,
                  ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: SpotmiesTheme.onBackground.withOpacity(0.3),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name!,
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          ?.copyWith(color: SpotmiesTheme.background),
                    ),
                    VerticalSpacing(of: 10),
                    Text(
                      screenType == "outgoing"
                          ? "Duration ${formatedTime(data.duration)}   ${callStatus(data.getCallStatus)}"
                              .toUpperCase()
                          : "INCOMING CALL.....",
                      style: TextStyle(
                          color: SpotmiesTheme.background.withOpacity(60)),
                    ),
                    Spacer(),
                    Visibility(
                      visible: screenType == "outgoing",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: !clickMic
                                    ? SpotmiesTheme.background
                                    : Colors.indigoAccent,
                                shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  clickMic = !clickMic;
                                });
                                widget.onMic!(clickMic);
                              },
                              icon: Icon(
                                Icons.mic,
                                color: !clickMic
                                    ? SpotmiesTheme.secondaryVariant
                                    : SpotmiesTheme.background,
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () {
                                widget.onHangUp!();
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.call_end,
                                color: SpotmiesTheme.background,
                              ),
                            ),
                          ),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                color: !clickSpeaker
                                    ? SpotmiesTheme.background
                                    : Colors.indigoAccent,
                                shape: BoxShape.circle),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  clickSpeaker = !clickSpeaker;
                                });
                                widget.onSpeaker!(clickSpeaker);
                              },
                              icon: Icon(
                                Icons.volume_up,
                                color: !clickSpeaker
                                    ? SpotmiesTheme.secondaryVariant
                                    : SpotmiesTheme.background,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: screenType == "incoming",
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RoundedButton(
                            press: () {
                              changeScreen("outgoing");
                              widget.onAccept!();
                            },
                            color: Colors.green,
                            iconColor: Colors.white,
                            iconSrc: "assets/icons/call_accept.svg",
                          ),
                          RoundedButton(
                            press: () {
                              widget.onReject!();
                              Navigator.pop(context);
                            },
                            color: Colors.red,
                            iconColor: Colors.white,
                            iconSrc: "assets/icons/call_end.svg",
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
