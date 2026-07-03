import 'package:realtimekit_ui/src/localization/app_local.dart';

import 'localization/arb_to_map.dart';

class RtkStrings {
  final String? arbPath;
  RtkStrings({this.arbPath});
  static RtkLocalization _localizations = RtkLocalization();

  Future<void> init() async {
    final loc = await Localize().init(arbPath!);
    _localizations = RtkLocalization(loc);
  }

  static String get locale => _localizations.locale;

  static String get back => _localizations.back;
  static String get waitingForTheHostToLetYouIn =>
      _localizations.waitingForTheHostToLetYouIn;
  static String get join => _localizations.join;
  static String get joinInAs => _localizations.joinInAs;
  static String get enterYourName => _localizations.enterYourName;
  static String get micOn => _localizations.micOn;
  static String get micOff => _localizations.micOff;
  static String get leave => _localizations.leave;
  static String get cancel => _localizations.cancel;
  static String get areYouSureYouWantToLeaveTheCall =>
      _localizations.areYouSureYouWantToLeaveTheCall;
  static String get more => _localizations.more;
  static String get selectAudioDevice => _localizations.selectAudioDevice;
  static String get selectVideoDevice => _localizations.selectVideoDevice;
  static String get videoOn => _localizations.videoOn;
  static String get videoOff => _localizations.videoOff;
  static String get mute => _localizations.mute;
  static String get unmute => _localizations.unmute;
  static String get unpin => _localizations.unpin;
  static String get pin => _localizations.pin;
  static String get kick => _localizations.kick;
  static String get removeFromStage => _localizations.removeFromStage;
  static String get inviteToStage => _localizations.inviteToStage;
  static String get screenShare => _localizations.screenShare;
  static String get plugins => _localizations.plugins;
  static String get createPoll => _localizations.createPoll;
  static String get question => _localizations.question;
  static String get askAQuestion => _localizations.askAQuestion;
  static String get options => _localizations.options;
  static String get enterAnOption => _localizations.enterAnOption;
  static String get addOption => _localizations.addOption;
  static String get anonymous => _localizations.anonymous;
  static String get hideResultsBeforeVoting =>
      _localizations.hideResultsBeforeVoting;
  static String get questionAndOptionsCantBeEmpty =>
      _localizations.questionAndOptionsCantBeEmpty;
  static String get polls => _localizations.polls;
  static String get pollBy => _localizations.pollBy;
  static String get vote => _localizations.vote;
  static String get voted => _localizations.voted;
  static String get viewVoters => _localizations.viewVoters;
  static String get stopRecording => _localizations.stopRecording;
  static String get startRecording => _localizations.startRecording;
  static String get muteAll => _localizations.muteAll;
  static String get disableAllVideos => _localizations.disableAllVideos;
  static String get settings => _localizations.settings;
  static String get rec => _localizations.rec;
  static String get camera => _localizations.camera;
  static String get microphoneInput => _localizations.microphoneInput;
  static String get chat => _localizations.chat;
  static String get noMessages => _localizations.noMessages;
  static String get chatMessagesWillAppearHere =>
      _localizations.chatMessagesWillAppearHere;
  static String get file => _localizations.file;
  static String get image => _localizations.image;
  static String get send => _localizations.send;
  static String get participants => _localizations.participants;
  static String get waitlisted => _localizations.waitlisted;
  static String get inCall => _localizations.inCall;
  static String get you => _localizations.you;
  static String get turnOffVideo => _localizations.turnOffVideo;
  static String get videoAlreadyOff => _localizations.videoAlreadyOff;
  static String get shareScreen => _localizations.shareScreen;
  static String get stopSharing => _localizations.stopSharing;
  static String get endMeetingForAll => _localizations.endMeetingForAll;
  static String get message => _localizations.message;
  static String get newPollCreated => _localizations.newPollCreated;
  static String get waitingToGoLive => _localizations.waitingToGoLive;
  static String get frontCamera => _localizations.frontCamera;
  static String get rearCamera => _localizations.rearCamera;
  static String get externalCamera => _localizations.externalCamera;
  static String get headset => _localizations.headset;
  static String get speaker => _localizations.speaker;
  static String get bluetooth => _localizations.bluetooth;
  static String get earpiece => _localizations.earpiece;
}
