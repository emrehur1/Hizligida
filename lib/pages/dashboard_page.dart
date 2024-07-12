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
            imageCarousel(context),
            WidgetCategories(),
            WidgetHomeProducts(labelName: "Top Saver Today",tagId: Config.todayOffersTagId,),
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
          'https://media.istockphoto.com/id/855098134/tr/foto%C4%9Fraf/sa%C4%9Fl%C4%B1k-g%C4%B1da-fitness-i%C3%A7in.jpg?s=612x612&w=0&k=20&c=nnndfASlOcl_hXyY3RnO5dsR5cOOXEwHL9NEdH3ygfI=',
          'https://rgtedarik.com/wp-content/uploads/2021/04/rg-tedarik-toptan-temizlik-malzemeleri-1.jpg',
          'https://www.batmanburada.com.tr/wp-content/uploads/2024/03/et-tavuk-balik.jpg'
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
                  child: Image.network(
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
