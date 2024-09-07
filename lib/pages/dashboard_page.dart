import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hizligida/widgets/widget_home_products.dart';
import 'package:hizligida/widgets/widgets_home_categories.dart';
import 'package:hizligida/widgets/widget_home_products.dart';
import 'package:hizligida/config.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: [
            WidgetCategories(),
            imageCarousel(context),
            WidgetHomeProducts(labelName: "Çok Satan Ürünler",tagId: Config.todayOffersTagId,),
            WidgetHomeProducts(labelName: "Top Selling Product",tagId: Config.topSellingProductsTagId,),
          ],
        ),
      ),
    );
  }

  Widget imageCarousel(BuildContext mediaContext) {
    return Container(
      width: MediaQuery.of(mediaContext).size.width,
      height: 200.0, // Yüksekliği 200 piksel olarak ayarlıyoruz
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200, // Yükseklik özelliği 200 olarak belirlendi
          aspectRatio: 16/9,
          viewportFraction: 1.0,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          onPageChanged: (index, reason) {
            // Sayfa değiştiğinde yapılacak işlemler buraya gelebilir
          },
          scrollDirection: Axis.horizontal,
        ),
        items: [
          'assets/img/1.png',
          'assets/img/2.png',
          'assets/img/3.png',
        ].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.amber,
                ),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                    i,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
