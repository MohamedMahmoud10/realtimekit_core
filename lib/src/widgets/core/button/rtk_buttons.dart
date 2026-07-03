part of 'rtk_elevated_button.dart';

abstract class RtkButton extends StatefulWidget
    with UsesStatusColor
    implements UiKitElement {
  final RtkDesignTokens designToken;
  final VoidCallback? onPressed;
  final String? label;
  final RtkButtonController controller;
  RtkButton({
    super.key,
    required this.label,
    RtkDesignTokens? individualDesignToken,
    this.onPressed,
    required this.controller,
  }) : designToken = individualDesignToken ?? globalDesignToken;

  static final theme = AppTheme(globalDesignToken.colorToken).theme;

  @override
  double get borderRadius => designToken.borderToken.getRadius(BorderSize.one);

  @override
  double get borderWidth => 0.0;

  @override
  Color get fillColor => designToken.colorToken.brandColor.shade500;

  @override
  Color get textColor => designToken.colorToken.textColor.shade1000;

  @override
  Color get errorColor => designToken.colorToken.danger;

  @override
  Color get warningColor => designToken.colorToken.warning;

  @override
  Color get successColor => designToken.colorToken.success;
}

// Solid Button
class _RtkSolidButton extends RtkButton {
  _RtkSolidButton({
    required super.label,
    this.height = AppSize.s12,
    this.width = AppSize.s15,
    this.backgroundColor,
    super.onPressed,
    super.individualDesignToken,
    required super.controller,
  });

  final double? height;
  final double? width;
  final Color? backgroundColor;

  @override
  State<StatefulWidget> createState() => _RtkSolidButtonState();
}

class _RtkSolidButtonState extends State<_RtkSolidButton> {
  Function()? _onButtonPressed() {
    if (widget.controller.value == ButtonState.normal) {
      return widget.onPressed;
    }
    return null;
  }

  Widget _getButtonChild(ThemeData theme) {
    if (widget.controller.value == ButtonState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      widget.label!,
      style: theme.textTheme.bodyMedium,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onButtonPressed(),
      color: widget.backgroundColor ?? widget.fillColor,
      disabledColor: widget.designToken.colorToken.textColor.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      height: widget.height,
      minWidth: widget.width,
      child: _getButtonChild(RtkButton.theme),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class _RtkSolidIconButtonWithLabel extends RtkButton {
  _RtkSolidIconButtonWithLabel({
    super.label,
    this.height = AppSize.s12,
    super.onPressed,
    super.individualDesignToken,
    required this.icon,
    required this.iconPosition,
    required super.controller,
  });

  final double? height;
  final Icon icon;
  final IconPosition iconPosition;

  @override
  State<StatefulWidget> createState() => _RtkSolidIconButtonWithLabelState();
}

class _RtkSolidIconButtonWithLabelState
    extends State<_RtkSolidIconButtonWithLabel> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      color: widget.fillColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      height: widget.height,
      child: Row(
        children: [
          if (widget.iconPosition == IconPosition.left) widget.icon,
          if (widget.label != null) ...[
            if (widget.iconPosition == IconPosition.left) hspace2,
            Text(widget.label!),
            if (widget.iconPosition == IconPosition.right) hspace2,
          ],
          if (widget.iconPosition == IconPosition.right) widget.icon,
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}

class _RtkIconButton extends RtkButton {
  _RtkIconButton({
    this.iconSize = 24,
    super.label,
    required super.controller,
    super.onPressed,
    super.individualDesignToken,
    required this.icon,
    this.isDisabled = false,
  });

  final Icon icon;
  final double? iconSize;
  final bool isDisabled;

  @override
  State<_RtkIconButton> createState() => _RtkIconButtonState();
}

class _RtkIconButtonState extends State<_RtkIconButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (context, value, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isDisabled)
              Positioned(
                right: 4,
                top: 4,
                child: Icon(
                  DyteIcons.warning,
                  color: widget.warningColor,
                  size: 14,
                ),
              ),
            IconButton(
              iconSize: widget.iconSize ?? 24,
              splashRadius: 1,
              onPressed: widget.isDisabled ? null : widget.onPressed,
              disabledColor: widget.designToken.colorToken.textColor.shade700,
              icon: Icon(
                widget.icon.icon,
                color: widget.icon.color ??
                    widget.designToken.colorToken.textColor.shade1000,
              ),
            ),
          ],
        );
      },
    );
  }
}
