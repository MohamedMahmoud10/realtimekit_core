import 'package:http/http.dart' as http;
import 'package:example/models/either.dart';
import 'package:example/models/failure.dart';
import 'package:example/models/meeting.dart';
import 'package:example/models/participant.dart';

typedef MeetingOrFailure = Either<Failure, Meeting>;
typedef ParticipantOrFailure = Either<Failure, Participant>;

class RtkApiClient {
  Future<MeetingOrFailure> createMeeting(
    CreateMeetingRequest meetingRequest,
  ) async {
    try {
      final meetingResponse = await http.post(
        Uri.parse('https://meet.dyte.io/api/v2/meetings'),
        body: meetingRequest.toJson(),
      );
      if (meetingResponse.statusCode >= 200 &&
          meetingResponse.statusCode < 300) {
        return right(Meeting.fromJson(meetingResponse.body));
      } else {
        return left(Failure("Error: ${meetingResponse.statusCode}"));
      }
    } catch (e) {
      return left(Failure("Error: $e"));
    }
  }

  Future<ParticipantOrFailure> createParticipant(
    CreateParticipantRequest participantRequest,
    String meetingId,
  ) async {
    try {
      final meetingResponse = await http.post(
        Uri.parse('https://meet.dyte.io/api/v2/participants'),
        body: participantRequest.toJson(),
      );
      return right(Participant.fromJson(meetingResponse.body));
    } catch (e) {
      return left(Failure("Error: $e"));
    }
  }
}
