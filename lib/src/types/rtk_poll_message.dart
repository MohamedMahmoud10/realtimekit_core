// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:realtimekit_core_platform_interface/src/utils/int_to_bool_convertor.dart';

class Poll {
  final String id;
  final String question;
  final bool anonymous;
  final bool hideVotes;
  final String createdBy;
  final List<PollOption> options;
  final List<String> voted;
  Poll({
    required this.id,
    required this.question,
    required this.anonymous,
    required this.hideVotes,
    required this.createdBy,
    required this.options,
    required this.voted,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'question': question,
      'anonymous': anonymous,
      'hideVotes': hideVotes,
      'createdBy': createdBy,
      'options': options.map((x) => x.toMap()).toList(),
      'voted': voted,
    };
  }

  factory Poll.fromMap(Map<String, dynamic> map) {
    return Poll(
      id: map['id'],
      question: map['question'],
      anonymous: decodeBool(map['anonymous']),
      hideVotes: decodeBool(map['hideVotes']),
      createdBy: map['createdBy'],
      options: List<PollOption>.from(
          map['options'].map((x) => PollOption.fromMap(x))),
      voted: List<String>.from(map['voted']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Poll.fromJson(String source) => Poll.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PollMessage(id: $id, question: $question, anonymous: $anonymous, hideVotes: $hideVotes, createdBy: $createdBy, options: $options, voted: $voted)';
  }

  @override
  bool operator ==(covariant Poll other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.question == question &&
        other.anonymous == anonymous &&
        other.hideVotes == hideVotes &&
        other.createdBy == createdBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        question.hashCode ^
        anonymous.hashCode ^
        hideVotes.hashCode ^
        createdBy.hashCode ^
        options.hashCode;
  }
}

class PollOption {
  final String text;
  final List<PollVote> votes;
  final int count;
  PollOption({
    required this.text,
    required this.votes,
    required this.count,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'votes': votes.map((x) => x.toMap()).toList(),
      'count': count,
    };
  }

  factory PollOption.fromMap(Map<String, dynamic> map) {
    return PollOption(
      text: map['text'],
      votes: List<PollVote>.from(map['votes'].map((x) => PollVote.fromMap(x))),
      count: map['count']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PollOption.fromJson(String source) =>
      PollOption.fromMap(json.decode(source));
}

class PollVote {
  final String id;
  final String name;

  PollVote({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory PollVote.fromMap(Map<String, dynamic> map) {
    return PollVote(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PollVote.fromJson(String source) =>
      PollVote.fromMap(json.decode(source));
}
