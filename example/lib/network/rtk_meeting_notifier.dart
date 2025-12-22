import 'package:example/models/either.dart';
import 'package:example/models/meeting.dart';
import 'package:example/models/participant.dart';
import 'package:example/models/response.dart';
import 'package:example/network/rtk_api_client.dart';
import 'package:flutter/material.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/providers.dart';

class RtkMeetingNotifier extends Notifier<AppResponse<RtkMeetingInfo>> {
  RtkMeetingNotifier(this._apiClient);

  @override
  AppResponse<RtkMeetingInfo> build() => Initial();

  final RtkApiClient _apiClient;

  Future<void> createMeetingAndAddParticipant(
    String meetingTitle,
    String participantName,
  ) async {
    state = Loading();
    final meetingRequest = CreateMeetingRequest.fromMeetingTitle(meetingTitle);
    final meeting = await _apiClient.createMeeting(meetingRequest);

    switch (meeting) {
      case Right():
        final meetingResponse = meeting.value;
        final participantRequest = CreateParticipantRequest.fromName(
          participantName,
          meetingResponse.id,
        );
        final participant = await _apiClient.createParticipant(
          participantRequest,
          meetingResponse.id,
        );
        switch (participant) {
          case Left():
            state = Error(participant.value.message);
            break;
          case Right():
            final participantResponse = participant.value;
            final useCloudflare = ref.read(isCloudflareProvider);
            final info =
                useCloudflare
                    ? RtkMeetingInfo(
                      authToken: participantResponse.token,
                      baseDomain: 'realtime.cloudflare.com',
                    )
                    : RtkMeetingInfo(authToken: participantResponse.token);
            state = Success(info);
            break;
        }
      case Left():
        state = Error(meeting.value.message);
        break;
    }
  }

  Future<void> addParticipant(String meetingId, String participantName) async {
    state = Loading();
    final participantRequest = CreateParticipantRequest.fromName(
      participantName,
      meetingId,
    );
    final participant = await _apiClient.createParticipant(
      participantRequest,
      meetingId,
    );
    switch (participant) {
      case Left():
        state = Error(participant.value.message);
        break;
      case Right():
        final participantResponse = participant.value;
        final useCloudflare = ref.read(isCloudflareProvider);
        final info =
            useCloudflare
                ? RtkMeetingInfo(
                  authToken: participantResponse.token,
                  baseDomain: 'realtime.cloudflare.com',
                )
                : RtkMeetingInfo(authToken: participantResponse.token);
        state = Success(info);
        break;
    }
  }

  Future<void> initWithAuthToken(String authToken) async {
    final useCloudflare = ref.read(isCloudflareProvider);
    final info =
        useCloudflare
            ? RtkMeetingInfo(
              authToken: authToken,
              baseDomain: 'realtime.cloudflare.com',
            )
            : RtkMeetingInfo(
              authToken: authToken,
              customAppBarWidget: Image.asset(
                'assets/logo.png',
                height: 32,
              ),
            );
    state = Success(info);
  }

  void reset() {
    state = Initial();
  }
}

final rtkMeetingProvider =
    NotifierProvider<RtkMeetingNotifier, AppResponse<RtkMeetingInfo>>(
      () => RtkMeetingNotifier(RtkApiClient()),
    );
