import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsService {
  static Rect screenSize(MediaQueryData mediaQuery) {
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;

    return Rect.fromLTWH(
      0,
      0,
      width - mediaQuery.padding.right,
      height,
    );
  }
}

// class Settings {
//   Rect screenSize;

//   Settings(this.screenSize);
//   Settings.empty() : screenSize = Rect.zero;
//   Settings.screen(MediaQueryData mediaQuery) : screenSize = Rect.zero {
//     final width = mediaQuery.size.width;
//     final height = mediaQuery.size.height;
//     final topPadding = mediaQuery.padding.top;

//     screenSize = Rect.fromLTWH(
//       mediaQuery.padding.left,
//       topPadding,
//       width - mediaQuery.padding.right,
//       height - topPadding,
//     );
//   }

//   void changeScreenSize(MediaQueryData mediaQuery) {
//     final width = mediaQuery.size.width;
//     final height = mediaQuery.size.height;
//     final topPadding = mediaQuery.padding.top;

//     screenSize = Rect.fromLTWH(
//       mediaQuery.padding.left,
//       topPadding,
//       width - mediaQuery.padding.right,
//       height - topPadding,
//     );
//   }
// }

// class SettingsCubit extends Cubit<Settings> {
//   SettingsCubit(MediaQueRect getScreenSize(MediaQueryData mediaQuery) {
//     final width = mediaQuery.size.width;
//     final height = mediaQuery.size.height;
//     final topPadding = mediaQuery.padding.top;

//     return Rect.fromLTWH(
//       mediaQuery.padding.left,
//       topPadding,
//       width - mediaQuery.padding.right,
//       height - topPadding,
//     );
//   }ryData mediaQuery) : super(Settings.screen(mediaQuery));

//   void changeScreenSize(MediaQueryData mediaQuery) {
//     state.changeScreenSize(mediaQuery);
//     emit(state);
//   }
// }
