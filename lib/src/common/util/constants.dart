import 'custom_fonts.dart';
import 'filters.dart';

enum DirectionAxis { x, xNan, y, yNan }
enum ActionType { none, filters, transform, text, draw }
enum TextDirectionValue { left, center, right }
enum BoxType { white, faintWhite, transparent }
enum TextWidget {
  key,
  text,
  textSize,
  align,
  boxType,
  borderColorStatus,
  boxColorIndex,
  angle,
  visibility,
  x,
  y,
  xPrev,
  yPrev
}

List<Map<String, dynamic>> filters = [
  {"filter": FilterType.noFilter, "name": 'Original'},
  {"filter": FilterType.purple, "name": 'Purple'},
  {"filter": FilterType.yellow, "name": 'Yellow'},
  {"filter": FilterType.cyan, "name": 'Cyan'},
  {"filter": FilterType.blackNWhite, "name": 'B&W'},
  {"filter": FilterType.oldTimes, "name": 'Old Times'},
  {"filter": FilterType.coldLife, "name": 'Cold Life'},
  {"filter": FilterType.sepium, "name": 'Sepium'},
  {"filter": FilterType.milk, "name": 'Milk'},
  {"filter": FilterType.sepiaMatrix, "name": 'Sepia'},
  {"filter": FilterType.greyScaleMatrix, "name": 'Greyscale'},
  {"filter": FilterType.vintageMatrix, "name": 'Vintage'},
  {"filter": FilterType.filter1, "name": 'Filter1'},
  {"filter": FilterType.filter2, "name": 'Filter2'},
  {"filter": FilterType.filter3, "name": 'Filter3'},
  {"filter": FilterType.filter4, "name": 'Filter4'},
  {"filter": FilterType.filter5, "name": 'Filter5'},
];

Map<int, String> fonts = {
  1: CustomFonts.font6,
  2: CustomFonts.font2,
  3: CustomFonts.font3,
  4: CustomFonts.font4,
  5: CustomFonts.font5,
  6: CustomFonts.font1,
};
