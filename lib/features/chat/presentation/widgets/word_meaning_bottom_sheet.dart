import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/dictionary_cubit.dart';
import '../cubit/dictionary_state.dart';

import '../../../../core/constants/app_colors.dart';

class WordMeaningBottomSheet extends StatelessWidget {
  const WordMeaningBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DictionaryCubit, DictionaryState>(
      builder: (context, state) {
        if (state is DictionaryLoading) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is DictionaryError) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(state.message),
            ),
          );
        }

        if (state is DictionarySuccess) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.partOfSpeech,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      color: AppColors.partOfSpeechHint,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    state.definition,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
