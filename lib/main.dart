import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: 'Navegação Básica',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.brown,
    ),
    home: Onbording(),
  ));
}

class SegundaRota extends StatefulWidget {
  @override
  createState() => _SegundaRota();
}

class _SegundaRota extends State {
  Future<List<Category>> getCategoris() async {
    var url = Uri.parse("http://192.168.0.17:1337/Categories");
    var response = await http.get(url);
    var jsonString = response.body;
    List<Category> categories = categoryFromJson(jsonString);

    return categories;
  }

  @override
  void initState() {
    super.initState();
    // getCategoris().then((value) => print(value));
  }

  @override
  build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Escolha uma categoria!"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FutureBuilder<List<Category>>(
            future: getCategoris(),
            builder: (context, snapshot) {
              return snapshot.data == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1),
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (context, index) {
                          Category item = snapshot.data[index];
                          return InkWell(
                            child: GridTile(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                        image: NetworkImage(item.perfil.name),
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArticlesScreen(
                                        articlesList: item.articles,
                                        getNome: item.nome))),
                          );
                        },
                      ),
                    );
            },
          )
        ],
      ),
    );
  }
}

//Articles list screen
class ArticlesScreen extends StatelessWidget {
  final List<Article> articlesList;
  final getNome;

  const ArticlesScreen({Key key, this.articlesList, this.getNome})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getNome),
      ),
      body: ListView.builder(
        itemCount: articlesList.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(5),
            child: Card(
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Text(
                  articlesList[index].nome,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                ),
                subtitle: Text(articlesList[index].brevedescricao,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage:
                      NetworkImage(articlesList[index].perfil.name),
                ),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailsScreen(
                            articleDetails: articlesList[index]))),
              ),
            ),
          );
        },
      ),
    );
  }
}

//Details Screen

final List<String> imgList = [
  'https://static.portaldacidade.com/unsafe/1150x767/https://s3.amazonaws.com/louveira.portaldacidade.com/img/news/2019-12/dj-alok-fara-show-de-encerramento-da-festa-da-uva-de-louveira-2019-5df69d53a798f.jpg',
  'https://ondasulderondonia.com.br/fk_imagens/RTEmagicC_dj-alok-capa_01_jpg.jpg',
  'https://capricho.abril.com.br/wp-content/uploads/2017/08/alok-palco-desaba-presidente-prudente.jpg',
];

class DetailsScreen extends StatelessWidget {
  final Article articleDetails;
  final List<PerfilElement> feed;

  const DetailsScreen({Key key, this.articleDetails, this.feed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(articleDetails.nome),
      ),
      body: Container(
        color: Colors.grey[300],
        child: Column(
          children: <Widget>[
            Container(
              child: Expanded(
                flex: 5,
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: CarouselSlider(
                          items: imgList
                              .map((item) => SizedBox(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.07,
                                      child: SizedBox(
                                        child: Image.network(
                                          item,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          options: CarouselOptions(
                            height: 300,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            enlargeCenterPage: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
                flex: 4,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: NetworkImage(articleDetails.perfil.name),
                                fit: BoxFit.cover)),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        color: Colors.white,
                        child: Text(
                          articleDetails.descricao,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.59),
                        ),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              child: Container(
                //color: Colors.brown,
                height: MediaQuery.of(context).size.height * 0.08,
                width: double.infinity,
                padding: EdgeInsets.only(top: 10),
                child: Expanded(
                    flex: 1,
                    child: RaisedButton(
                      color: Colors.brown,
                      child: Text(
                        "Contato",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        showAlertDialog1(context);
                      },
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog1(BuildContext context) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("OK", style: TextStyle(fontSize: 19)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text("Contato",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23)),
      content: Text(articleDetails.contato, style: TextStyle(fontSize: 18)),
      actions: [
        okButton,
      ],
    );
    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }
}

//category class

List<Category> categoryFromJson(String str) =>
    List<Category>.from(json.decode(str).map((x) => Category.fromJson(x)));

String categoryToJson(List<Category> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Category {
  Category({
    this.id,
    this.nome,
    this.createdAt,
    this.updatedAt,
    this.perfil,
    this.articles,
  });

  int id;
  String nome;
  DateTime createdAt;
  DateTime updatedAt;
  PerfilElement perfil;
  List<Article> articles;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        nome: json["nome"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        perfil: PerfilElement.fromJson(json["perfil"]),
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "perfil": perfil.toJson(),
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  Article({
    this.id,
    this.nome,
    this.brevedescricao,
    this.descricao,
    this.contato,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.perfil,
    this.feed,
  });

  int id;
  String nome;
  String brevedescricao;
  String descricao;
  String contato;
  int category;
  DateTime createdAt;
  DateTime updatedAt;
  PurplePerfil perfil;
  List<PerfilElement> feed;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json["id"],
        nome: json["nome"],
        brevedescricao: json["brevedescricao"],
        descricao: json["descricao"],
        contato: json["contato"],
        category: json["category"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        perfil: PurplePerfil.fromJson(json["perfil"]),
        feed: List<PerfilElement>.from(
            json["feed"].map((x) => PerfilElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nome": nome,
        "brevedescricao": brevedescricao,
        "descricao": descricao,
        "contato": contato,
        "category": category,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "perfil": perfil.toJson(),
        "feed": List<dynamic>.from(feed.map((x) => x.toJson())),
      };
}

class PerfilElement {
  PerfilElement({
    this.id,
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.previewUrl,
    this.provider,
    this.providerMetadata,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String alternativeText;
  String caption;
  int width;
  int height;
  FeedFormats formats;
  String hash;
  Ext ext;
  Mime mime;
  double size;
  String url;
  dynamic previewUrl;
  Provider provider;
  dynamic providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  factory PerfilElement.fromJson(Map<String, dynamic> json) => PerfilElement(
        id: json["id"],
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: FeedFormats.fromJson(json["formats"]),
        hash: json["hash"],
        ext: extValues.map[json["ext"]],
        mime: mimeValues.map[json["mime"]],
        size: json["size"].toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        provider: providerValues.map[json["provider"]],
        providerMetadata: json["provider_metadata"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width,
        "height": height,
        "formats": formats.toJson(),
        "hash": hash,
        "ext": extValues.reverse[ext],
        "mime": mimeValues.reverse[mime],
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": providerValues.reverse[provider],
        "provider_metadata": providerMetadata,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

enum Ext { JPG, EMPTY, WEBP }

final extValues =
    EnumValues({"": Ext.EMPTY, ".jpg": Ext.JPG, ".webp": Ext.WEBP});

class FeedFormats {
  FeedFormats({
    this.thumbnail,
    this.small,
    this.large,
    this.medium,
  });

  Thumbnail thumbnail;
  Thumbnail small;
  Thumbnail large;
  Thumbnail medium;

  factory FeedFormats.fromJson(Map<String, dynamic> json) => FeedFormats(
        thumbnail: Thumbnail.fromJson(json["thumbnail"]),
        small: json["small"] == null ? null : Thumbnail.fromJson(json["small"]),
        large: json["large"] == null ? null : Thumbnail.fromJson(json["large"]),
        medium:
            json["medium"] == null ? null : Thumbnail.fromJson(json["medium"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail.toJson(),
        "small": small == null ? null : small.toJson(),
        "large": large == null ? null : large.toJson(),
        "medium": medium == null ? null : medium.toJson(),
      };
}

class Thumbnail {
  Thumbnail({
    this.name,
    this.hash,
    this.ext,
    this.mime,
    this.width,
    this.height,
    this.size,
    this.path,
    this.url,
  });

  String name;
  String hash;
  Ext ext;
  Mime mime;
  int width;
  int height;
  double size;
  dynamic path;
  String url;

  factory Thumbnail.fromJson(Map<String, dynamic> json) => Thumbnail(
        name: json["name"],
        hash: json["hash"],
        ext: extValues.map[json["ext"]],
        mime: mimeValues.map[json["mime"]],
        width: json["width"],
        height: json["height"],
        size: json["size"].toDouble(),
        path: json["path"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "hash": hash,
        "ext": extValues.reverse[ext],
        "mime": mimeValues.reverse[mime],
        "width": width,
        "height": height,
        "size": size,
        "path": path,
        "url": url,
      };
}

enum Mime { IMAGE_JPEG, IMAGE_PNG, IMAGE_WEBP }

final mimeValues = EnumValues({
  "image/jpeg": Mime.IMAGE_JPEG,
  "image/png": Mime.IMAGE_PNG,
  "image/webp": Mime.IMAGE_WEBP
});

enum Provider { LOCAL }

final providerValues = EnumValues({"local": Provider.LOCAL});

class PurplePerfil {
  PurplePerfil({
    this.id,
    this.name,
    this.alternativeText,
    this.caption,
    this.width,
    this.height,
    this.formats,
    this.hash,
    this.ext,
    this.mime,
    this.size,
    this.url,
    this.previewUrl,
    this.provider,
    this.providerMetadata,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String alternativeText;
  String caption;
  int width;
  int height;
  PurpleFormats formats;
  String hash;
  Ext ext;
  Mime mime;
  double size;
  String url;
  dynamic previewUrl;
  Provider provider;
  dynamic providerMetadata;
  DateTime createdAt;
  DateTime updatedAt;

  factory PurplePerfil.fromJson(Map<String, dynamic> json) => PurplePerfil(
        id: json["id"],
        name: json["name"],
        alternativeText: json["alternativeText"],
        caption: json["caption"],
        width: json["width"],
        height: json["height"],
        formats: PurpleFormats.fromJson(json["formats"]),
        hash: json["hash"],
        ext: extValues.map[json["ext"]],
        mime: mimeValues.map[json["mime"]],
        size: json["size"].toDouble(),
        url: json["url"],
        previewUrl: json["previewUrl"],
        provider: providerValues.map[json["provider"]],
        providerMetadata: json["provider_metadata"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "alternativeText": alternativeText,
        "caption": caption,
        "width": width,
        "height": height,
        "formats": formats.toJson(),
        "hash": hash,
        "ext": extValues.reverse[ext],
        "mime": mimeValues.reverse[mime],
        "size": size,
        "url": url,
        "previewUrl": previewUrl,
        "provider": providerValues.reverse[provider],
        "provider_metadata": providerMetadata,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class PurpleFormats {
  PurpleFormats({
    this.thumbnail,
    this.small,
  });

  Thumbnail thumbnail;
  Thumbnail small;

  factory PurpleFormats.fromJson(Map<String, dynamic> json) => PurpleFormats(
        thumbnail: Thumbnail.fromJson(json["thumbnail"]),
        small: json["small"] == null ? null : Thumbnail.fromJson(json["small"]),
      );

  Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail.toJson(),
        "small": small == null ? null : small.toJson(),
      };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
