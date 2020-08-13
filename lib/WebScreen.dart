import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:photo_view/photo_view.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'YoutubePlayer.dart';

class WebScreen extends StatelessWidget {
  final String feed;
  WebScreen({Key key, this.feed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      feed,
      customWidgetBuilder: (element) {
        if (element.getElementsByTagName("img").length != 0) {
          List<String> images = List();
          element.children.forEach((imgElement) {
            if (imgElement.attributes.containsKey('src')) {
              /* images.add(
                InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => FullImageScreen(
                            src: imgElement.attributes['src'],
                          ),
                        ),
                      );
                    },
                    child: Image.network(imgElement.attributes['src'])),
              );*/
              images.add(imgElement.attributes['src']);
            }
          });
          if (images.length != 0)
            return ImageScreen(
              images: images,
            );
        } else if (element.getElementsByTagName("iframe").length != 0) {
          if (element.firstChild.attributes.containsKey('src')) {
            return YoutubeVideo(
              videoId: getVideoID(element.firstChild.attributes['src']),
            );
            YoutubePlayerController _controller = YoutubePlayerController(
                initialVideoId:
                    getVideoID(element.firstChild.attributes['src']),
                flags: YoutubePlayerFlags(autoPlay: false));

            _controller.addListener(() {});

            return YoutubePlayer(
              // Provides controller to all the widget below it.
              controller: _controller,
            );
          }
        }
        return null;
      },
      enableCaching: true,
    );
  }

  String getVideoID(String url) {
    url = url.replaceAll("https://www.youtube.com/watch?v=", "");
    url = url.replaceAll("https://m.youtube.com/watch?v=", "");
    url = url.replaceAll("https://www.youtube.com/embed/", "");
    return url;
  }

}

class FullImageScreen extends StatelessWidget {
  final String src;

  const FullImageScreen({Key key, this.src}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoView(
        imageProvider: NetworkImage(src),
      ),
    );
  }
}

class ImageScreen extends StatefulWidget {
  final List<String> images;
  ImageScreen({Key key, this.images}) : super(key: key);

  @override
  _ImageScreenState createState() {
    return _ImageScreenState();
  }
}

class _ImageScreenState extends State<ImageScreen> {
  ScrollPhysics scrollPhysics = ClampingScrollPhysics();
  PageController pagerController;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context). size. width;

    pagerController = PageController(
      initialPage: 0,
      viewportFraction: (widget.images.length == 1)?1:0.85,
    );

    return SizedBox(
      height: width * 0.5625,
      child: PageView.builder(
          physics: scrollPhysics,
          allowImplicitScrolling: false,
          controller: pagerController,
          itemCount: widget.images.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => FullImageScreen(
                        src: widget.images[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  color: Colors.grey,
                  child: Image.network(widget.images[index],fit:BoxFit.fill,)
                  ),
                ),
            );
          }),
    );
  }

}
