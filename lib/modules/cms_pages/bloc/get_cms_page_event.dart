part of 'get_cms_page_bloc.dart';

abstract class GetCmsPageEvent extends Equatable {
  const GetCmsPageEvent();
  @override
  List<Object> get props => [];
}
class GetCmsPage extends GetCmsPageEvent {
  final String url;

  const GetCmsPage({required this.url});
  @override
  List<Object> get props => [url];
}
