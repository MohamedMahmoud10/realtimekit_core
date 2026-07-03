import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:example/providers.dart';

class CloudBackendSwitch extends ConsumerWidget {
  const CloudBackendSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCloudflare = ref.watch(isCloudflareProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          label: const Text('Hive'),
          selected: !isCloudflare,
          onSelected:
              (v) => ref.read(isCloudflareProvider.notifier).state = false,
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: const Text('Cloudflare'),
          selected: isCloudflare,
          onSelected:
              (v) => ref.read(isCloudflareProvider.notifier).state = true,
        ),
      ],
    );
  }
}
