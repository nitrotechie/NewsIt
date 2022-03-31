import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_it/services/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsFull extends StatefulWidget {
  const NewsFull({Key? key}) : super(key: key);

  @override
  State<NewsFull> createState() => _NewsFullState();
}

class _NewsFullState extends State<NewsFull> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        leading: IconButton(
          icon: const Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: SizedBox(
          height: 40,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  News.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  News.newsUrl,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: WebView(
        initialUrl: News.newsUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
