import 'package:flutter/material.dart';

class AppBanner {
  AppBanner._private();
  static final AppBanner instance = AppBanner._private();
  ScaffoldFeatureController<MaterialBanner, MaterialBannerClosedReason> show(
      BuildContext context,
      {required Widget content,
      TextStyle? contentTextStyle,
      Color? backgroundColor,
      EdgeInsetsGeometry? leadingPadding,
      Widget? leading,
      Function()? onDismiss,
      Future<void> Function()? onSubmit,
      String? dismissText,
      String? submissionText = 'Submit',
      List<Widget>? actions}) {
    return ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
        content: content,
        contentTextStyle: contentTextStyle ??
            const TextStyle(color: Colors.white, fontSize: 16),
        backgroundColor: backgroundColor ?? Colors.red,
        leadingPadding: leadingPadding ?? const EdgeInsets.only(right: 30),
        leading: leading ??
            const Icon(
              Icons.info,
              color: Colors.white,
              size: 32,
            ),
        actions: [
          TextButton(
              onPressed: onDismiss ??
                  () =>
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
              child: Text(
                dismissText ?? 'Dismiss',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              )),
          TextButton(
            onPressed: () async {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              await onSubmit!();
            },
            child: Text(
              submissionText ?? 'Submit',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ]));
  }
}
