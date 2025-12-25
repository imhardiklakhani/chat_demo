import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/api/users_api.dart';
import '../../core/models/user_model.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial());

  Future<void> loadUsers() async {
    emit(UsersLoading());
    try {
      final users = await UsersApi.fetchUsers();
      emit(UsersSuccess(users));
    } catch (e) {
      emit(UsersError('Failed to load users'));
    }
  }

  void addLocalUser(String name) {
    if (state is! UsersSuccess) return;

    final parts = name.trim().split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.last : '';

    final newUser = UserModel(
      id: DateTime.now().millisecondsSinceEpoch,
      firstName: firstName,
      lastName: lastName,
      imageUrl: '',
      isOnline: true,
      lastActive: 'Just now',
    );

    final currentUsers = List<UserModel>.from(
      (state as UsersSuccess).users,
    );

    emit(UsersSuccess([newUser, ...currentUsers]));
  }
}