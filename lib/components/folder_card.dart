// ignore_for_file: prefer_const_constructors

import 'package:cookie_app/utils/colors.dart';
import 'package:cookie_app/utils/demension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FolderCard extends StatefulWidget {
  final String folderName;
  final int numOfTopic;
  final Function()? onTap;
  final Function()? onTapDelete;
  final Function()? onLongPressStart;
  final int type;

  const FolderCard(
      {super.key,
      required this.folderName,
      required this.numOfTopic,
      this.onTap,
      this.onLongPressStart,
      this.onTapDelete,
      required this.type});

  @override
  State<FolderCard> createState() => FolderCardState();
}

class FolderCardState extends State<FolderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.type == 1
              ? CupertinoContextMenu(
                  enableHapticFeedback: true,
                  key: widget.key,
                  actions: [
                    CupertinoContextMenuAction(
                      trailingIcon: CupertinoIcons.pencil,
                      child: Text('Sửa'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoContextMenuAction(
                      trailingIcon: CupertinoIcons.trash,
                      isDestructiveAction: true,
                      child: Text(
                        'Xóa',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        widget.onTapDelete != null
                            ? widget.onTapDelete!()
                            : null;

                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      maxHeight: Dimensions.height(context, 90),
                    ),
                    icon: Icon(CupertinoIcons.folder_fill,
                        color: AppColors.blue,
                        size: Dimensions.fontSize(context, 100)),
                    onPressed: widget.onTap,
                  ),
                )
              : IconButton(
                  highlightColor: Colors.transparent,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(
                    maxHeight: Dimensions.height(context, 90),
                  ),
                  icon: Icon(CupertinoIcons.folder_fill,
                      color: AppColors.blue,
                      size: Dimensions.fontSize(context, 100)),
                  onPressed: widget.onTap,
                ),
          Text(
            widget.folderName,
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.icon_grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
