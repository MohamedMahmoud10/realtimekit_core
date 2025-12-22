import 'package:realtimekit_core/realtimekit_core.dart';
import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PluginViewerWidget extends ConsumerStatefulWidget {
  const PluginViewerWidget(this.plugin, {super.key});

  final RtkPlugin plugin;

  @override
  ConsumerState createState() => _PluginWidgetState();
}

class _PluginWidgetState extends ConsumerState<PluginViewerWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          if (rtkMeeting.permissions.plugin.canClose)
            Container(
                height: 36,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColorSwatch.shade800,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: brandColorSwatch.shade500,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: 32,
                        width: 32,
                        child: Center(
                          child: IconButton(
                            constraints: const BoxConstraints(
                              maxHeight: 32,
                              maxWidth: 32,
                            ),
                            icon: const Icon(
                              DyteIcons.dismiss,
                              opticalSize: 16,
                              size: 16,
                            ),
                            onPressed: widget.plugin.deactivate,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          SizedBox(
            height: context.height * 0.6,
            child: InteractiveViewer(
              child: PluginView(widget.plugin),
            ),
          ),
        ],
      ),
    );
  }
}
