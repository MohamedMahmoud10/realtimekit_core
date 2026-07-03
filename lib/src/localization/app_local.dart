import 'package:realtimekit_ui/src/localization/arb_to_map.dart';

class RtkLocalization {
  String _locale = 'en';
  Map<String, String>? _localizedStrings;
  RtkLocalization([Localize? localize]) {
    if (localize != null) {
      _localizedStrings = localize.arbToMap();
      _locale = localize.locale;
    }
  }

  String? _getLocalString(String key) {
    if (_localizedStrings == null) return null;
    if (_localizedStrings!.containsKey(key)) {
      return _localizedStrings![key];
    }
    return null;
  }

  String get locale => _locale;

  String get join => _getLocalString("join") ?? 'Join';

  String get joinInAs => _getLocalString("joinInAs") ?? 'Join in as';

  String get enterYourName =>
      _getLocalString("enterYourName") ?? 'Enter your name';

  String get micOn => _getLocalString("micOn") ?? 'Mic On';

  String get micOff => _getLocalString("micOff") ?? 'Mic Off';

  String get leave => _getLocalString("leave") ?? 'Leave';

  String get cancel => _getLocalString("cancel") ?? 'Cancel';

  String get areYouSureYouWantToLeaveTheCall =>
      _getLocalString("areYouSureYouWantToLeaveTheCall") ??
      'Are you sure you want to leave the call?';

  String get more => _getLocalString("more") ?? 'more';

  String get selectAudioDevice =>
      _getLocalString("selectAudioDevice") ?? 'Select Audio Device';

  String get selectVideoDevice =>
      _getLocalString("selectVideoDevice") ?? 'Select Video Device';

  String get videoOn => _getLocalString("videoOn") ?? 'Video On';

  String get videoOff => _getLocalString("videoOff") ?? 'Video Off';

  String get mute => _getLocalString("mute") ?? 'Mute';

  String get unmute => _getLocalString("unmute") ?? 'Muted';

  String get unpin => _getLocalString("unpin") ?? 'Unpin';

  String get pin => _getLocalString("pin") ?? 'Pin';

  String get kick => _getLocalString("kick") ?? 'Kick';

  String get removeFromStage =>
      _getLocalString("removeFromStage") ?? 'Remove from stage';

  String get inviteToStage =>
      _getLocalString("inviteToStage") ?? 'Invite to stage';

  String get screenShare => _getLocalString("screenShare") ?? 'Screen Share';

  String get plugins => _getLocalString("plugins") ?? 'Plugins';

  String get createPoll => _getLocalString("createPoll") ?? 'Create Poll';

  String get question => _getLocalString("question") ?? 'Question';

  String get askAQuestion =>
      _getLocalString("askAQuestion") ?? 'Ask a question';

  String get options => _getLocalString("options") ?? 'Options';

  String get enterAnOption =>
      _getLocalString("enterAnOption") ?? 'Enter an option';

  String get addOption => _getLocalString("addOption") ?? 'Add an Option';

  String get anonymous => _getLocalString("anonymous") ?? 'Anonymous';

  String get hideResultsBeforeVoting =>
      _getLocalString("hideResultsBeforeVoting") ??
      'Hide Results before voting';

  String get questionAndOptionsCantBeEmpty =>
      _getLocalString("questionAndOptionsCantBeEmpty") ??
      'Question and options can\'t be empty!';

  String get polls => _getLocalString("polls") ?? 'Polls';

  String get pollBy => _getLocalString("pollBy") ?? 'Poll by';

  String get vote => _getLocalString("vote") ?? 'Vote';

  String get voted => _getLocalString("voted") ?? 'Voted';

  String get viewVoters => _getLocalString("viewVoters") ?? 'View Voters';

  String get stopRecording =>
      _getLocalString("stopRecording") ?? 'Stop Recording';

  String get startRecording =>
      _getLocalString("startRecording") ?? 'Start Recording';

  String get muteAll => _getLocalString("muteAll") ?? 'Mute All';

  String get disableAllVideos =>
      _getLocalString("disableAllVideos") ?? 'Disable all videos';

  String get settings => _getLocalString("settings") ?? 'Settings';

  String get rec => _getLocalString("rec") ?? 'REC';

  String get camera => _getLocalString("camera") ?? 'Camera';

  String get microphoneInput =>
      _getLocalString("microphoneInput") ?? 'Microphone (input)';

  String get chat => _getLocalString("chat") ?? 'Chat';

  String get noMessages => _getLocalString("noMessages") ?? 'No messages';

  String get chatMessagesWillAppearHere =>
      _getLocalString("chatMessagesWillAppearHere") ??
      'Chat messages will appear here';

  String get file => _getLocalString("file") ?? 'File';

  String get image => _getLocalString("image") ?? 'Image';

  String get send => _getLocalString("send") ?? 'Send';

  String get participants => _getLocalString("participants") ?? 'Participants';

  String get waitlisted => _getLocalString("waitlisted") ?? 'Waitlisted';

  String get inCall => _getLocalString("inCall") ?? 'In Call';

  String get you => _getLocalString("you") ?? 'you';

  String get turnOffVideo =>
      _getLocalString("turnOffVideo") ?? 'Turn off video';

  String get videoAlreadyOff =>
      _getLocalString("videoAlreadyOff") ?? 'Video already off';

  String get rtk => _getLocalString("rtk") ?? 'Rtk';

  String get back => _getLocalString("back") ?? 'Back';

  String get waitingForTheHostToLetYouIn =>
      _getLocalString("waitingForTheHostToLetYouIn") ??
      'Wait for the host to let you in!';

  String get shareScreen => _getLocalString("shareScreen") ?? "Share Screen";

  String get stopSharing => _getLocalString("stopSharing") ?? "Stop Sharing";

  String get endMeetingForAll =>
      _getLocalString("endMeetingForAll") ?? "End Meeting for All";

  String get message => _getLocalString("message") ?? "Message";

  String get newPollCreated =>
      _getLocalString("newPollCreated") ?? "New Poll created";

  String get waitingToGoLive =>
      _getLocalString("waitingToGoLive") ?? "Waiting to go live";

  String get frontCamera => _getLocalString("frontCamera") ?? "Front Camera";

  String get rearCamera => _getLocalString("rearCamera") ?? "Rear Camera";

  String get externalCamera =>
      _getLocalString("externalCamera") ?? "External Camera";

  String get headset => _getLocalString("headset") ?? "Headset";

  String get speaker => _getLocalString("speaker") ?? "Speaker";

  String get bluetooth => _getLocalString("bluetooth") ?? "Bluetooth";

  String get earpiece => _getLocalString("earpiece") ?? "Earpiece";
}
