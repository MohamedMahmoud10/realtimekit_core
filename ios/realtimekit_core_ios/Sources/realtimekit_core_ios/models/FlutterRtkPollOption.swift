import RealtimeKitFlutterCoreKMM

class FlutterRtkPollOption {
    static func fromMap(pollOption: [String: Any?]) -> CorePollOption {
        let _votes = (pollOption["votes"] as? [[String: Any?]]) ?? []
        let _pollVotes: [CorePollVote] = _votes.map { FlutterRtkPollVote.fromMap(vote: $0) }

        return CorePollOption(text: (pollOption["text"] as? String) ?? "", votes: _pollVotes, count: Int32((pollOption["count"] as? Int) ?? 0))
    }
}
