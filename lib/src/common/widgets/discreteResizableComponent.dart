import 'package:flutter/material.dart';

class DiscreteResizableComponent extends StatefulWidget {
  const DiscreteResizableComponent(
      {Key? key,
      required this.backgroundColor,
      required this.text,
      required this.textAlign,
      required this.textStyle})
      : super(key: key);

  final Color backgroundColor;
  final String text;
  final TextAlign textAlign;
  final TextStyle textStyle;

  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState();
}

const ballDiameter = 30.0;
const discreteStepSize = 50;

class _ResizebleWidgetState extends State<DiscreteResizableComponent> {
  double height = 400;
  double width = 200;

  double top = 0;
  double left = 0;

  double cumulativeDy = 0;
  double cumulativeDx = 0;
  double cumulativeMid = 0;

  void onDrag(double dx, double dy) {
    var newHeight = height + dy;
    var newWidth = width + dx;

    setState(() {
      height = newHeight > 0 ? newHeight : 0;
      width = newWidth > 0 ? newWidth : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: top,
          left: left,
          child: Container(
            height: height,
            width: width,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              color: widget.backgroundColor,
            ),
            child: Center(
              child: Text(
                widget.text,
                textAlign: widget.textAlign,
                style: widget.textStyle,
              ),
            ),
          ),
        ),
        // top left
        Positioned(
          top: top - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;
              cumulativeMid -= 2 * mid;
              if (cumulativeMid >= discreteStepSize) {
                setState(() {
                  var newHeight = height + discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  var newWidth = width + discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeMid = 0;
                });
              } else if (cumulativeMid <= -discreteStepSize) {
                setState(() {
                  var newHeight = height - discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  var newWidth = width - discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeMid = 0;
                });
              }
            },
          ),
        ),
        // top middle
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              cumulativeDy -= dy;
              if (cumulativeDy >= discreteStepSize) {
                setState(() {
                  var newHeight = height + discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  cumulativeDy = 0;
                });
              } else if (cumulativeDy <= -discreteStepSize) {
                setState(() {
                  var newHeight = height - discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  cumulativeDy = 0;
                });
              }
            },
          ),
        ),
        // top right
        Positioned(
          top: top - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + (dy * -1)) / 2;
              cumulativeMid += 2 * mid;
              if (cumulativeMid >= discreteStepSize) {
                setState(() {
                  var newHeight = height + discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  var newWidth = width + discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeMid = 0;
                });
              } else if (cumulativeMid <= -discreteStepSize) {
                setState(() {
                  var newHeight = height - discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  var newWidth = width - discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeMid = 0;
                });
              }
            },
          ),
        ),
        // center right
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              cumulativeDx += dx;

              if (cumulativeDx >= discreteStepSize) {
                setState(() {
                  var newWidth = width + discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeDx = 0;
                });
              } else if (cumulativeDx <= -discreteStepSize) {
                setState(() {
                  var newWidth = width - discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeDx = 0;
                });
              }
            },
          ),
        ),
        // bottom right
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = (dx + dy) / 2;

              cumulativeMid += 2 * mid;
              if (cumulativeMid >= discreteStepSize) {
                setState(() {
                  var newHeight = height + discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  var newWidth = width + discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeMid = 0;
                });
              } else if (cumulativeMid <= -discreteStepSize) {
                setState(() {
                  var newHeight = height - discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  var newWidth = width - discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeMid = 0;
                });
              }
            },
          ),
        ),
        // bottom center
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left + width / 2 - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              cumulativeDy += dy;

              if (cumulativeDy >= discreteStepSize) {
                setState(() {
                  var newHeight = height + discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  cumulativeDy = 0;
                });
              } else if (cumulativeDy <= -discreteStepSize) {
                setState(() {
                  var newHeight = height - discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  cumulativeDy = 0;
                });
              }
            },
          ),
        ),
        // bottom left
        Positioned(
          top: top + height - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              var mid = ((dx * -1) + dy) / 2;

              cumulativeMid += 2 * mid;
              if (cumulativeMid >= discreteStepSize) {
                setState(() {
                  var newHeight = height + discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  var newWidth = width + discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeMid = 0;
                });
              } else if (cumulativeMid <= -discreteStepSize) {
                setState(() {
                  var newHeight = height - discreteStepSize;
                  height = newHeight > 0 ? newHeight : 0;
                  var newWidth = width - discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeMid = 0;
                });
              }
            },
          ),
        ),
        //left center
        Positioned(
          top: top + height / 2 - ballDiameter / 2,
          left: left - ballDiameter / 2,
          child: ManipulatingBall(
            onDrag: (dx, dy) {
              cumulativeDx -= dx;

              if (cumulativeDx >= discreteStepSize) {
                setState(() {
                  var newWidth = width + discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeDx = 0;
                });
              } else if (cumulativeDx <= -discreteStepSize) {
                setState(() {
                  var newWidth = width - discreteStepSize;
                  width = newWidth > 0 ? newWidth : 0;
                  cumulativeDx = 0;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  const ManipulatingBall({Key? key, required this.onDrag}) : super(key: key);

  final Function onDrag;

  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  late double initX;
  late double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Container(
        width: ballDiameter,
        height: ballDiameter,
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
