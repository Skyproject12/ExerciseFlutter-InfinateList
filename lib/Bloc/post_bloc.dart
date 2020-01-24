import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:infinate_list/Bloc/post_event.dart';
import 'package:infinate_list/Bloc/post_state.dart';
import 'package:infinate_list/Model/post.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  // defination hhttp clicent
  final http.Client httpClient;

  // memberi suatu @required http client
  PostBloc({@required this.httpClient});

// membungkinkan transform di jalankan sebelum mapEventToState
  @override  
  Stream<PostState> transformEvents( 
    Stream<PostEvent> events, 
    Stream<PostState> Function(PostEvent event) next
  ){ 
    return super.transformEvents( 
      events.debounceTime( 
        Duration(milliseconds: 500),
      ), 
      next
    );
  }

  @override
  // TODO: implement initialState
  PostState get initialState => PostUninitialized();

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    // initial state (jumlah) of list
    final currentState = state;
    // ketika suatu fungsi fetch di jalankan 
    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        // ketika current state memiliki status inisial
        if (currentState is PostUninitialized) {
          // maka data adalh kosong dan limit duapuluh
          final posts = await _fetchPosts(0, 20);
          // return postloaded dan inisialisasi bahwa readmax false
          yield PostLoaded(posts: posts, hasReachedMax: false);
          return;
        }
        // ketika status postloaded
        if (currentState is PostLoaded) {
          // initial jumlah post dan limit dari suatu post length
          final posts = await _fetchPosts(currentState.posts.length, 20);
          // jika post sudah mencapai batas maxsimum
          yield posts.isEmpty
              ? currentState.copyWith(hasReachedMa: true)
              // ketika post belum mencapai batas maximum
              : PostLoaded(
                  posts: currentState.posts + posts, hasReachedMax: false);
        }
      } on String catch (e) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

      Future <List<Post>> _fetchPosts(int startIndex, int limit) async {  
        // request api and convert the json type to variable object 
        final response = await httpClient.get( 
          'https://jsonplaceholder.typicode.com/posts?_start=$startIndex&_limit=$limit'
      ); 
        if(response.statusCode==200){ 
          final data = json.decode(response.body) as List; 
          return data.map((rawPost){ 
            return Post( 
              id: rawPost['id'], 
              title: rawPost['title'], 
              body: rawPost['body'],
            );
          }).toList(); 

        } 
        else{ 
          throw Exception('error fetching posts');
        }
      }
}
