/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/ask_question _icon.png
  AssetGenImage get askQuestionIcon =>
      const AssetGenImage('assets/icons/ask_question _icon.png');

  /// File path: assets/icons/question_icon.png
  AssetGenImage get questionIcon =>
      const AssetGenImage('assets/icons/question_icon.png');

  /// List of all assets
  List<AssetGenImage> get values => [askQuestionIcon, questionIcon];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/home_background.png
  AssetGenImage get homeBackground =>
      const AssetGenImage('assets/images/home_background.png');

  /// File path: assets/images/login_background_bottom.png
  AssetGenImage get loginBackgroundBottom =>
      const AssetGenImage('assets/images/login_background_bottom.png');

  /// File path: assets/images/login_background_top.png
  AssetGenImage get loginBackgroundTop =>
      const AssetGenImage('assets/images/login_background_top.png');

  /// File path: assets/images/logo_orginal.png
  AssetGenImage get logoOrginal =>
      const AssetGenImage('assets/images/logo_orginal.png');

  /// File path: assets/images/yefk_logo.png
  AssetGenImage get yefkLogo =>
      const AssetGenImage('assets/images/yefk_logo.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        homeBackground,
        loginBackgroundBottom,
        loginBackgroundTop,
        logoOrginal,
        yefkLogo
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
