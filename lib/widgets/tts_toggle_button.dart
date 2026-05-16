import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exo/providers/tts_provider.dart';

class TTSToggleButton extends ConsumerWidget {
  const TTSToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEnabled = ref.watch(ttsProvider);

    return Builder(
      builder: (context) => IconButton(
        icon: Icon(
          isEnabled ? Icons.volume_up : Icons.volume_off,
          color: isEnabled ? Colors.green : Colors.grey,
        ),
        onPressed: () {
          ref.read(ttsProvider.notifier).toggle();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEnabled ? 'دستیار صوتی غیرفعال شد' : 'دستیار صوتی فعال شد',
              ),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        tooltip: isEnabled ? 'صدا فعال' : 'صدا غیرفعال',
      ),
    );
  }
}
