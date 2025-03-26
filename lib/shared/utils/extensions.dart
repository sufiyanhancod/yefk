import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension StringX on String {
  String get displayCase => split('_')
      .map(
        (word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');

  String get sentenceCase {
    final words = split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1);
      } else {
        return word;
      }
    }).toList();

    return capitalizedWords.join(' ');
  }
}

extension ProviderContext on BuildContext {
  // Custom call a provider for reading method only
  // It will be helpful for us for calling the read function
  // without Consumer,ConsumerWidget or ConsumerStatefulWidget
  // Incase if you face any issue using this then please wrap your widget
  // with consumer and then call your provider

  T read<T>(ProviderBase<T> provider) {
    return ProviderScope.containerOf(this, listen: false).read(provider);
  }

  T watch<T>(ProviderBase<T> provider) {
    return ProviderScope.containerOf(this).read(provider);
  }
}
