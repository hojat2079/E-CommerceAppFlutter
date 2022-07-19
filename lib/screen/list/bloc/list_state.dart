part of 'list_bloc.dart';

abstract class ListState extends Equatable {
  const ListState();

  @override
  List<Object> get props => [];
}

class ListLoading extends ListState {}

class ListSuccess extends ListState {
  final SortType sortType;
  final ViewType viewType;
  final List<ProductEntity> products;
  final List<String> sortList;

  const ListSuccess(this.sortType, this.products, this.sortList, this.viewType);

  @override
  List<Object> get props => [sortType, sortList, products];
}

class ListError extends ListState {
  final CustomError customError;

  const ListError(this.customError);

  @override
  List<Object> get props => [customError];
}
