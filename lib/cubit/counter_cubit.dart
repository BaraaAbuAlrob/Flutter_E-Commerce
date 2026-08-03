import 'package:bloc/bloc.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(CounterState(count: 0, hasIncremented: false));

  void increment() {
    emit(CounterState(count: state.count + 1, hasIncremented: true));
  }

  void decrement() {
    if (state.count > 0) {
      emit(CounterState(count: state.count - 1, hasIncremented: false));
    }
  }
}
