import 'package:dyte_icons/dyte_icons.dart';
import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/widgets/utils/clean_pop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [DyteReleaseResourceButton] widget is to be used when client exits the SDK
/// before joining room such as waiting room or setup screen.
class RtkReleaseResourcesButton extends ConsumerStatefulWidget {
  const RtkReleaseResourcesButton({super.key});

  @override
  ConsumerState<RtkReleaseResourcesButton> createState() =>
      _RtkReleaseResourcesButtonState();
}

class _RtkReleaseResourcesButtonState
    extends ConsumerState<RtkReleaseResourcesButton> {
  late bool _isReleaseCalled;
  @override
  void initState() {
    _isReleaseCalled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _isReleaseCalled
          ? null
          : () async {
              if (_isReleaseCalled) {
                return;
              }
              setState(() {
                _isReleaseCalled = true;
              });
              await RtkUtils(context).leave(ref, release: true);
              setState(() {
                _isReleaseCalled = false;
              });
            },
      icon: _isReleaseCalled
          ? CircularProgressIndicator(
              strokeWidth: 2,
              color: globalDesignToken.colorToken.textColor.shade800,
            )
          : const Icon(DyteIcons.dismiss),
    );
  }
}
