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
  {"filter": FilterType.NO_FILTER, "name": 'Original'},
  {"filter": FilterType.PURPLE, "name": 'Purple'},
  {"filter": FilterType.YELLOW, "name": 'Yellow'},
  {"filter": FilterType.CYAN, "name": 'Cyan'},
  {"filter": FilterType.BLACK_WHITE, "name": 'B&W'},
  {"filter": FilterType.OLD_TIMES, "name": 'Old Times'},
  {"filter": FilterType.COLD_LIFE, "name": 'Cold Life'},
  {"filter": FilterType.SEPIUM, "name": 'Sepium'},
  {"filter": FilterType.MILK, "name": 'Milk'},
  {"filter": FilterType.SEPIA_MATRIX, "name": 'Sepia'},
  {"filter": FilterType.GREYSCALE_MATRIX, "name": 'Greyscale'},
  {"filter": FilterType.VINTAGE_MATRIX, "name": 'Vintage'},
  {"filter": FilterType.FILTER_1, "name": 'Filter1'},
  {"filter": FilterType.FILTER_2, "name": 'Filter2'},
  {"filter": FilterType.FILTER_3, "name": 'Filter3'},
  {"filter": FilterType.FILTER_4, "name": 'Filter4'},
  {"filter": FilterType.FILTER_5, "name": 'Filter5'},
];

Map<int, String> fonts = {
  1: CustomFonts.font6,
  2: CustomFonts.font2,
  3: CustomFonts.font3,
  4: CustomFonts.font4,
  5: CustomFonts.font5,
  6: CustomFonts.font1
};
