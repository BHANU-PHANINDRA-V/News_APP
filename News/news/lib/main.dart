// lib/main.dart
import 'package:flutter/material.dart';
import 'news_service.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "News App",
      home: const NewsPage(),
    );
  }
}
class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final NewsService _service = NewsService();
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchTopHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("headlines"),
       backgroundColor: Colors.lightBlueAccent),
      body:
           
            FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }
          final articles = snapshot.data ?? [];
          if (articles.isEmpty) {
            return const Center(child: Text("No articles found"));
          }

          return ListView.separated(
            itemCount: articles.length,
            separatorBuilder: (_, __) => const Divider(height: 6),
            itemBuilder: (context, index) {
              final a = articles[index];
              final title = a["title"] ?? "No title";
              final description = a["description"] ?? "";
              final imageUrl = a["urlToImage"] as String?;
              final url = a["url"] as String?;

              return ListTile(
                leading: imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        
                        child: Image.network(
                          imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported),
                         
                        ),
                      )
                    : const Icon(Icons.article),
                title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  if (url != null) {
                    // For now, just show a dialog. Later we’ll open in browser.
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Article link"),
                        content: Text(url),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          ),
                        ],
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
       drawer: Drawer( // Drawer braces { } contain ListView
        child: ListView( // ListView braces { } contain children
          //padding: EdgeInsets.zero,
          children: [ // square brackets [ ] hold multiple widgets
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ), // closing ) ends BoxDecoration
              child: Text(
                'My Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ), // closing ) ends TextStyle
              ), // closing ) ends Text widget
            ), // closing ) ends DrawerHeader
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
               onTap: () {
                Navigator.pop(context); // { } braces wrap onTap function body
              }, 
             // closing brace } ends onTap
            ), // closing ) ends ListTile
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
               onTap: () {
                Navigator.pop(context); // { } braces wrap onTap function body
              }, 
            ),
            ListTile(
              title:Text('logout'),
               onTap: () {
                Navigator.pop(context); // { } braces wrap onTap function body
              },
              
            )
          ]
    ),
    ),
    );
  }
}