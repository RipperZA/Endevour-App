import 'package:flutter/material.dart';

Padding leftAlignText({text, leftPadding, textColor, fontSize, fontWeight}) {
  return Padding(
    padding: EdgeInsets.only(left: leftPadding),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: textColor)),
    ),
  );
}

Padding centreAlignText(
    {text, padding, textColor, fontSize, fontWeight, underline = false}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
    child: Align(
      alignment: Alignment.center,
      child: Text(text,
          textAlign: TextAlign.center,
          style: TextStyle(
              decoration: underline ? TextDecoration.underline : null,
              fontFamily: 'Exo2',
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: textColor)),
    ),
  );
}

Padding rightAlignText({text, rightPadding, textColor, fontSize, fontWeight}) {
  return Padding(
    padding: EdgeInsets.only(right: rightPadding),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(text,
          textAlign: TextAlign.right,
          style: TextStyle(
              fontFamily: 'Exo2',
              fontSize: fontSize,
              fontWeight: fontWeight ?? FontWeight.w500,
              color: textColor)),
    ),
  );
}
