import 'package:realtimekit_core_platform_interface/realtimekit_core_platform_interface.dart';

abstract class RtkDataEventListener extends RtkListener {
  void onSelfPermissionsUpdate(SelfPermissions permissions) {}
  void onMetaUpdate(
      String meetingId,
      String meetingTitle,
      String meetingStartedTimestamp,
      RtkMeetingType meetingType,
      RtkDesignTokens designToken) {}
  void onPluginUpdate(List<RtkPlugin> plugin) {}
  void onScreenShareUpdate(List<RtkRemoteParticipant> screenShares) {}
  void onLivestreamUpdate(RtkLivestreamData livestreamData) {}
}

class RtkDataController extends RtkDataEventListener {
  RtkDataController._();

  static final RtkDataController instance = RtkDataController._();

  RtkMeta _rtkMeta = RtkMeta(
    meetingId: 'meetingId',
    meetingTitle: 'roomTitle',
    meetingStartedTimeStamp: 'meetingStartedTimeStamp',
    meetingType: RtkMeetingType.groupCall,
    designToken: RtkDesignTokens(),
  );

  late SelfPermissions _rtkPermissions;

  SelfPermissions get permissions => _rtkPermissions;

  RtkMeta get meta => _rtkMeta;

  List<RtkPlugin> _rtkPlugins = [];

  List<RtkPlugin> get plugins => _rtkPlugins;

  List<RtkMeetingParticipant> _rtkScreenShares = [];

  List<RtkMeetingParticipant> get screenShares => _rtkScreenShares;

  @override
  void onSelfPermissionsUpdate(SelfPermissions permissions) {
    _rtkPermissions = permissions;
  }

  @override
  void onMetaUpdate(
      String meetingId,
      String meetingTitle,
      String meetingStartedTimestamp,
      RtkMeetingType meetingType,
      RtkDesignTokens designToken) {
    _rtkMeta = RtkMeta(
      meetingId: meetingId,
      meetingTitle: meetingTitle,
      meetingStartedTimeStamp: meetingStartedTimestamp,
      meetingType: meetingType,
      activeTab: meta.activeTab,
      designToken: designToken,
    );
  }

  @override
  void onPluginUpdate(List<RtkPlugin> plugin) {
    _rtkPlugins = plugin;
  }

  @override
  void onScreenShareUpdate(List<RtkMeetingParticipant> screenShares) {
    _rtkScreenShares = screenShares;
  }

  void dispose() {
    _rtkMeta = RtkMeta(
      meetingId: 'meetingId',
      meetingTitle: 'roomTitle',
      meetingStartedTimeStamp: 'meetingStartedTimeStamp',
      meetingType: RtkMeetingType.groupCall,
      designToken: RtkDesignTokens(),
    );
    _rtkPlugins = [];
    _rtkScreenShares = [];
  }
}
