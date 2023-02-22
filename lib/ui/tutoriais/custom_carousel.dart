import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomCarousel extends StatefulWidget {
  final List<String> titles;
  final List<String> images;
  const CustomCarousel({Key key, @required this.images, @required this.titles})
      : super(key: key);

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Expanded(
          child: CarouselSlider(
            carouselController: _carouselController,
            items: widget.titles
                .asMap()
                .entries
                .map((e) => _buildPage(
                    title: e.value,
                    icon: "assets/screenshots/" + widget.images[e.key]))
                .toList(),
            options: CarouselOptions(
              height: height,
              enableInfiniteScroll: false,
              enlargeCenterPage: false,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.titles.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.white)
                        .withOpacity(_currentIndex == entry.key ? 1.0 : 0.4)),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 10.0),
        _buildButtons(),
      ],
    );
  }

  Widget _buildButtons() {
    return Container(
      margin: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                textStyle: TextStyle(color: Colors.white70),
                foregroundColor: Colors.white70),
            child: Text("Saltar"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            color: Colors.white,
            splashColor: Colors.black,
            icon: Icon(
              _currentIndex < widget.titles.length - 1
                  ? FontAwesomeIcons.arrowRight
                  : FontAwesomeIcons.check,
            ),
            onPressed: () async {
              if (_currentIndex < widget.titles.length - 1)
                _carouselController.nextPage();
              else {
                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildPage({String title, String icon}) {
    final TextStyle titleStyle =
        TextStyle(fontWeight: FontWeight.w300, fontSize: 24.0);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 40.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: Color.fromRGBO(40, 40, 40, 1),
          image: DecorationImage(
              image: AssetImage(icon),
              fit: BoxFit.contain,
              colorFilter:
                  ColorFilter.mode(Colors.black38, BlendMode.multiply))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.start,
            style: titleStyle.copyWith(
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(1),
                )
              ],
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
