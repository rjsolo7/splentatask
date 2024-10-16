import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splentatask/widgets/post_form.dart';
import '../providers/post_provider.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PostProvider>(context, listen: false).fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Post List')),
      body: postProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : postProvider.hasError
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: ${postProvider.errorMessage}'),
            ElevatedButton(
              onPressed: () {
                postProvider.fetchPosts();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : Scrollbar(
        child: ListView.builder(
          itemCount: postProvider.posts.length,
          itemBuilder: (context, index) {
            final post = postProvider.posts[index];
            return AnimatedCard(
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        post['title'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    const Divider(),  // Divider between title and body
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        post['body'],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      
      floatingActionButton:postProvider.hasResult?
          FloatingActionButton(onPressed: (){    Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>  DynamicFormPage(apiResponse: postProvider.posts,),
          ));},child: Text("Add"),):SizedBox() ,
    );
  }
}

class AnimatedCard extends StatelessWidget {
  final Widget child;

  const AnimatedCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 50), // Slide in animation
            child: child,
          ),
        );

      },
      child: child,
    );
  }
}
