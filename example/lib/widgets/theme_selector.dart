import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/network/rtk_theme_notifier.dart';
import 'package:example/widgets/custom_painter_widget.dart';

class ThemeSelectorWidget extends ConsumerWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(rtkThemeProvider);
    final configurations = ref.watch(rtkThemeProvider.notifier).configurations;
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: configurations.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () {
              ref
                  .read(rtkThemeProvider.notifier)
                  .selectConfiguration(configurations[index].id);
            },
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Transform.rotate(
                angle: 15,
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CustomPainterWidget(
                    color1: configurations[index]
                        .colorToken
                        .brandColor
                        .shade500,
                    color2: configurations[index]
                        .colorToken
                        .backgroundColor
                        .shade1000,
                    borderColor: configurations[index].isSelected
                        ? Colors.white
                        : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
