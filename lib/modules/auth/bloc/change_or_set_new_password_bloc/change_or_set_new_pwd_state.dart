part of 'change_or_set_new_pwd_bloc.dart';

abstract class ChangeOrSetNewPwdState extends Equatable {
  const ChangeOrSetNewPwdState();
  @override
  List<Object> get props => [];
}

class ChangeOrSetNewPwdInitial extends ChangeOrSetNewPwdState {
  @override
  List<Object> get props => [];
}

class ChangeOrSetNewPwdLoading extends ChangeOrSetNewPwdState {
  @override
  List<Object> get props => [];
}

class ChangeOrSetNewPwdResponse extends ChangeOrSetNewPwdState {
  final ModelSuccess modelSuccess;

  const ChangeOrSetNewPwdResponse({required this.modelSuccess});
  @override
  List<Object> get props => [modelSuccess];
}

class ChangeOrSetNewPwdFailure extends ChangeOrSetNewPwdState {
  final ModelError errorMessage;

  const ChangeOrSetNewPwdFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
