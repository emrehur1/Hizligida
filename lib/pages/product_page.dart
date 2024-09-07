import 'package:flutter/material.dart';
import 'package:hizligida/pages/base_page.dart';
import 'package:hizligida/widgets/widget_product_card.dart' as widget_product;
import 'package:hizligida/models/product.dart';
import 'package:hizligida/provider/products_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class ProductPage extends BasePage {
  final int? categoryId;

  ProductPage({Key? key, this.categoryId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends BasePageState<ProductPage> {
  int _page = 1;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchQuery = TextEditingController();
  Timer? _debounce;
  List<String> _selectedColors = []; // Seçilen renkleri saklamak için liste
  List<String> _selectedSizes = []; // Seçilen bedenleri saklamak için liste
  Set<String> _availableColors = {}; // Tüm ürünlerden alınan renk seçenekleri
  Set<String> _availableSizes = {}; // Tüm ürünlerden alınan beden seçenekleri
  bool _colorsCollected = false; // Renklerin sadece bir kez toplanmasını kontrol etmek için
  bool _sizesCollected = false; // Bedenlerin sadece bir kez toplanmasını kontrol etmek için

  // Fiyat filtreleme için değişkenler
  double _minPrice = 299.0;
  double _maxPrice = 9999.0;

  final _sortByOptions = [
    SortBy("popularity", "Popülerlik", "asc"),
    SortBy("modified", "Son eklenenler", "asc"),
    SortBy("price", "Fiyat yüksekten düşüğe", "desc"),
    SortBy("price", "Fiyat düşükten yükseğe", "asc"),
  ];

  @override
  void initState() {
    super.initState();
    var productList = Provider.of<ProductsProvider>(context, listen: false);
    productList.resetStreams();
    productList.setLoadingState(LoadMoreStatus.INITIAL);
    productList.fetchProducts(_page, categoryId: widget.categoryId?.toString());
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      var productList = Provider.of<ProductsProvider>(context, listen: false);
      productList.setLoadingState(LoadMoreStatus.LOADING);
      productList.fetchProducts(++_page, categoryId: widget.categoryId?.toString());
      _collectAllColorsAndSizes(); // Daha fazla ürün yüklendiğinde renkleri ve bedenleri yeniden topla
    }
  }

  void _onSearchTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      var productList = Provider.of<ProductsProvider>(context, listen: false);
      productList.resetStreams();
      productList.setLoadingState(LoadMoreStatus.INITIAL);
      productList.fetchProducts(1, strSearch: text, categoryId: widget.categoryId?.toString());
      _colorsCollected = false; // Yeni aramada renkler yeniden toplanacak
      _sizesCollected = false; // Yeni aramada bedenler yeniden toplanacak
    });
  }

  void _collectAllColorsAndSizes() {
    if (_colorsCollected && _sizesCollected) return; // Eğer renkler ve bedenler daha önce toplandıysa, yeniden toplama

    var products = Provider.of<ProductsProvider>(context, listen: false).allProducts;

    if (products.isEmpty) {
      print("No products available to collect colors and sizes.");
      return;
    }

    _availableColors.clear(); // Önceki renk seçeneklerini temizliyoruz
    _availableSizes.clear(); // Önceki beden seçeneklerini temizliyoruz

    for (var product in products) {
      if (product.attributes != null) {
        for (var attribute in product.attributes!) {
          if (attribute.name == "Renk" && attribute.options != null) {
            for (var option in attribute.options!) {
              _availableColors.add(option); // Tüm renk seçeneklerini topla
            }
          }
          if (attribute.name == "Beden" && attribute.options != null) {
            for (var option in attribute.options!) {
              _availableSizes.add(option); // Tüm beden seçeneklerini topla
            }
          }
        }
      }
    }

    print("Available Colors: $_availableColors"); // Set'in içeriğini konsola yazdırın
    print("Available Sizes: $_availableSizes"); // Set'in içeriğini konsola yazdırın

    _colorsCollected = true; // Renkler toplandı olarak işaretle
    _sizesCollected = true; // Bedenler toplandı olarak işaretle
    setState(() {}); // UI'ı güncellemek için setState çağrılır
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView( // SingleChildScrollView kullanarak kaydırılabilir yapıyoruz
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Filtreleme",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Poppins"),
                    ),
                    ExpansionTile(
                      title: Text("Fiyat",style: TextStyle(fontFamily: "Poppins"),),
                      children: [
                        RangeSlider(
                          activeColor: Colors.black, // Seçim çizgisinin rengini siyah yapıyoruz
                          values: RangeValues(
                            _minPrice.clamp(1.0, 999.0),
                            _maxPrice.clamp(1.0, 999.0),
                          ),
                          min: 1.0,
                          max: 999.0,
                          onChanged: (RangeValues values) {
                            setModalState(() {
                              _minPrice = values.start;
                              _maxPrice = values.end;
                            });
                          },
                          divisions: 100,
                          labels: RangeLabels(
                            '${_minPrice.round()} TL',
                            '${_maxPrice.round()} TL', // Seçili değerler burada gösterilecek
                          ),
                        ),
                      ],
                    ),
                    ExpansionTile(
                      title: Text("Renk",style: TextStyle(fontFamily: "Poppins"),),
                      children: _availableColors.map((renk) {
                        return CheckboxListTile(
                          title: Text(renk),
                          value: _selectedColors.contains(renk),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                _selectedColors.add(renk);
                              } else {
                                _selectedColors.remove(renk);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    ExpansionTile(
                      title: Text("Beden",style: TextStyle(fontFamily: "Poppins"),),
                      children: _availableSizes.map((size) {
                        return CheckboxListTile(
                          title: Text(size),
                          value: _selectedSizes.contains(size),
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                _selectedSizes.add(size);
                              } else {
                                _selectedSizes.remove(size);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20), // Biraz boşluk ekledik
                    ElevatedButton(
                      onPressed: () {
                        var productList = Provider.of<ProductsProvider>(context, listen: false);
                        productList.setLoadingState(LoadMoreStatus.LOADING);
                        productList.filterProductsByAttributes(_selectedColors, _selectedSizes, _minPrice, _maxPrice);
                        Navigator.pop(context);
                      },
                      child: Text("Uygula", style: TextStyle(color: Colors.white, fontFamily: "Poppins")), // Yazıyı beyaz yaptık ve fontu Poppins
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // Full width button
                        backgroundColor: Colors.black, // Buton rengini siyah yaptık
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget pageUI() {
    return Scaffold(
      body: Column(
        children: [
          _searchBar(),
          Expanded(
            child: Consumer<ProductsProvider>(
              builder: (context, productsModel, child) {
                if (productsModel.getLoadMoreStatus == LoadMoreStatus.LOADING && productsModel.allProducts.isEmpty) {
                  // Eğer durum LOADING ve ürün listesi boş ise, yüklenme göstergesini göster
                  return Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                } else if (productsModel.allProducts.isNotEmpty) {
                  // Ürünler yüklendikten sonra renkleri topluyoruz
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _collectAllColorsAndSizes(); // Renkleri ve bedenleri toplama çağrısı
                  });

                  return _buildGrid(
                    productsModel.allProducts,
                    productsModel.getLoadMoreStatus == LoadMoreStatus.LOADING,
                  );
                } else if (productsModel.allProducts.isEmpty && productsModel.getLoadMoreStatus == LoadMoreStatus.STABLE) {
                  // Eğer ürün listesi boş ve durum STABLE ise, "ürün bulunamadı" mesajını göster
                  return Center(
                    child: Text(
                      "Ürün bulunamadı",
                      style: TextStyle(fontSize: 16, color: Colors.black,fontFamily: "Poppins"),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              },
            ),
          ),
          _bottomFilterSortBar(),
        ],
      ),
    );
  }


  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _searchQuery,
        onChanged: _onSearchTextChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          hintText: "Search",
          hintStyle: TextStyle(fontFamily: "poppins"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          fillColor: Color(0xffe6e6ec),
          filled: true,
        ),
      ),
    );
  }

  Widget _bottomFilterSortBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 1), // Üstte hafif bir çizgi ekliyoruz
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade300, width: 1), // Ortada bir çizgi ekliyoruz
                ),
              ),
              child: TextButton.icon(
                onPressed: () => _showSortOptions(context),
                icon: Icon(Icons.sort, color: Colors.black),
                label: Text("SIRALA", style: TextStyle(color: Colors.black, fontFamily: "Poppins")),
              ),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: () => _showFilterSheet(context),
              icon: Icon(Icons.tune, color: Colors.black),
              label: Text("FİLTRELE", style: TextStyle(color: Colors.black, fontFamily: "Poppins")),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: _sortByOptions.map((item) {
            return ListTile(
              title: Text(item.text),
              onTap: () {
                var productList = Provider.of<ProductsProvider>(context, listen: false);
                productList.setSortOrder(item, categoryId: widget.categoryId?.toString());
                Navigator.pop(context); // Seçimden sonra alt paneli kapat
              },
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildGrid(List<Product> items, bool isLoadMore) {
    if (items.isEmpty && !isLoadMore) { // Yüklenme durumu değilse ve ürün yoksa
      return Center(
        child: Text(
          "Seçtiğiniz filtrelemeye uygun ürün bulunamadı",
          style: TextStyle(fontSize: 16, color: Colors.black),
          textAlign: TextAlign.center,
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      controller: _scrollController,
      crossAxisCount: 2,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      childAspectRatio: 0.7, // Ürün kartlarının boyutlarını ayarlar
      children: items.map((Product item) {
        return widget_product.ProductCard(
          data: item,
        );
      }).toList(),
    );
  }

}
