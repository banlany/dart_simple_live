import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_live_app/app/app_style.dart';
import 'package:simple_live_app/app/utils.dart';
import 'package:simple_live_app/widgets/net_image.dart';
import 'package:simple_live_core/simple_live_core.dart';

class SuperChatCard extends StatefulWidget {
  final LiveSuperChatMessage message;
  final VoidCallback onDelete;
  final Function()? onExpire;
  const SuperChatCard(
    this.message, {
    required this.onExpire,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  State<SuperChatCard> createState() => _SuperChatCardState();
}

class _SuperChatCardState extends State<SuperChatCard> {
  late Timer timer;

  int countdown = 0;

  @override
  void initState() {
    var currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var endTime = widget.message.endTime.millisecondsSinceEpoch ~/ 1000;

    countdown = endTime - currentTime;

    timer = Timer.periodic(const Duration(seconds: 1), timerCallback);
    //_textColor.value = Colors.white;
    super.initState();
  }

  void timerCallback(e) {
    if (countdown <= 0) {
      //widget.onExpire?.call();
      timer.cancel();
      return;
    }

    setState(() {
      countdown -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppStyle.radius8,
      child: GestureDetector(
        onTap: widget.onDelete, // 当整个Widget被点击时调用 onDelete 方法
        child: Container(
          decoration: BoxDecoration(
            color: Utils.convertHexColor(widget.message.backgroundColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: AppStyle.edgeInsetsA8,
                child: Row(
                  children: [
                    NetImage(
                      widget.message.face,
                      width: 48,
                      height: 48,
                      borderRadius: 36,
                    ),
                    AppStyle.hGap12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.message.userName,
                            style: const TextStyle(
                              color: AppColors.black333,
                            ),
                          ),
                          Text(
                            "￥${widget.message.price}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "$countdown",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      // 添加删除按钮
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: widget.onDelete, // 点击按钮时调用 onDelete 方法
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Utils.convertHexColor(
                      widget.message.backgroundBottomColor),
                ),
                padding: AppStyle.edgeInsetsA8,
                child: Text(
                  widget.message.message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
