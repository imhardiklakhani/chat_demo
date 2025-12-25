import '../../core/models/user_model.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersSuccess extends UsersState {
  final List<UserModel> users;
  UsersSuccess(this.users);
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}