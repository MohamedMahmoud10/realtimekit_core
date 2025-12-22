import 'package:flutter_riverpod/flutter_riverpod.dart';

/// If true => use Cloudflare meetings (baseDomain: realtime.cloudflare.com)
/// If false => use Hive meetings (no baseDomain passed)
final isCloudflareProvider = StateProvider<bool>((ref) => false);
