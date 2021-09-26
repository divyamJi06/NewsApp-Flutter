import 'package:flutter/material.dart';
import 'package:newsapp/utils/constants.dart';

class NewsElement extends StatelessWidget {
  const NewsElement({Key? key, required this.imageUrl, required this.title})
      : super(key: key);

  final String imageUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 10,
      height: 100,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: imageUrl == "Empty"
                ? imageFromAssets("./assets/images/image_not_found.png")
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imageUrl,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return imageFromAssets(
                            "./assets/images/image_loader.gif");
                      },
                      fit: BoxFit.fill,
                      height: 70,
                      width: 100,
                    ),
                  ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                  color: colorText, fontWeight: FontWeight.bold),
            ),
          ))
        ],
      ),
    );
  }

  Widget imageFromAssets(String source) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.asset(
        source,
        fit: BoxFit.fill,
        height: 70,
        width: 100,
      ),
    );
  }
}
