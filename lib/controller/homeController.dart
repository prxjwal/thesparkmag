import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class WordPressController extends GetxController {
  var isLoading = true.obs;
  var posts = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
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

  Future<void> fetchPosts() async {
    isLoading(true);

    try {
      // Fetch data from WordPress API
      final response = await http.get(Uri.parse(
          'https://thesparkmag.000webhostapp.com/wp-json/wp/v2/posts'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        posts.value = jsonData;
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle exception
    } finally {
      isLoading(false);
    }
  }
}
