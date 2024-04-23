import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passkey_demo_frontend/app_constants.dart';

import 'notification.dart';

class CodeWidget extends StatelessWidget {
  final String content;

  const CodeWidget(
    this.content, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          copyDockerCodeToClipboard(context, content);
        },
        child: Container(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text.rich(TextSpan(
                text: content,
                style: AppConstants.textTheme.labelLarge,
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.copy,
                        size: 14,
                        color: AppConstants.theme.colorScheme.secondary,
                      ),
                    ),
                  )
                ])),
          ),
        ),
      ),
    );
  }

  void copyDockerCodeToClipboard(BuildContext context, String content) {
    Clipboard.setData(ClipboardData(text: content));
    NotificationUtils.notify(context, "Code copied to clipboard");
  }
}
