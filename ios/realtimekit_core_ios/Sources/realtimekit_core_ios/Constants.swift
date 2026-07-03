//
//  Constants.swift
//  dyte_core_ios
//
//  Created by Saksham Gupta on 10/03/23.
//

import Foundation

func getFunctionName(funct: String) -> String {
    let ch = Character("(")
    let result = funct.split(separator: ch)
    let name = String(result[0])
    return name
}

let meetingRoomNotification = "attached-room-event-listener"
let chatNotification = "attached-chat-event-listener"
let participantNotification = "attached-participant-event-listener"
let selfParticipantNotification = "attached-self-participant-listener"
let pluginNotification = "attached-plugin-event-listener"
let pollNotification = "attached-poll-event-listener"
let recordingNotification = "attached-recording-event-listener"
let waitlistNotification = "attached-waitlist-event-listener"
let livestreamNotification = "attached-livestream-event-listener"
let dataUpdateNotification = "attached-data-update-event-listener"
let stageNotification = "attached-stage-event-listener"
let participantUpdateNotification = "attached-participant-update-event-listener"

let meetingRoomEventChannelName = "com.cloudflare.realtimekit/meetingRoomEvents"
let chatsEventChannelName = "com.cloudflare.realtimekit/chats"
let participantEventChannelName = "com.cloudflare.realtimekit/participants"
let selfParticipantChannelName = "com.cloudflare.realtimekit/self"
let pluginEventsChannelName = "com.cloudflare.realtimekit/plugins"
let pollEventsChannelName = "com.cloudflare.realtimekit/polls"
let recordingEventsChannelName = "com.cloudflare.realtimekit/recording"
let waitlistEventsChannelName = "com.cloudflare.realtimekit/waitlist"
let livestreamEventsChannelName = "com.cloudflare.realtimekit/livestream"
let dataEventsChannelName = "com.cloudflare.realtimekit/data"
let stageEventsChannelName = "com.cloudflare.realtimekit/stage"
let participantUpdateChannelName = "com.cloudflare.realtimekit/participantUpdate"
