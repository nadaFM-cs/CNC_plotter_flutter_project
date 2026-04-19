import 'dart:typed_data';
import 'package:image/image.dart' as img;

const int kA4WidthPx  = 595;
const int kA4HeightPx = 842;
Future<Uint8List> resizeToA4Png(Uint8List originalBytes) async {
  final decoded = img.decodeImage(originalBytes);
  if (decoded == null) return originalBytes;

  final resized = img.copyResize(
    decoded,
    width: kA4WidthPx,
    height: kA4HeightPx,
    maintainAspect: false,
    interpolation: img.Interpolation.linear,
  );

  return Uint8List.fromList(img.encodePng(resized));
}