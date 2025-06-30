part of 'block_user_bloc.dart';

abstract class BlockUserState extends Equatable {
  const BlockUserState();
}

class BlockUserInitial extends BlockUserState {
  @override
  List<Object> get props => [];
}

class BlockUserLoading extends BlockUserState {
  @override
  List<Object> get props => [];
}

class BlockUserResponse extends BlockUserState {
  final ModelBlockResponse modelBlockResponse;

  const BlockUserResponse({required this.modelBlockResponse});
  @override
  List<Object> get props => [modelBlockResponse];
}

class BlockUserFailure extends BlockUserState {
  final ModelError errorMessage;

  const BlockUserFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
