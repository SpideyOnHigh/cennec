part of 'get_cms_page_bloc.dart';

class GetCmsPageState extends Equatable {
  const GetCmsPageState();
  @override
  List<Object> get props => [];
}

class GetCmsPageInitial extends GetCmsPageState {
  @override
  List<Object> get props => [];
}

class GetCmsPageLoading extends GetCmsPageState {
  @override
  List<Object> get props => [];
}

class GetCmsPageResponse extends GetCmsPageState {
  final String modelCms;

  const GetCmsPageResponse({required this.modelCms});
  @override
  List<Object> get props => [modelCms];
}

class GetCmsPageFailure extends GetCmsPageState {
  final ModelError errorMessage;

  const GetCmsPageFailure({required this.errorMessage});
  @override
  List<Object> get props => [errorMessage];
}
