import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/extensions.dart';
import '../data/providers/workout_providers.dart';
import '../widgets/workout_card.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('برنامه‌ها'),
      ),
      body: programsAsync.when(
        data: (programs) {
          if (programs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fitness_center_outlined,
                    size: 80,
                    color: context.colorScheme.primary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'هنوز برنامه‌ای اضافه نشده',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'برای شروع یک برنامه جدید بساز',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.colorScheme.onSurface
                          .withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: programs.length,
            itemBuilder: (context, index) {
              return ProgramCard(program: programs[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/create-program'),
        icon: const Icon(Icons.add),
        label: const Text('برنامه جدید'),
      ),
    );
  }
}
