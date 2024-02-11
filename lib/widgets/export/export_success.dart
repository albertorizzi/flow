import 'dart:io';

import 'package:flow/data/flow_icon.dart';
import 'package:flow/l10n/extensions.dart';
import 'package:flow/sync/export/mode.dart';
import 'package:flow/theme/theme.dart';
import 'package:flow/utils/toast.dart';
import 'package:flow/widgets/button.dart';
import 'package:flow/widgets/general/flow_icon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

class ExportSuccess extends StatelessWidget {
  final ExportMode mode;
  final VoidCallback shareFn;

  final String filePath;

  const ExportSuccess({
    super.key,
    required this.mode,
    required this.shareFn,
    required this.filePath,
  });

  @override
  Widget build(BuildContext context) {
    final bool showFilePath = kDebugMode ||
        Platform.isLinux ||
        Platform.isWindows ||
        Platform.isMacOS;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Spacer(),
          FlowIcon(
            FlowIconData.icon(Symbols.check_circle_outline_rounded),
            size: 80.0,
            color: context.flowColors.income,
          ),
          const SizedBox(height: 16.0),
          Text(
            "sync.export.success".t(context),
            style: context.textTheme.headlineMedium,
          ),
          if (showFilePath)
            Tooltip(
              message: "general.copy.clickToCopy".t(context),
              child: RichText(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "sync.export.success.filePath[0]".t(context)),
                    TextSpan(
                      text: '"$filePath"',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => copyPath(context),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    TextSpan(
                        text: "sync.export.success.filePath[1]".t(context)),
                  ],
                  style: context.textTheme.bodyMedium?.semi(context),
                ),
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
              ),
            ),
          const Spacer(),
          const SizedBox(height: 16.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Symbols.info_rounded,
                fill: 0,
                color: context.flowColors.semi,
                size: 16.0,
              ),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  "sync.export.onDeviceWarning".t(context),
                  style: context.textTheme.bodySmall?.semi(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          Button(
            onTap: shareFn,
            leading: const Icon(Symbols.save_alt_rounded),
            child: Text(
              "sync.export.share".t(context, mode.name),
            ),
          )
        ],
      ),
    );
  }

  void copyPath(BuildContext context) async {
    try {
      await Clipboard.setData(ClipboardData(text: filePath));
      if (context.mounted) {
        context.showToast(text: "general.copy.success".t(context));
      }
    } catch (e) {
      // Silent fail
    }
  }
}