import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:to_do_app_flutter/data/models/event_category.dart';
import 'package:to_do_app_flutter/data/repositories/categories_repository.dart';
import 'package:to_do_app_flutter/logic/cubit/login/login_cubit.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  LoginCubit loginCubit;

  CategoriesCubit({required this.loginCubit}) : super(CategoriesInitialState());

  Future<void> readCategories() async {
    emit(CategoriesLoading());
    LoginState loginState = loginCubit.state;

    if (loginState is LoggedIn) {
      CategoriesRepository repo = CategoriesRepository(loginState.user);
      List<EventCategory> data = await repo.readCategories();

      emit(CategoriesReady(data));
    } else {
      emit(CategoriesError());
    }
  }

  Future<void> createCategory(EventCategory newCategory) async {
    emit(CategoriesLoading());
    LoginState loginState = loginCubit.state;

    if (loginState is LoggedIn) {
      CategoriesRepository repo = CategoriesRepository(loginState.user);
      await repo.createCategory(newCategory);

      List<EventCategory> data = await repo.readCategories();
      emit(CategoriesReady(data));
    }
  }

  Future<void> updateCategory(EventCategory category) async {
    emit(CategoriesLoading());
    LoginState loginState = loginCubit.state;

    if (loginState is LoggedIn) {
      CategoriesRepository repo = CategoriesRepository(loginState.user);
      await repo.updateCategory(category);

      List<EventCategory> data = await repo.readCategories();
      emit(CategoriesReady(data));
    }

    emit(CategoriesError());
  }

  void deleteCategory(EventCategory category) => emit(CategoriesLoading());
}
