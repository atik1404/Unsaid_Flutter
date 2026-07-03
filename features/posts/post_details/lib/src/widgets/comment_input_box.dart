import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localization/localization.dart';

class CommentInputBox extends StatefulWidget {
  final bool isLoading;
  final Function(String) onCommentSubmitted;

  const CommentInputBox({super.key, required this.onCommentSubmitted, required this.isLoading});

  @override
  State<CommentInputBox> createState() => _CommentInputBoxState();
}

class _CommentInputBoxState extends State<CommentInputBox> {
  final TextEditingController _textController = TextEditingController();
  bool isButtonEnable = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _textController.addListener(() {
      setState(() {
        isButtonEnable = _textController.text.isNotEmpty;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard.rounded(
      padding: EdgeInsets.all(AppSpacing.s16.r),
      child: Row(
        children: [
          _buildAvatar(context),
          SizedBox(width: AppSpacing.s8.w),
          _buildInputField(context),
          SizedBox(width: AppSpacing.s8.w),
          if (widget.isLoading)
            const SizedBox(
              width: IconSizes.inline,
              height: IconSizes.inline,
              child: CircularProgressIndicator(
                strokeWidth: 1,
              ),
            )
          else
            _buildSendButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return AppImage.network(
      'https://thumbs.dreamstime.com/b/futuristic-alien-portrait-sci-fi-environment-high-detail-grey-skinned-humanoid-figure-elongated-smooth-head-large-379960286.jpg?w=576',
      width: IconSizes.dense,
      height: IconSizes.dense,
      shape: ImageShape.circle,
      fit: BoxFit.cover,
      borderColor: context.appColors.contentPrimary,
      borderWidth: 1,
      padding: EdgeInsets.all(AppSpacing.s2.r),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Expanded(
      child: AppInputField(
        controller: _textController,
        minLines: 1,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        hint: context.l10n.post_details_comment_hint,
        // maxLines: 3,
        // keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    return Visibility(
      visible: isButtonEnable,
      child: AppIconButton(
        AppIcon(
          const AppImage.asset(
            AppDrawables.icSend,
            width: IconSizes.standard,
            height: IconSizes.standard,
          ),
          color: context.appColors.brand,
          tint: true,
        ),
        onPressed: () {
          widget.onCommentSubmitted(_textController.text);
          _textController.clear();
        },
      ),
    );
  }
}
