import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/realtimekit_ui.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/di/riverpod_di.dart';
import 'package:realtimekit_ui/src/routes/router.dart';
import 'package:realtimekit_ui/src/strings.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_app_bar.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_icon_button.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_list_tile.dart';
import 'package:realtimekit_ui/src/widgets/atoms/rtk_text.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RtkPluginsScreen extends ConsumerWidget {
  const RtkPluginsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plugins = rtkMeeting.plugins.all;
    return Scaffold(
      appBar: RtkAppBar(
        title: RtkText(RtkStrings.plugins),
        hasLeading: false,
        actions: [
          IconButton(
              onPressed: Navigator.of(context).pop,
              icon: const Icon(DyteIcons.dismiss))
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: vspace1.height!,
          ),
          height: context.height * 0.8,
          child: ListView.builder(
            itemCount: plugins.length,
            itemBuilder: (context, index) {
              final plugin = plugins[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: RtkListTile(
                  tileColor: Colors.transparent,
                  leading: Image.network(plugin.picture),
                  title: RtkText(plugin.name),
                  trailing: rtkMeeting.permissions.plugin.canLaunch
                      ? RtkPluginLauncherWidget(plugin: plugin)
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class RtkPluginLauncherWidget extends ConsumerWidget {
  final RtkPlugin plugin;
  const RtkPluginLauncherWidget({
    required this.plugin,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isPluginLaunched = ref.watch(
      pluginProvider.select(
        (plugins) => plugins.any((plugin) => plugin.id == this.plugin.id),
      ),
    );
    return ((isPluginLaunched && rtkMeeting.permissions.plugin.canClose) ||
            (!isPluginLaunched && rtkMeeting.permissions.plugin.canLaunch))
        ? RtkIconButton(
            icon: Icon(isPluginLaunched ? DyteIcons.dismiss : DyteIcons.rocket),
            onPressed: () {
              isPluginLaunched ? plugin.deactivate() : plugin.activate();
              RtkRouter.of(context).pop();
            },
          )
        : const SizedBox.shrink();
  }
}
