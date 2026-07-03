import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/pages/chats/widgets/chat_list_widget.dart';
import 'package:realtimekit_ui/src/pages/chats/widgets/input_bar_widget.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_app_bar.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chatPermissions = rtkMeeting.permissions.chat;
    return Scaffold(
      appBar: RtkAppBar(
        backgroundColor: globalDesignToken.colorToken.backgroundColor.shade1000,
        title: RtkText(RtkStrings.chat),
        hasLeading: false,
        actions: [
          IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(DyteIcons.dismiss),
          )
        ],
      ),
      backgroundColor: globalDesignToken.colorToken.backgroundColor.shade1000,
      body: Column(
        children: [
          const Expanded(child: ChatListWidget()),
          if (chatPermissions.canSendFiles || chatPermissions.canSendText)
            const InputBarWidget(),
        ],
      ),
    );
  }
}
