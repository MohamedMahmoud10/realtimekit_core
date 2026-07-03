import 'package:realtimekit_ui/src/di/di.dart';
import 'package:realtimekit_ui/src/tokens/size/size_util.dart';
import 'package:realtimekit_ui/src/tokens/theme.dart';
import 'package:realtimekit_ui/src/widgets/atoms/vh_space.dart';
import 'package:realtimekit_ui/src/widgets/molecules/rtk_shimmer_widget.dart';
import 'package:flutter/material.dart';

class EmptyPollsWidget extends StatelessWidget {
  const EmptyPollsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          const RtkPollsBaseWidget(),
          Positioned(
            left: context.width * 0.2,
            bottom: context.height * 0.3,
            child: const RtkPollsBaseWidget(),
          ),
        ],
      ),
    );
  }
}

class RtkPollsBaseWidget extends StatelessWidget {
  const RtkPollsBaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        width: context.width * 0.5,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(
            7,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RtkShimmerWidget(
              height: 7,
              width: double.infinity,
              borderRadius: const BorderRadius.all(
                Radius.circular(0.15),
              ),
              color: theme.colorScheme.tertiaryContainer,
            ),
            vspace1,
            RtkShimmerWidget(
              height: 7,
              width: context.width * 0.25,
              borderRadius: const BorderRadius.all(
                Radius.circular(0.15),
              ),
              color: theme.colorScheme.tertiaryContainer,
            ),
            vspace1,
            const PollOptionShimmer(),
            const PollOptionShimmer(),
            vspace1,
            Center(
              child: RtkShimmerWidget(
                height: 10,
                width: context.width * 0.25,
                borderRadius: const BorderRadius.all(
                  Radius.circular(0.15),
                ),
                color: theme.colorScheme.tertiaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PollOptionShimmer extends StatelessWidget {
  const PollOptionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme(globalDesignToken.colorToken).theme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          RtkShimmerWidget(
            height: 10,
            width: 10,
            borderRadius: const BorderRadius.all(
              Radius.circular(0.15),
            ),
            color: theme.colorScheme.tertiaryContainer,
          ),
          hspace1,
          RtkShimmerWidget(
            height: 7,
            width: context.width * 0.25,
            borderRadius: const BorderRadius.all(
              Radius.circular(0.15),
            ),
            color: theme.colorScheme.tertiaryContainer,
          ),
        ],
      ),
    );
  }
}
