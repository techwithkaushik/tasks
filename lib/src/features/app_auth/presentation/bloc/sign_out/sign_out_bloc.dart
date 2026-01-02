import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/sign_out_usecase.dart';
import 'package:tasks/src/features/app_auth/domain/usecases/usecase.dart';

part 'sign_out_event.dart';
part 'sign_out_state.dart';

class SignOutBloc extends Bloc<SignOutEvent, SignOutState> {
  final SignOutUseCase signOutUseCase;

  SignOutBloc({required this.signOutUseCase}) : super(SignOutInitial()) {
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<SignOutState> emit,
  ) async {
    emit(SignOutLoading());

    final result = await signOutUseCase(const NoParams());

    result.fold(
      (failure) => emit(SignOutFailure(failure.message)),
      (_) => emit(SignOutSuccess()),
    );
  }
}
