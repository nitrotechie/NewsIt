// ignore_for_file: unrelated_type_equality_checks

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_it/screens/news_full.dart';
import 'package:news_it/services/helperfunction.dart';
import 'package:news_it/services/services.dart';
import 'package:news_it/utils/methods.dart';
import 'package:news_it/utils/themes.dart';
import 'package:news_it/widgets/catagory_card.dart';
import 'package:news_it/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  MyTheme theme = MyTheme();
  Data d = Data();
  List newslist = [];
  bool loading = false;
  bool select = true;
  var zero = true;
  var one = false;
  var two = false;
  var thr = false;
  var fur = false;
  var fiv = false;
  var six = false;
  var top = News.url;
  var business = News.businessUrl;
  var entertainment = News.entertainment;
  var health = News.health;
  var science = News.science;
  var sports = News.sports;
  var technology = News.technology;
  static var api = Data.api;
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getUserName();
    getHeadlines();
    getImage();
  }

  getHeadlines() async {
    loading = true;
    News n = News();
    await n.getNews(News.url);
    newslist = n.news;
    setState(() {
      loading = false;
    });
  }

  getUserName() async {
    await Data.getUsername();
  }

  getImage() async {
    await Data.getImage();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<MyTheme>(builder: (context, MyTheme theme, child) {
      return Scaffold(
        drawer: const CustomDrawer(),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                colors: [
                  Theme.of(context).cardColor,
                  Theme.of(context).canvasColor,
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(builder: (context) {
                          return GestureDetector(
                            child: Container(
                              height: 45,
                              width: 45,
                              child: Data.image == "null" || Data.image == ""
                                  ? const Icon(Icons.person)
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(Data.image),
                                    ),
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  boxShadow: MyTheme.neumorpShadow,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                            },
                          );
                        }),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      Methods.greeting(),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .secondaryHeaderColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Methods.greetingIcon(),
                                  ],
                                ),
                                Text(
                                  Data.userName,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          child: IconButton(
                            icon: Icon(
                                theme.isDark ? Icons.sunny : Icons.dark_mode),
                            onPressed: () {
                              theme.isDark = !theme.isDark;
                            },
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            boxShadow: MyTheme.neumorpShadow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Find Your",
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Daily News",
                      style: TextStyle(
                        fontSize: 30,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor,
                            Theme.of(context).canvasColor,
                          ],
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                      ),
                      child: TextField(
                        controller: searchController,
                        textAlign: TextAlign.justify,
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              News.url = News.topHeadlineUrl;
                            } else {
                              String searchUrl =
                                  "https://newsapi.org/v2/everything?q=$value&language=en&apiKey=$api";
                              News.url = searchUrl;
                            }
                            getHeadlines();
                          });
                        },
                        style: TextStyle(
                          color: Colors.grey.shade300,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: 25,
                            color: Theme.of(context).secondaryHeaderColor,
                          ),
                          hintText: "Search News",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 0.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryCard(
                          title: "Top",
                          onTap: () {
                            setState(() {
                              News.url = top;
                              getHeadlines();
                              zero = true;
                              one = false;
                              two = false;
                              thr = false;
                              fur = false;
                              fiv = false;
                              six = false;
                            });
                          },
                          selected: zero,
                        ),
                        CategoryCard(
                          title: "Business",
                          onTap: () {
                            setState(() {
                              News.url = business;
                              getHeadlines();
                              zero = false;
                              one = true;
                              two = false;
                              thr = false;
                              fur = false;
                              fiv = false;
                              six = false;
                            });
                          },
                          selected: one,
                        ),
                        CategoryCard(
                          title: "Entertainment",
                          onTap: () {
                            setState(() {
                              News.url = entertainment;
                              getHeadlines();
                              zero = false;
                              one = false;
                              thr = false;
                              fur = false;
                              fiv = false;
                              six = false;
                              two = true;
                            });
                          },
                          selected: two,
                        ),
                        CategoryCard(
                          title: "Health",
                          onTap: () {
                            setState(() {
                              News.url = health;
                              getHeadlines();
                              zero = false;
                              one = false;
                              two = false;
                              thr = true;
                              fur = false;
                              fiv = false;
                              six = false;
                            });
                          },
                          selected: thr,
                        ),
                        CategoryCard(
                          title: "Science",
                          onTap: () {
                            setState(() {
                              News.url = science;
                              getHeadlines();
                              zero = false;
                              one = false;
                              two = false;
                              thr = false;
                              fur = true;
                              fiv = false;
                              six = false;
                            });
                          },
                          selected: fur,
                        ),
                        CategoryCard(
                          title: "Sports",
                          onTap: () {
                            setState(() {
                              News.url = sports;
                              getHeadlines();
                              zero = false;
                              one = false;
                              two = false;
                              thr = false;
                              fur = false;
                              fiv = true;
                              six = false;
                            });
                          },
                          selected: fiv,
                        ),
                        CategoryCard(
                          title: "Technology",
                          onTap: () {
                            setState(() {
                              News.url = technology;
                              getHeadlines();
                              zero = false;
                              one = false;
                              two = false;
                              thr = false;
                              fur = false;
                              fiv = false;
                              six = true;
                            });
                          },
                          selected: six,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Top Headlines",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  loading == true
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: newslist.length,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, i) {
                                return FittedBox(
                                  fit: BoxFit.fill,
                                  child: GestureDetector(
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.all(10),
                                      width: size.width,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .cardColor
                                            .withOpacity(0.4),
                                        boxShadow: MyTheme.neumorpShadow,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              newslist[i]['source']['name'] ==
                                                      null
                                                  ? const Expanded(
                                                      child: Text(""))
                                                  : Expanded(
                                                      child: Text(newslist[i]
                                                          ['source']['name']),
                                                    ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.bookmark_border,
                                                  size: 30,
                                                ),
                                                onPressed: () {
                                                  User? user = FirebaseAuth
                                                      .instance.currentUser;
                                                  if (user != null) {
                                                    setState(() {
                                                      News.sourceName =
                                                          newslist[i]['source']
                                                                  ['name'] ??
                                                              "";
                                                      News.imageUrl =
                                                          newslist[i]
                                                              ['urlToImage'];
                                                      News.title =
                                                          newslist[i]['title'];
                                                      News.description =
                                                          newslist[i]
                                                              ['description'];
                                                      News.newsUrl =
                                                          newslist[i]['url'];
                                                      News.author = newslist[i]
                                                              ['author'] ??
                                                          "";
                                                      News.publishDate = newslist[
                                                                  i]
                                                              ['publishedAt'] ??
                                                          DateTime.now()
                                                              .toString();
                                                      setBookmarks(
                                                        News.sourceName,
                                                        News.imageUrl,
                                                        News.title,
                                                        News.description,
                                                        News.newsUrl,
                                                        News.author,
                                                        News.publishDate,
                                                      );
                                                    });
                                                  } else {
                                                    final snackBar = SnackBar(
                                                      content: const Text(
                                                          "Please Login to bookmark a news."),
                                                      action: SnackBarAction(
                                                        label: "Ok",
                                                        textColor:
                                                            Theme.of(context)
                                                                .canvasColor,
                                                        onPressed: () {},
                                                      ),
                                                    );
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: FadeInImage.assetNetwork(
                                              placeholder:
                                                  "assets/images/default.gif",
                                              image: newslist[i]['urlToImage'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, bottom: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    newslist[i]['author'] ?? "",
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  Data.getDate(newslist[i]
                                                          ['publishedAt'] ??
                                                      DateTime.now()
                                                          .toString()),
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            newslist[i]['title'],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            newslist[i]['description'],
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w100),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        News.newsUrl = newslist[i]['url'];
                                        News.title = newslist[i]['title'];
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NewsFull()));
                                      });
                                    },
                                  ),
                                );
                              }),
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
