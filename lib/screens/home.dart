import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WordPressController controller = Get.put(WordPressController());

    return Scaffold(
      appBar: AppBar(title: Text('WordPress API')),
      body: Center(
        child: Obx(
          () => ListView.builder(
            itemCount: controller.posts.length,
            itemBuilder: (context, index) {
              final post = controller.posts[index];
              final featuredImageUrl = controller.imageUrls[index];

              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (featuredImageUrl != null)
                      CachedNetworkImage(
                        imageUrl: featuredImageUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    if (post != null)
                      ListTile(
                        title: Text(
                          post['title']['rendered'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class WordPressController extends GetxController {
  var isLoading = true.obs;
  var posts = <dynamic>[].obs;
  List<String?> imageUrls = [];

  WordPressController() {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading(true);

    try {
      // Fetch data from WordPress API
      final response = await http.get(Uri.parse(
          'https://thesparkmag.000webhostapp.com/wp-json/wp/v2/posts'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        posts.value = jsonData;

        // Pre-fetch image URLs
        imageUrls.clear();
        for (final post in jsonData) {
          final url = await getFeaturedImageUrl(post['id']);
          imageUrls.add(url);
        }
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle exception
    } finally {
      isLoading(false);
    }
  }

  Future<String?> getFeaturedImageUrl(int postId) async {
    try {
      var finalpostid = postId + 1;
      final response = await http.get(Uri.parse(
          'https://thesparkmag.000webhostapp.com/wp-json/wp/v2/media/$finalpostid'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData["guid"]['rendered'];
      } else {}
    } catch (e) {
      // Handle exception
    }

    return null;
  }
}
