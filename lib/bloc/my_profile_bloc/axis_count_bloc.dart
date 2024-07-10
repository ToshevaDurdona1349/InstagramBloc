import 'package:bloc/bloc.dart';

class AxisCountBloc extends Bloc<AxisCountEvent, int> {
  AxisCountBloc() : super(2) {
    on<AxisCountEvent>(_onChangeAxisCountEvent);
  }

  Future<void> _onChangeAxisCountEvent(AxisCountEvent event, Emitter<int> emit) async {
    emit(event.axisCount);
  }
}

class AxisCountEvent {
  int axisCount;

  AxisCountEvent({required this.axisCount});

  @override
  List<Object> get props => [];
}
