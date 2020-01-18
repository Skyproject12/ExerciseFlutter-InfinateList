import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:infinate_list/Bloc/post_state.dart';
import 'package:infinate_list/Bloc/simple_bloc_delegate.dart';
import 'package:infinate_list/Model/post.dart';
import 'Bloc/post_bloc.dart';
import 'Bloc/post_event.dart';

void main() { 
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Infinite Scroll', 
      home: Scaffold( 
        appBar: AppBar( 
          title: Text('Posts'),
        ), 
        body: BlocProvider( 
          // defination bloc
          create: (context)=> 
          PostBloc(httpClient : http.Client())..add(Fetch()), 
          child: HomePage(),
        ),
      ) 
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // defination scroll 
  final _scrollController = ScrollController(); 
  final _scrollThrshold = 200.0; 
  // defination postbloc 
  PostBloc _postBloc;

// scroll and postbloc can always refresh 
  @override
  void initState() {
    // TODO: implement initState
    super.initState(); 
    _scrollController.addListener(_onScoll); 
    _postBloc = BlocProvider.of<PostBloc>(context);
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>( 
      builder: (context, state){   
        // ketika status state yang di definisikan adalah inisial
        if(state is PostUninitialized){ 
          return Center( 
            child: CircularProgressIndicator(),
          );
        }  
        // ketika suatu state error 
        if(state is PostError){ 
          return Center( 
            child: Text(state.error),
          ); 
        }  
        // ketika suatu state postloaded 
        if(state is PostLoaded){  
          // jika data kosong
          if(state.post.isEmpty){ 
            return Center( 
              child: Text("no posts"),
            );
          }  
          // jika data tidak kosing 
          return ListView.builder( 
            itemBuilder: (BuildContext context, int index){  
              return index >= state.post.length 
              // jika jumlah data lebih atau sama dengan index
              ? BottomLoader()  
              // selain dari itu 
              : PostWidget(post: state.post[index]);
            }, 
            // jika list max  maka jumlah data  sebanyak jumlah post 
            itemCount: state.hasReachedMax 
            // jika belum max maka jumlah data sebanyak jumlah post pluss satu  
            ? state.post.length : state.post.length+1,
          );
        }
      }
    );
  }

  @override
  void dispose() { 
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _onScoll(){ 
    final maxScroll = _scrollController.position.maxScrollExtent; 
    final currentScroll = _scrollController.position.pixels; 
    if(maxScroll - currentScroll <= _scrollThrshold){ 
      _postBloc.add(Fetch());
    }
  }
  
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center, 
      child: Center( 
        child: SizedBox( 
          width: 33, 
          height: 33,
          child: CircularProgressIndicator( 
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget { 
  final Post post;
  const PostWidget({Key key, @required this.post}) : super (key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text( 
        '${post.id}', 
        style: TextStyle(fontSize: 10.0),
      ), 
      title: Text(post.title), 
      isThreeLine: true, 
      subtitle: Text(post.body),
      dense: true,
    );
  }
}