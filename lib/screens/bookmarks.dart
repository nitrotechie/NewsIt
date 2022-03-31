import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_it/screens/news_full.dart';
import 'package:news_it/services/services.dart';
import 'package:news_it/utils/methods.dart';
import 'package:news_it/utils/themes.dart';
import 'package:news_it/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  getUserName() async {
    await Data.getUsername();
  }

  getImage() async {
    await Data.getImage();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
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
                            icon: const Icon(Icons.dark_mode),
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
                      "Bookmarks",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).secondaryHeaderColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('users')
                        .doc(_auth.currentUser!.uid)
                        .collection('bookmarks')
                        .snapshots(),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemBuilder: (context, i) {
                                  QueryDocumentSnapshot d =
                                      snapshot.data!.docs[i];
                                  Data.bookmark.add(d['description']);
                                  return FittedBox(
                                    fit: BoxFit.fill,
                                    child: GestureDetector(
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 20),
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .cardColor
                                              .withOpacity(0.4),
                                          boxShadow: MyTheme.neumorpShadow,
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                                d['sourceName'] == null
                                                    ? const Expanded(
                                                        child: Text(""))
                                                    : Expanded(
                                                        child: Text(
                                                            d['sourceName']),
                                                      ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 30,
                                                  ),
                                                  onPressed: () {
                                                    Data.bookmark.remove(
                                                        d['description']);
                                                    delete(d['title']);
                                                    setState(() {});
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
                                                image: d['imageUrl'],
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
                                                      d['author'] ?? "",
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    Data.getDate(
                                                        d['publishDate'] ??
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
                                              d['title'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              d['description'],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w100),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          News.sourceName =
                                              d['sourceName'] ?? "";
                                          News.imageUrl = d['imageUrl'];
                                          News.title = d['title'];
                                          News.description = d['description'];
                                          News.newsUrl = d['url'];
                                          News.author = d['author'] ?? "";
                                          News.publishDate = d['publishDate'] ??
                                              DateTime.now().toString();
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const NewsFull()));
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator.adaptive());
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
