import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/homeController.dart';

class Home extends StatelessWidget {
  final WordPressController controller = Get.put(WordPressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Spark')),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.posts.length,
                itemBuilder: (context, index) {
                  final post = controller.posts[index];
                  final featuredImageUrl =
                      controller.getFeaturedImageUrl(post['id']);

                  return FutureBuilder(
                    future: featuredImageUrl,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Card(
                          child: ListTile(
                            title: Text(post['title']['rendered']),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Card(
                          child: ListTile(
                            title: Text(post['title']['rendered']),
                            subtitle: Text('Error loading image'),
                          ),
                        );
                      } else {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(snapshot.data as String,
                                    fit: BoxFit.cover),
                              ),
                              ListTile(
                                title: Text(post['title']['rendered']),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
