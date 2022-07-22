import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/data/entity/product_entity.dart';
import 'package:ecommerce_app/data/repository/product_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final ProductRepository productRepository;

  FavoriteBloc(this.productRepository)
      : super(FavoriteInitial(productRepository.getListenable())) {
    on<FavoriteEvent>((event, emit) async {
      if (event is FavoriteStarted) {
      } else if (event is FavoriteDeleteItem) {
        await productRepository.delete(event.productEntity);
      }
    });
  }
}
