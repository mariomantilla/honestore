import 'package:flutter/material.dart';
import 'package:honestore/models/article.dart';
import 'package:honestore/services/data_service.dart';
import 'package:honestore/widgets/tab_title.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final client = sb.Supabase.instance.client;

class ArticlesTab extends StatefulWidget {
  const ArticlesTab({Key? key}) : super(key: key);

  @override
  State<ArticlesTab> createState() => _ArticlesTabState();
}

class _ArticlesTabState extends State<ArticlesTab> {
  List<Article>? articles;

  void loadArticles() async {
    setState(() {
      articles = null;
    });
    List<Article> newArticles = await DataService.getArticles();
    setState(() {
      articles = newArticles;
    });
  }

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    const loadingWidget = CircularProgressIndicator();
    return Column(
      children: [
        const TabTitle('Artículos'),
        articles == null ? loadingWidget : DisplayArticles(articles ?? [])
      ],
    );
  }
}

class DisplayArticles extends StatelessWidget {
  const DisplayArticles(this.articles, {Key? key}) : super(key: key);

  final List<Article> articles;

  @override
  Widget build(BuildContext context) {
    const noResults = Text('No se han encontrado resultados');
    return articles.isEmpty
        ? noResults
        : Expanded(
            child: ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                Article article = articles[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        //goToShop(context, shop);
                      },
                      child: ListTile(
                        title: Text(article.title),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        subtitle: Text(
                          article.authorName,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
