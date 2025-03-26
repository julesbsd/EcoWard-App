import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  'lib/assets/carousel1.png',
  'lib/assets/carousel2.png',
  'lib/assets/carousel3.png',
  'lib/assets/carousel4.png',
  // 'https://picsum.photos/250?image=12',
];

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 1000),
          viewportFraction: 0.8,
        ),
        items: imgList
            .map((item) => Container(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: item.startsWith('http')
                          ? Image.network(item, fit: BoxFit.cover, width: 1000)
                          : Image.asset(item, fit: BoxFit.cover, width: 1000),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
