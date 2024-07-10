
import 'package:bloc/bloc.dart';
import '../../services/db_service.dart';
import 'my_search_event.dart';
import 'my_search_state.dart';

class MySearchBloc extends Bloc<MySearchEvent, MySearchState> {
  MySearchBloc() : super(MySearchInitialState()) {
    on<LoadSearchMembersEvent>(_onLoadSearchMembersEvent);
  }

  Future<void> _onLoadSearchMembersEvent(LoadSearchMembersEvent event, Emitter<MySearchState> emit) async {
    emit(MySearchLoadingState());

    var items =  await DBService.searchMembers(event.keyword);

    if (items.isNotEmpty) {
      emit(MySearchSuccessState(items: items));
    } else {
      emit(MySearchFailureState("No data"));
    }
  }
}
