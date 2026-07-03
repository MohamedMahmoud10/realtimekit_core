import RealtimeKitFlutterCoreKMM

enum FlutterRtkPollVote {
    static func fromMap(vote: [String: Any?]) -> CorePollVote {
        return CorePollVote(id: (vote["id"] as? String) ?? "", name: (vote["name"] as? String) ?? "")
    }
}
