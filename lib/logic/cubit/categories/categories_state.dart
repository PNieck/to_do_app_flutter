part of 'categories_cubit.dart';

@immutable
abstract class CategoriesState {}

class CategoriesInitialState extends CategoriesState {}

class CategoriesReady extends CategoriesState {
  final List<EventCategory> categories;

  CategoriesReady(this.categories);
}

class CategoriesLoading extends CategoriesState {}

class CategoriesError extends CategoriesState {}
