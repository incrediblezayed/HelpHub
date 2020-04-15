import 'package:helphub/imports.dart';

class FullImage extends StatelessWidget {
  final ImageProvider image;
  const FullImage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(image: image)
      ),
    );
  }
}