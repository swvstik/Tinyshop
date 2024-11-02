import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _page = 0;
  final List<Map> _prods = [];
  final List<int> _cartItems = [];
  List<Map> _searchItems = [];
  @override
  void initState() {
    Uri uri = Uri.parse("https://fakestoreapi.com/products");
    super.initState();
    get(uri).then((res){
      final data = jsonDecode(res.body) as List;
      setState(() {
      _prods.addAll(data.map((e)=>e as Map));
      print(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade50,
      appBar: appBar(),
      bottomNavigationBar: navigationBar(),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          searchBar(),
          const SizedBox(height: 15.0,),
          if(_prods.isEmpty)...[
            const Spacer(),
          const SizedBox(
            width: 50.0,
            height: 50.0,
            child: CircularProgressIndicator(
              color: Colors.amber,
              strokeWidth: 2.0,
            ),
          ),
          const Spacer(),
          ]
          else
          _page == 0 ? carouselSlider() : listWidget(),
        ],
      ),
    );
  }

  listWidget() {
    var items = _prods;
    if (_searchItems.isNotEmpty) {
      items = _searchItems;
    }
    return Expanded(
      child: ListView(
        children: items.map((e) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 10.0,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 15.0,
            ),
            margin: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  e["image"],
                  height: 100.0,
                  width: 60.0,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10.0),
                      Text(e['title']),
                      const SizedBox(height: 5.0),
                      addCartBtn(e),
                    ],
                  ),
                ),
                productRating(e)
              ],
            ),
          );
        }).toList(),
      ),
    );
  }


  Container searchBar() {
    return Container(
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 25.0),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.orange,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Row(
            children: [
              const Icon(Icons.search,color: Colors.grey,),
              const SizedBox(width: 10.0,),
              Expanded(
                child: TextField(
              onChanged: (v) {
              setState(() {
                _searchItems = _prods
                    .where((prod) => (prod['title'] as String)
                        .toLowerCase()
                        .contains(v.toLowerCase()))
                    .toList();
              });
            },
                  decoration: const InputDecoration(
                    hintText: "Search for products...",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    )
                  ),
                ),
              ),
            ],
          ),
        );
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(icon: Icon(Icons.swipe),label: "Swipe"),
      BottomNavigationBarItem(icon: Icon(Icons.list),label: "List"),
    ],
    selectedItemColor: Colors.amber,
    unselectedItemColor: Colors.grey,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    onTap: (v) {
      setState(() {
        _page = v;
      });
    },);
  }

  CarouselSlider carouselSlider() {
    var items = _prods;
    if(_searchItems.isNotEmpty){
      items=_searchItems;
    }
    return CarouselSlider(items: items.map((e){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [ 
                  BoxShadow(color: Colors.grey.shade300,
                  blurRadius: 10.0,
                  offset: const Offset(0, 3),),
                   ]
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 25.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: productRating(e),
                    ),
                    const Spacer(),
                    Image.network(e["image"], height: 200,),
                    const Spacer(),
                    Text(e["title"],
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),),
                    const SizedBox(height: 10.0),
                    Text(e["description"],
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey,
                    ),),
                    const SizedBox(height: 20.0,),
                    addCartBtn(e)
                  ],
                ),
              ),
            ),
          );
        }).toList(), 
        options: CarouselOptions(
          height: 480,
          enlargeCenterPage: true,
          enlargeFactor: 0.2,
          autoPlay: true,
          autoPlayAnimationDuration: const Duration(seconds: 2),
        ));
  }

  Container productRating(Map<dynamic, dynamic> e) {
    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0,),
                      decoration: BoxDecoration(color: Colors.blueGrey.shade50,borderRadius: BorderRadius.circular(15.0)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 12.0,
                          ),
                          const SizedBox(width: 5.0,),
                          Text("${e['rating']['rate']} / 5",
                          style:const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          )),
                        ],
                      ),
                    );
  }

  Row addCartBtn(Map<dynamic, dynamic> e) {
    return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("\$${e['price']}",
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),),
                      const SizedBox(width: 5.0,),
                      InkWell(
                        onTap: (){
                          setState(() {
                            if (_cartItems.contains(e['id'])){
                              _cartItems.remove(e['id']);
                            }
                            else{
                              _cartItems.add(e['id']);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange.shade100,
                          ),
                          child: Icon(
                            _cartItems.contains(e['id'])? Icons.remove_shopping_cart_rounded: Icons.shopping_cart_rounded,
                            size: 20.0,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.amber.shade50,
      elevation: 0.0,
      iconTheme: const IconThemeData(color: Color(0xffC8B893)),
      title: const Center(
        child: const Text("Tinyshop", style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xffC8B893),
        ),),
      ),
      actions: [
        Stack(
          children: [
            IconButton(onPressed: (){}, icon: const Icon(Icons.shopping_cart_rounded)),
            Positioned(
              top: 5.0,
              right: 5.0,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.amber.shade500,
                ),
                padding: const EdgeInsets.all(5.0),
                child: Text(_cartItems.length.toString())),
            )
          ],
        ),
      ],
    );
  }
}