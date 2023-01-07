import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/divisions.dart';
import '../pages/groups.dart';
import '../pages/index.dart';
import '../pages/locations.dart';
import '../pages/profile.dart';
import '../pages/regions.dart';

enum PageVal { dashboard, regions, divisions, groups, locations, profile }

enum Bool { activate, deactivate }

class ExitModal extends Bloc<Bool, bool> {
  ExitModal() : super(false) {
    on<Bool>((event, emit) {
      switch (event) {
        case Bool.activate:
          emit(true);
          break;
        case Bool.deactivate:
          emit(false);
          break;
      }
    });
  }
}

abstract class PageState {}

class PageBloc extends Bloc<PageVal, PageState> {
  PageBloc() : super(const Dashboard()) {
    on<PageVal>((event, emit) {
      switch (event) {
        case PageVal.dashboard:
          emit(const Dashboard());
          break;
        case PageVal.regions:
          emit(const Regions());
          break;
        case PageVal.divisions:
          emit(const Divisions());
          break;
        case PageVal.groups:
          emit(const Groups());
          break;
        case PageVal.locations:
          emit(const Locations());
          break;
        case PageVal.profile:
          emit(const Profile());
          break;
      }
    });
  }
}

class MenuBloc extends Bloc<PageVal, int> {
  MenuBloc() : super(0) {
    on<PageVal>((event, emit) {
      switch (event) {
        case PageVal.dashboard:
          emit(0);
          break;
        case PageVal.regions:
          emit(1);
          break;
        case PageVal.divisions:
          emit(2);
          break;
        case PageVal.groups:
          emit(3);
          break;
        case PageVal.locations:
          emit(4);
          break;
        case PageVal.profile:
          emit(5);
          break;
      }
    });
  }
}

class MenuState extends Bloc<Bool, bool> {
  MenuState() : super(false) {
    on<Bool>((event, emit) {
      switch (event) {
        case Bool.activate:
          emit(true);
          break;
        case Bool.deactivate:
          emit(false);
          break;
      }
    });
  }
}

/*class WelcomeBloc extends ChangeNotifier {
  int _state = 0;

  int get state => _state;

  void splash() {
    _state = 0;
    notifyListeners();
  }

  void join() {
    _state = 1;
    notifyListeners();
  }

  void login() {
    _state = 2;
    notifyListeners();
  }
}*/

/*class MainLayerBloc extends Bloc<MainLayerEvents, int> {
  MainLayerBloc() : super(0);

  @override
  Stream<int> mapEventToState(MainLayerEvents event) async* {
    switch (event) {
      case MainLayerEvents.Index:
        yield 0;
        break;
      case MainLayerEvents.Statistics:
        yield 1;
        break;
      case MainLayerEvents.Profile:
        yield 2;
        break;
      case MainLayerEvents.Settings:
        yield 3;
        break;
    }
  }
}*/
