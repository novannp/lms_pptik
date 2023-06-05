import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

import 'custom_shape.dart';

class BubbleChat extends StatelessWidget {
  final String message;
  final bool isSender;
  final String date;
  const BubbleChat({
    super.key,
    required this.message,
    required this.isSender,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final messageTextGroup = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.75,
      ),
      child: Row(
        mainAxisAlignment:
            !isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !isSender
              ? CustomPaint(
                  painter: CustomShape(CupertinoColors.white),
                )
              : SizedBox(),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CupertinoColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: isSender ? const Radius.circular(18) : Radius.zero,
                  topRight: !isSender ? const Radius.circular(18) : Radius.zero,
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Html(
                    shrinkWrap: true,
                    data: message,
                    style: {
                      'p': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        textAlign: TextAlign.right,
                        fontSize: FontSize(14),
                        color: CupertinoColors.black,
                      ),
                      'a': Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        alignment: Alignment.centerRight,
                        textAlign: TextAlign.right,
                        fontSize: FontSize(14),
                        color: CupertinoColors.activeBlue,
                      ),
                    },
                  ),
                  Text(
                    date,
                    style: CupertinoTheme.of(context)
                        .textTheme
                        .textStyle
                        .copyWith(
                            color: CupertinoColors.systemGrey, fontSize: 11),
                  )
                ],
              ),
            ),
          ),
          isSender
              ? CustomPaint(
                  painter: CustomShape(CupertinoColors.white),
                )
              : SizedBox(),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 2, bottom: 10),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: messageTextGroup,
      ),
    );
  }
}
