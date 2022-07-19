part of 'list_bloc.dart';

abstract class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object?> get props => [];
}

class ListStarted extends ListEvent {
  final SortType sortType;
  final ViewType viewType;

  const ListStarted(this.sortType, this.viewType);

  @override
  List<Object?> get props => [sortType];
}
