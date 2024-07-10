import 'package:bloc/bloc.dart';

import '../../model/post_model.dart';
import '../../services/db_service.dart';
import 'my_feed_event.dart';
import 'my_feed_state.dart';

class MyFeedBloc extends Bloc<MyFeedEvent, MyFeedState> {

  List<Post> items = [];

  MyFeedBloc() : super(MyFeedInitialState()) {
    on<LoadFeedPostsEvent>(_onLoadFeedPostsEvent);
    on<RemoveFeedPostEvent>(_onRemoveFeedPostEvent);
  }

  Future<void> _onLoadFeedPostsEvent(LoadFeedPostsEvent event, Emitter<MyFeedState> emit) async {
    emit(MyFeedLoadingState());

    var posts = await DBService.loadFeeds();
    items.clear();
    items.addAll(posts);

    if (posts.isNotEmpty) {
      emit(MyFeedSuccessState(items: items));
    } else {
      emit(MyFeedFailureState("No data"));
    }
  }

  Future<void> _onRemoveFeedPostEvent(RemoveFeedPostEvent event, Emitter<MyFeedState> emit) async {
    emit(MyFeedLoadingState());
    await DBService.removePost(event.post);
    emit(RemoveFeedPostState());
  }
}
