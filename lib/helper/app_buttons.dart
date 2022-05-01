import 'package:flutter/material.dart';
import 'package:iba/helper/style.dart';
import 'package:nb_utils/nb_utils.dart';

class AppCustomButton extends StatelessWidget {
  final VoidCallback? onpressed;
  final String title;
  final Color color;
  final Color textcolor;
  final double fontsize;
  final double elevation;
  final bool isBoldtitle;
  final double? height;
  final Color shadowColor;
  final double? width;
  final double radius;

  const AppCustomButton({
    Key? key,
    this.onpressed,
    required this.title,
    this.color = const Color(0xFF379DFF),
    this.textcolor = Colors.white,
    this.fontsize = 14.0,
    this.elevation = 0,
    this.isBoldtitle = true,
    this.height = 45,
    this.shadowColor = const Color(0xFF379DFF),
    this.width = double.infinity,
    this.radius = 99,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: title,
      color: color,
      textColor: textcolor,
      elevation: elevation,
      height: height,
      width: width,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      enableScaleAnimation: true,
      textStyle: TextStyle(
        fontSize: fontsize,
        fontWeight: isBoldtitle ? FontWeight.bold : FontWeight.normal,
        color: textcolor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      onTap: onpressed,
    );
  }
}

class DrawerButton extends StatefulWidget {
  final Function? onTap;
  final double? width;
  final double? height;
  final Color? color;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? splashColor;
  final Widget child;
  final bool? enableScaleAnimation;

  const DrawerButton(
      {Key? key,
      this.onTap,
      this.width,
      this.height,
      this.color,
      this.focusColor,
      this.hoverColor,
      this.splashColor,
      this.enableScaleAnimation,
      required this.child})
      : super(key: key);

  @override
  _DrawerButtonState createState() => _DrawerButtonState();
}

class _DrawerButtonState extends State<DrawerButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  AnimationController? _controller;
  Color color = Colors.white;

  @override
  void initState() {
    if (widget.enableScaleAnimation
        .validate(value: enableAppButtonScaleAnimationGlobal)) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: appButtonScaleAnimationDurationGlobal ?? 50,
        ),
        lowerBound: 0.0,
        upperBound: 0.1,
      )..addListener(() {
          setState(() {});
        });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null) {
      _scale = 1 - _controller!.value;
    }

    if (widget.enableScaleAnimation
        .validate(value: enableAppButtonScaleAnimationGlobal)) {
      return Listener(
        onPointerDown: (details) {
          _controller?.forward();
          color = AppColors.primaryColor;
        },
        onPointerUp: (details) {
          _controller?.reverse();
          color = Colors.white;
        },
        child: Transform.scale(
          scale: _scale,
          child: buildButton(),
        ),
      );
    } else {
      return buildButton();
    }
  }

  Widget buildButton() {
    return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(23),
          color: color,
          boxShadow: [
            BoxShadow(
              color: const Color(0xffCAD0D9).withOpacity(0.5),
              offset: const Offset(4, 8),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 22),
          child: widget.child,
        ));
  }
}
