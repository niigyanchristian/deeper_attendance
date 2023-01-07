import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../functions/app.dart';
import '../models/app.dart';
import '../models/cloud.dart';
import '../services/cloud.dart';

class CloudCtx extends GetxController {
  final Rx<Admin> _admin = Admin(
    username: "",
    uid: "",
    profile: "",
    position: "",
    areaID: "",
    area: "",
    others: [],
  ).obs;

  set admin(Admin admin) => _admin.value = admin;

  Admin get admin => _admin.value;

  final Rxn<List<RegionModel>> _regionsList = Rxn<List<RegionModel>>();
  final Rxn<List<DivisionModel>> _divisionsList = Rxn<List<DivisionModel>>();
  final Rxn<List<GroupModel>> _groupsList = Rxn<List<GroupModel>>();
  final Rxn<List<LocalModel>> _locationsList = Rxn<List<LocalModel>>();
  final Rxn<List<ServiceModel>> _services = Rxn<List<ServiceModel>>();
  final Rxn<List<Years>> _yearsList = Rxn<List<Years>>();
  String _service = "All Service";
  final List<SelectedSection> _section = [];
  String thisYear = DateFormat("y").format(DateTime.now());

  /* For selected section with events */
  List<ServiceModel>? _sSun;
  List<ServiceModel>? _sBib;
  List<ServiceModel>? _sRev;
  List<ServiceModel>? _sOth;

  /* For selected section */
  List<ServiceModel>? _seSun;
  List<ServiceModel>? _seBib;
  List<ServiceModel>? _seRev;
  List<ServiceModel>? _seOth;

  void clear() {
    _admin.value = Admin(
      username: "",
      uid: "",
      profile: "",
      position: "",
      areaID: "",
      area: "",
      others: [],
    );
  }

  @override
  void onInit() {
    _regionsList.bindStream(Cloud().regions);
    _divisionsList.bindStream(Cloud().divisions);
    _groupsList.bindStream(Cloud().groups);
    _locationsList.bindStream(Cloud().locals);
    _yearsList.bindStream(Cloud().years);
    _services.bindStream(Cloud().services);
    _section.add(
        SelectedSection(area: "", areaID: "", type: "", isSection: false));
    super.onInit();
  }

  List<ServiceModel> get services => _services.value!;

  List<ServiceModel> get sundays =>
      services.where((element) => element.service == "sundays").toList();

  List<ServiceModel> get bibles =>
      services.where((element) => element.service == "bibles").toList();

  List<ServiceModel> get revivals =>
      services.where((element) => element.service == "revivals").toList();

  List<ServiceModel> get others =>
      services.where((element) => element.service == "others").toList();


  List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  wr(list, String profile) {
    switch (profile) {
      case "region":
        return list.regionID;
      case "division":
        return list.divisionID;
      case "group":
        return list.groupID;
      case "location":
        return list.localID;
      case "reviewer":
        return list.localID;
    }
  }

  /* Calc Offer */
  List co(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        double total = 0;
        for (var list in myList) {
          total += list.offerings![0];
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      double total = 0;
      for (var list in myList) {
        total += list.offerings![0];
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        double total = 0;
        for (var list in myList) {
          total += list.offerings![0];
        }

        data.add(total);
      }
    } else {
      double total = 0;
      for (var list in lists) {
        total += list.offerings![0];
      }

      data.add(total);
    }

    return data;
  }

  /* Calc Offer */
  List co1(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        double total = 0;
        for (var list in myList) {
          total += list.offerings![1];
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      double total = 0;
      for (var list in myList) {
        total += list.offerings![1];
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        double total = 0;
        for (var list in myList) {
          total += list.offerings![1];
        }

        data.add(total);
      }
    } else {
      double total = 0;
      for (var list in lists) {
        total += list.offerings![1];
      }

      data.add(total);
    }

    return data;
  }

  /* total attendance */
  List ta(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        int total = 0;
        for (var list in myList) {
          total += list.attendants as int;
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      int total = 0;
      for (var list in myList) {
        total += list.attendants as int;
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        int total = 0;
        for (var list in myList) {
          total += list.attendants as int;
        }

        data.add(total);
      }
    } else {
      int total = 0;
      for (var list in lists) {
        total += list.attendants as int;
      }

      data.add(total);
    }

    return data;
  }

  /* total adults males */
  List tam(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        int total = 0;
        for (var list in myList) {
          total += list.adults![0] as int;
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      int total = 0;
      for (var list in myList) {
        total += list.adults![0] as int;
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        int total = 0;
        for (var list in myList) {
          total += list.adults![0] as int;
        }

        data.add(total);
      }
    } else {
      int total = 0;
      for (var list in lists) {
        total += list.adults![0] as int;
      }

      data.add(total);
    }

    return data;
  }

  /* total adults females */
  List taf(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        int total = 0;
        for (var list in myList) {
          total += list.adults![1] as int;
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      int total = 0;
      for (var list in myList) {
        total += list.adults![1] as int;
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        int total = 0;
        for (var list in myList) {
          total += list.adults![1] as int;
        }

        data.add(total);
      }
    } else {
      int total = 0;
      for (var list in lists) {
        total += list.adults![1] as int;
      }

      data.add(total);
    }

    return data;
  }

  /* total youth males */
  List tym(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        int total = 0;
        for (var list in myList) {
          total += list.youth![0] as int;
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      int total = 0;
      for (var list in myList) {
        total += list.youth![0] as int;
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        int total = 0;
        for (var list in myList) {
          total += list.youth![0] as int;
        }

        data.add(total);
      }
    } else {
      int total = 0;
      for (var list in lists) {
        total += list.youth![0] as int;
      }

      data.add(total);
    }

    return data;
  }

  /* total youth females */
  List tyf(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        int total = 0;
        for (var list in myList) {
          total += list.youth![1] as int;
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      int total = 0;
      for (var list in myList) {
        total += list.youth![1] as int;
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        int total = 0;
        for (var list in myList) {
          total += list.youth![1] as int;
        }

        data.add(total);
      }
    } else {
      int total = 0;
      for (var list in lists) {
        total += list.youth![1] as int;
      }

      data.add(total);
    }

    return data;
  }

  /* total children males */
  List tim(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        int total = 0;
        for (var list in myList) {
          total += list.children![0] as int;
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      int total = 0;
      for (var list in myList) {
        total += list.children![0] as int;
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        int total = 0;
        for (var list in myList) {
          total += list.children![0] as int;
        }

        data.add(total);
      }
    } else {
      int total = 0;
      for (var list in lists) {
        total += list.children![0] as int;
      }

      data.add(total);
    }

    return data;
  }

  /* total children females */
  List tif(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        int total = 0;
        for (var list in myList) {
          total += list.children![1] as int;
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      int total = 0;
      for (var list in myList) {
        total += list.children![1] as int;
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        int total = 0;
        for (var list in myList) {
          total += list.children![1] as int;
        }

        data.add(total);
      }
    } else {
      int total = 0;
      for (var list in lists) {
        total += list.children![1] as int;
      }

      data.add(total);
    }

    return data;
  }

  /* total newcomers */
  List tn(List lists, Admin? user, String? year) {
    List data = [];

    if (year != null && user != null) {
      for (String month in months) {
        List myList = lists
            .where((list) =>
        user.profile == "national" || user.profile == ""
            ? list.month == month && list.year == year
            : list.month == month &&
            list.year == year &&
            wr(list, user.profile!) == user.areaID)
            .toList();
        int total = 0;
        for (var list in myList) {
          total += list.newcomers as int;
        }

        data.add(total);
      }
    } else if (user != null) {
      List myList = user.profile == "national" || user.profile == ""
          ? lists
          : lists
          .where((list) => wr(list, user.profile!) == user.areaID)
          .toList();
      int total = 0;
      for (var list in myList) {
        total += list.newcomers as int;
      }

      data.add(total);
    } else if (_section.last.isSection!) {
      for (String month in months) {
        List myList = lists
            .where((list) => list.month == month).toList();
        int total = 0;
        for (var list in myList) {
          total += list.newcomers as int;
        }

        data.add(total);
      }
    } else {
      int total = 0;
      for (var list in lists) {
        total += list.newcomers as int;
      }

      data.add(total);
    }

    return data;
  }

  /* total adults */
  List tas(List lists, Admin? user, String? year) {
    List data = [];

    if ((year != null && user != null) || _section.last.isSection!) {
      for (String month in months) {
        int total = 0;
        total = tam(lists, user, year)[months.indexOf(month)] +
            taf(lists, user, year)[months.indexOf(month)];
        data.add(total);
      }
    } else {
      int total = 0;
      total = tam(lists, user, year).first + taf(lists, user, year).first;
      data.add(total);
    }

    return data;
  }

  /* total youth */
  List ty(List lists, Admin? user, String? year) {
    List data = [];

    if ((year != null && user != null) || _section.last.isSection!) {
      for (String month in months) {
        int total = 0;
        total = tym(lists, user, year)[months.indexOf(month)] +
            tyf(lists, user, year)[months.indexOf(month)];
        data.add(total);
      }
    } else {
      int total = 0;
      total = tym(lists, user, year).first + tyf(lists, user, year).first;
      data.add(total);
    }

    return data;
  }

  /* total children */
  List ti(List lists, Admin? user, String? year) {
    List data = [];

    if ((year != null && user != null) || _section.last.isSection!) {
      for (String month in months) {
        int total = 0;
        total = tim(lists, user, year)[months.indexOf(month)] +
            tif(lists, user, year)[months.indexOf(month)];
        data.add(total);
      }
    } else {
      int total = 0;
      total = tim(lists, user, year).first + tif(lists, user, year).first;
      data.add(total);
    }

    return data;
  }

  /* total attendance male */
  List tma(List lists, Admin? user, String? year) {
    List data = [];

    if ((year != null && user != null) || _section.last.isSection!) {
      for (String month in months) {
        int total = 0;
        total = tam(lists, user, year)[months.indexOf(month)] +
            tym(lists, user, year)[months.indexOf(month)] +
            tim(lists, user, year)[months.indexOf(month)];
        data.add(total);
      }
    } else {
      int total = 0;
      total = tam(lists, user, year).first +
          tym(lists, user, year).first +
          tim(lists, user, year).first;
      data.add(total);
    }

    return data;
  }

  /* total attendance female */
  List tfa(List lists, Admin? user, String? year) {
    List data = [];

    if ((year != null && user != null) || _section.last.isSection!) {
      for (String month in months) {
        int total = 0;
        total = taf(lists, user, year)[months.indexOf(month)] +
            tyf(lists, user, year)[months.indexOf(month)] +
            tif(lists, user, year)[months.indexOf(month)];
        data.add(total);
      }
    } else {
      int total = 0;
      total = taf(lists, user, year).first +
          tyf(lists, user, year).first +
          tif(lists, user, year).first;
      data.add(total);
    }

    return data;
  }

  List all(other, sunday, revival, bible) {
    List data = [];
    /*print(sunday);*/
    for (String month in months) {
      dynamic total = 0;
      total = other[months.indexOf(month)] +
          sunday[months.indexOf(month)] +
          revival[months.indexOf(month)] +
          bible[months.indexOf(month)];
      data.add(total);
    }

    return data;
  }

  void changeService(String service) {
    _service = service;
    update();
  }

  void addSelected(SelectedSection section) {
    _seSun = sundays
        .where((ele) => wr(ele, section.type!) == section.areaID)
        .toList();
    _seBib = bibles
        .where((ele) => wr(ele, section.type!) == section.areaID)
        .toList();
    _seRev = revivals
        .where((ele) => wr(ele, section.type!) == section.areaID)
        .toList();
    _seOth = others
        .where((ele) => wr(ele, section.type!) == section.areaID)
        .toList();
    _section.add(section);
    update();
  }

  void removeSelected(SelectedSection section) {
    _section.removeWhere((ele) => ele == section);
    _seSun = sundays
        .where((ele) => wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    _seBib = bibles
        .where((ele) => wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    _seRev = revivals
        .where((ele) => wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    _seOth = others
        .where((ele) => wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    update();
  }

  void changeDateAll(DateTime datetime) {
    _sSun = admin.profile == "national" || admin.profile == ""
        ? sundays
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime)
        .toList()
        : sundays
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime &&
        wr(ele, admin.profile!) == admin.areaID)
        .toList();
    _sBib = admin.profile == "national" || admin.profile == ""
        ? bibles
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime)
        .toList()
        : bibles
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime &&
        wr(ele, admin.profile!) == admin.areaID)
        .toList();
    _sRev = admin.profile == "national" || admin.profile == ""
        ? revivals
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime)
        .toList()
        : revivals
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime &&
        wr(ele, admin.profile!) == admin.areaID)
        .toList();
    _sOth = admin.profile == "national" || admin.profile == ""
        ? others
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime)
        .toList()
        : others
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime &&
        wr(ele, admin.profile!) == admin.areaID)
        .toList();
    update();
  }

  void changeDate(DateTime datetime) {
    _sSun = sundays
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    _sBib = bibles
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    _sRev = revivals
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    _sOth = others
        .where((ele) =>
    fxn.changeDate(ele.datetime == null ? datetime : ele.datetime!.toDate()) ==
        datetime &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    update();
  }

  void changeMonth(String month, String year) {
    _sSun = _section.last.type == "national"
        ? sundays
        .where((ele) => ele.month == month && ele.year == year)
        .toList()
        : sundays
        .where((ele) =>
    ele.month == month &&
        ele.year == year &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sBib = _section.last.type == "national"
        ? bibles
        .where((ele) => ele.month == month && ele.year == year)
        .toList()
        : bibles
        .where((ele) =>
    ele.month == month &&
        ele.year == year &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sRev = _section.last.type == "national"
        ? revivals
        .where((ele) => ele.month == month && ele.year == year)
        .toList()
        : revivals
        .where((ele) =>
    ele.month == month &&
        ele.year == year &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sOth = _section.last.type == "national"
        ? others
        .where((ele) => ele.month == month && ele.year == year)
        .toList()
        : others
        .where((ele) =>
    ele.month == month &&
        ele.year == year &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    update();
  }

  void changeYear(String year) {
    _sSun = _section.last.type == "national"
        ? sundays.where((ele) => ele.year == year).toList()
        : sundays
        .where((ele) =>
    ele.year == year && wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sBib = _section.last.type == "national"
        ? bibles.where((ele) => ele.year == year).toList()
        : bibles
        .where((ele) =>
    ele.year == year && wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sRev = _section.last.type == "national"
        ? revivals.where((ele) => ele.year == year).toList()
        : revivals
        .where((ele) =>
    ele.year == year && wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sOth = _section.last.type == "national"
        ? others.where((ele) => ele.year == year).toList()
        : others
        .where((ele) =>
    ele.year == year && wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    update();
  }

  void changeDateDiff(DateTime begin, DateTime end) {
    _sSun = _section.last.type == "national"
        ? sundays
        .where((ele) =>
    (fxn
        .changeDate(
        ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
        .isAtSameMomentAs(begin) ||
        fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAfter(begin)) &&
        (fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAtSameMomentAs(end) ||
            fxn.changeDate(
                ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
                .isBefore(end)))
        .toList()
        : sundays
        .where((ele) =>
    (fxn
        .changeDate(
        ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
        .isAtSameMomentAs(begin) ||
        fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAfter(begin)) &&
        (fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAtSameMomentAs(end) ||
            fxn.changeDate(
                ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
                .isBefore(end)) &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sBib = _section.last.type == "national"
        ? bibles
        .where((ele) =>
    (fxn
        .changeDate(
        ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
        .isAtSameMomentAs(begin) ||
        fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAfter(begin)) &&
        (fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAtSameMomentAs(end) ||
            fxn.changeDate(
                ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
                .isBefore(end)))
        .toList()
        : bibles
        .where((ele) =>
    (fxn
        .changeDate(
        ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
        .isAtSameMomentAs(begin) ||
        fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAfter(begin)) &&
        (fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAtSameMomentAs(end) ||
            fxn.changeDate(
                ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
                .isBefore(end)) &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sRev = _section.last.type == "national"
        ? revivals
        .where((ele) =>
    (fxn
        .changeDate(
        ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
        .isAtSameMomentAs(begin) ||
        fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAfter(begin)) &&
        (fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAtSameMomentAs(end) ||
            fxn.changeDate(
                ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
                .isBefore(end)))
        .toList()
        : revivals
        .where((ele) =>
    (fxn
        .changeDate(
        ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
        .isAtSameMomentAs(begin) ||
        fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAfter(begin)) &&
        (fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAtSameMomentAs(end) ||
            fxn.changeDate(
                ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
                .isBefore(end)) &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();

    _sOth = _section.last.type == "national"
        ? others
        .where((ele) =>
    (fxn
        .changeDate(
        ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
        .isAtSameMomentAs(begin) ||
        fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAfter(begin)) &&
        (fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAtSameMomentAs(end) ||
            fxn.changeDate(
                ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
                .isBefore(end)))
        .toList()
        : others
        .where((ele) =>
    (fxn
        .changeDate(
        ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
        .isAtSameMomentAs(begin) ||
        fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAfter(begin)) &&
        (fxn.changeDate(
            ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
            .isAtSameMomentAs(end) ||
            fxn.changeDate(
                ele.datetime == null ? DateTime.now() : ele.datetime!.toDate())
                .isBefore(end)) &&
        wr(ele, _section.last.type!) == _section.last.areaID)
        .toList();
    update();
  }

  Map<String, dynamic> get sunday =>
      {
        "offers": {
          "one": sundays.isNotEmpty ? co(sundays, admin, thisYear) : [],
          "two": sundays.isNotEmpty ? co1(sundays, admin, thisYear) : [],
        },
        "attendance": {
          "total": sundays.isNotEmpty ? ta(sundays, admin, thisYear) : [],
          "male": sundays.isNotEmpty ? tma(sundays, admin, thisYear) : [],
          "female":
          sundays.isNotEmpty ? tfa(sundays, admin, thisYear) : [],
          "newcomers":
          sundays.isNotEmpty ? tn(sundays, admin, thisYear) : [],
        },
        "categories": {
          "adults": {
            "total":
            sundays.isNotEmpty ? tas(sundays, admin, thisYear) : [],
            "male":
            sundays.isNotEmpty ? tam(sundays, admin, thisYear) : [],
            "female":
            sundays.isNotEmpty ? taf(sundays, admin, thisYear) : [],
          },
          "youth": {
            "total":
            sundays.isNotEmpty ? ty(sundays, admin, thisYear) : [],
            "male":
            sundays.isNotEmpty ? tym(sundays, admin, thisYear) : [],
            "female":
            sundays.isNotEmpty ? tyf(sundays, admin, thisYear) : [],
          },
          "children": {
            "total":
            sundays.isNotEmpty ? ti(sundays, admin, thisYear) : [],
            "male":
            sundays.isNotEmpty ? tim(sundays, admin, thisYear) : [],
            "female":
            sundays.isNotEmpty ? tif(sundays, admin, thisYear) : [],
          },
        }
      };

  Map<String, dynamic> get revival =>
      {
        "offers": {
          "one": revivals.isNotEmpty ? co(revivals, admin, thisYear) : [],
          "two":
          revivals.isNotEmpty ? co1(revivals, admin, thisYear) : [],
        },
        "attendance": {
          "total":
          revivals.isNotEmpty ? ta(revivals, admin, thisYear) : [],
          "male":
          revivals.isNotEmpty ? tma(revivals, admin, thisYear) : [],
          "female":
          revivals.isNotEmpty ? tfa(revivals, admin, thisYear) : [],
          "newcomers":
          revivals.isNotEmpty ? tn(revivals, admin, thisYear) : [],
        },
        "categories": {
          "adults": {
            "total":
            revivals.isNotEmpty ? tas(revivals, admin, thisYear) : [],
            "male":
            revivals.isNotEmpty ? tam(revivals, admin, thisYear) : [],
            "female":
            revivals.isNotEmpty ? taf(revivals, admin, thisYear) : [],
          },
          "youth": {
            "total":
            revivals.isNotEmpty ? ty(revivals, admin, thisYear) : [],
            "male":
            revivals.isNotEmpty ? tym(revivals, admin, thisYear) : [],
            "female":
            revivals.isNotEmpty ? tyf(revivals, admin, thisYear) : [],
          },
          "children": {
            "total":
            revivals.isNotEmpty ? ti(revivals, admin, thisYear) : [],
            "male":
            revivals.isNotEmpty ? tim(revivals, admin, thisYear) : [],
            "female":
            revivals.isNotEmpty ? tif(revivals, admin, thisYear) : [],
          },
        }
      };

  Map<String, dynamic> get bible =>
      {
        "offers": {
          "one": bibles.isNotEmpty ? co(bibles, admin, thisYear) : [],
          "two": bibles.isNotEmpty ? co1(bibles, admin, thisYear) : [],
        },
        "attendance": {
          "total": bibles.isNotEmpty ? ta(bibles, admin, thisYear) : [],
          "male": bibles.isNotEmpty ? tma(bibles, admin, thisYear) : [],
          "female": bibles.isNotEmpty ? tfa(bibles, admin, thisYear) : [],
          "newcomers":
          bibles.isNotEmpty ? tn(bibles, admin, thisYear) : [],
        },
        "categories": {
          "adults": {
            "total":
            bibles.isNotEmpty ? tas(bibles, admin, thisYear) : [],
            "male": bibles.isNotEmpty ? tam(bibles, admin, thisYear) : [],
            "female":
            bibles.isNotEmpty ? taf(bibles, admin, thisYear) : [],
          },
          "youth": {
            "total": bibles.isNotEmpty ? ty(bibles, admin, thisYear) : [],
            "male": bibles.isNotEmpty ? tym(bibles, admin, thisYear) : [],
            "female":
            bibles.isNotEmpty ? tyf(bibles, admin, thisYear) : [],
          },
          "children": {
            "total": bibles.isNotEmpty ? ti(bibles, admin, thisYear) : [],
            "male": bibles.isNotEmpty ? tim(bibles, admin, thisYear) : [],
            "female":
            bibles.isNotEmpty ? tif(bibles, admin, thisYear) : [],
          },
        }
      };

  Map<String, dynamic> get other =>
      {
        "offers": {
          "one": others.isNotEmpty ? co(others, admin, thisYear) : [],
          "two": others.isNotEmpty ? co1(others, admin, thisYear) : [],
        },
        "attendance": {
          "total": others.isNotEmpty ? ta(others, admin, thisYear) : [],
          "male": others.isNotEmpty ? tma(others, admin, thisYear) : [],
          "female": others.isNotEmpty ? tfa(others, admin, thisYear) : [],
          "newcomers":
          others.isNotEmpty ? tn(others, admin, thisYear) : [],
        },
        "categories": {
          "adults": {
            "total":
            others.isNotEmpty ? tas(others, admin, thisYear) : [],
            "male": others.isNotEmpty ? tam(others, admin, thisYear) : [],
            "female":
            others.isNotEmpty ? taf(others, admin, thisYear) : [],
          },
          "youth": {
            "total": others.isNotEmpty ? ty(others, admin, thisYear) : [],
            "male": others.isNotEmpty ? tym(others, admin, thisYear) : [],
            "female":
            others.isNotEmpty ? tyf(others, admin, thisYear) : [],
          },
          "children": {
            "total": others.isNotEmpty ? ti(others, admin, thisYear) : [],
            "male": others.isNotEmpty ? tim(others, admin, thisYear) : [],
            "female":
            others.isNotEmpty ? tif(others, admin, thisYear) : [],
          },
        }
      };

  Map<String, dynamic> get allService =>
      {
        "offers": {
          "one": co(services, admin, thisYear),
          "two": co1(services, admin, thisYear),
        },
        "attendance": {
          "total":
          ta(services, admin, thisYear),
          "male":
          tma(services, admin, thisYear),
          "female":
          tfa(services, admin, thisYear),
          "newcomers":
          tn(services, admin, thisYear),
        },
        "categories": {
          "adults": {
            "total":
            tas(services, admin, thisYear),
            "male":
            tam(services, admin, thisYear),
            "female":
            taf(services, admin, thisYear),
          },
          "youth": {
            "total":
            ty(services, admin, thisYear),
            "male":
            tym(services, admin, thisYear),
            "female":
            tyf(services, admin, thisYear),
          },
          "children": {
            "total":
            ti(services, admin, thisYear),
            "male":
            tim(services, admin, thisYear),
            "female":
            tif(services, admin, thisYear),
          },
        },
      };

  List<RegionModel> get regions => _regionsList.value!;

  List<Years> get years => _yearsList.value!;

  List<DivisionModel> get divisions => _divisionsList.value!;

  List<GroupModel> get groups => _groupsList.value!;

  List<LocalModel> get locations => _locationsList.value!;

  String get service => _service;

  SelectedSection get section => _section.last;

  Map<String, dynamic> get sSun =>
      {
        "offers": {
          "one": _sSun != null ? co(_sSun!, null, null) : [],
          "two": _sSun != null ? co1(_sSun!, null, null) : [],
        },
        "attendance": {
          "total": _sSun != null ? ta(_sSun!, null, null) : [],
          "male": _sSun != null ? tma(_sSun!, null, null) : [],
          "female": _sSun != null ? tfa(_sSun!, null, null) : [],
          "newcomers": _sSun != null ? tn(_sSun!, null, null) : [],
        },
        "categories": {
          "adults": {
            "total": _sSun != null ? tas(_sSun!, null, null) : [],
            "male": _sSun != null ? tam(_sSun!, null, null) : [],
            "female": _sSun != null ? taf(_sSun!, null, null) : [],
          },
          "youth": {
            "total": _sSun != null ? ty(_sSun!, null, null) : [],
            "male": _sSun != null ? tym(_sSun!, null, null) : [],
            "female": _sSun != null ? tyf(_sSun!, null, null) : [],
          },
          "children": {
            "total": _sSun != null ? ti(_sSun!, null, null) : [],
            "male": _sSun != null ? tim(_sSun!, null, null) : [],
            "female": _sSun != null ? tif(_sSun!, null, null) : [],
          },
        }
      };

  Map<String, dynamic> get sRev =>
      {
        "offers": {
          "one": _sRev != null ? co(_sRev!, null, null) : [],
          "two": _sRev != null ? co1(_sRev!, null, null) : [],
        },
        "attendance": {
          "total": _sRev != null ? ta(_sRev!, null, null) : [],
          "male": _sRev != null ? tma(_sRev!, null, null) : [],
          "female": _sRev != null ? tfa(_sRev!, null, null) : [],
          "newcomers": _sRev != null ? tn(_sRev!, null, null) : [],
        },
        "categories": {
          "adults": {
            "total": _sRev != null ? tas(_sRev!, null, null) : [],
            "male": _sRev != null ? tam(_sRev!, null, null) : [],
            "female": _sRev != null ? taf(_sRev!, null, null) : [],
          },
          "youth": {
            "total": _sRev != null ? ty(_sRev!, null, null) : [],
            "male": _sRev != null ? tym(_sRev!, null, null) : [],
            "female": _sRev != null ? tyf(_sRev!, null, null) : [],
          },
          "children": {
            "total": _sRev != null ? ti(_sRev!, null, null) : [],
            "male": _sRev != null ? tim(_sRev!, null, null) : [],
            "female": _sRev != null ? tif(_sRev!, null, null) : [],
          },
        }
      };

  Map<String, dynamic> get sBib =>
      {
        "offers": {
          "one": _sBib != null ? co(_sBib!, null, null) : [],
          "two": _sBib != null ? co1(_sBib!, null, null) : [],
        },
        "attendance": {
          "total": _sBib != null ? ta(_sBib!, null, null) : [],
          "male": _sBib != null ? tma(_sBib!, null, null) : [],
          "female": _sBib != null ? tfa(_sBib!, null, null) : [],
          "newcomers": _sBib != null ? tn(_sBib!, null, null) : [],
        },
        "categories": {
          "adults": {
            "total": _sBib != null ? tas(_sBib!, null, null) : [],
            "male": _sBib != null ? tam(_sBib!, null, null) : [],
            "female": _sBib != null ? taf(_sBib!, null, null) : [],
          },
          "youth": {
            "total": _sBib != null ? ty(_sBib!, null, null) : [],
            "male": _sBib != null ? tym(_sBib!, null, null) : [],
            "female": _sBib != null ? tyf(_sBib!, null, null) : [],
          },
          "children": {
            "total": _sBib != null ? ti(_sBib!, null, null) : [],
            "male": _sBib != null ? tim(_sBib!, null, null) : [],
            "female": _sBib != null ? tif(_sBib!, null, null) : [],
          },
        }
      };

  Map<String, dynamic> get sOth =>
      {
        "offers": {
          "one": _sOth != null ? co(_sOth!, null, null) : [],
          "two": _sOth != null ? co1(_sOth!, null, null) : [],
        },
        "attendance": {
          "total": _sOth != null ? ta(_sOth!, null, null) : [],
          "male": _sOth != null ? tma(_sOth!, null, null) : [],
          "female": _sOth != null ? tfa(_sOth!, null, null) : [],
          "newcomers": _sOth != null ? tn(_sOth!, null, null) : [],
        },
        "categories": {
          "adults": {
            "total": _sOth != null ? tas(_sOth!, null, null) : [],
            "male": _sOth != null ? tam(_sOth!, null, null) : [],
            "female": _sOth != null ? taf(_sOth!, null, null) : [],
          },
          "youth": {
            "total": _sOth != null ? ty(_sOth!, null, null) : [],
            "male": _sOth != null ? tym(_sOth!, null, null) : [],
            "female": _sOth != null ? tyf(_sOth!, null, null) : [],
          },
          "children": {
            "total": _sOth != null ? ti(_sOth!, null, null) : [],
            "male": _sOth != null ? tim(_sOth!, null, null) : [],
            "female": others.isNotEmpty ? tif(_sOth!, null, null) : [],
          },
        }
      };

  Map<String, dynamic> get sAll =>
      {
        "offers": {
          "one": all(co(_sOth!, null, null), co(_sSun!, null, null),
              co(_sRev!, null, null), co(_sBib!, null, null)),
          "two": all(co1(_sOth!, null, null), co1(_sSun!, null, null),
              co1(_sRev!, null, null), co1(_sBib!, null, null)),
        },
        "attendance": {
          "total": all(ta(_sOth!, null, null), ta(_sSun!, null, null),
              ta(_sRev!, null, null), ta(_sBib!, null, null)),
          "male": all(tma(_sOth!, null, null), tma(_sSun!, null, null),
              tma(_sRev!, null, null), tma(_sBib!, null, null)),
          "female": all(tfa(_sOth!, null, null), tfa(_sSun!, null, null),
              tfa(_sRev!, null, null), tfa(_sBib!, null, null)),
          "newcomers": all(tn(_sOth!, null, null), tn(_sSun!, null, null),
              tn(_sRev!, null, null), tn(_sBib!, null, null)),
        },
        "categories": {
          "adults": {
            "total": all(tas(_sOth!, null, null), tas(_sSun!, null, null),
                tas(_sRev!, null, null), tas(_sBib!, null, null)),
            "male": all(tam(_sOth!, null, null), tam(_sSun!, null, null),
                tam(_sRev!, null, null), tam(_sBib!, null, null)),
            "female": all(taf(_sOth!, null, null), taf(_sSun!, null, null),
                taf(_sRev!, null, null), taf(_sBib!, null, null)),
          },
          "youth": {
            "total": all(ty(_sOth!, null, null), ty(_sSun!, null, null),
                ty(_sRev!, null, null), ty(_sBib!, null, null)),
            "male": all(tym(_sOth!, null, null), tym(_sSun!, null, null),
                tym(_sRev!, null, null), tym(_sBib!, null, null)),
            "female": all(tyf(_sOth!, null, null), tyf(_sSun!, null, null),
                tyf(_sRev!, null, null), tyf(_sBib!, null, null)),
          },
          "children": {
            "total": all(ti(_sOth!, null, null), ti(_sSun!, null, null),
                ti(_sRev!, null, null), ti(_sBib!, null, null)),
            "male": all(tim(_sOth!, null, null), tim(_sSun!, null, null),
                tim(_sRev!, null, null), tim(_sBib!, null, null)),
            "female": all(tif(_sOth!, null, null), tif(_sSun!, null, null),
                tif(_sRev!, null, null), tif(_sBib!, null, null)),
          },
        },
      };

  Map<String, dynamic> get seSun =>
      {
        "offers": {
          "one": _seSun != null ? co(_seSun!, null, null) : [],
          "two": _seSun != null ? co1(_seSun!, null, null) : [],
        },
        "attendance": {
          "total": _seSun != null ? ta(_seSun!, null, null) : [],
          "male": _seSun != null ? tma(_seSun!, null, null) : [],
          "female": _seSun != null ? tfa(_seSun!, null, null) : [],
          "newcomers": _seSun != null ? tn(_seSun!, null, null) : [],
        },
        "categories": {
          "adults": {
            "total": _seSun != null ? tas(_seSun!, null, null) : [],
            "male": _seSun != null ? tam(_seSun!, null, null) : [],
            "female": _seSun != null ? taf(_seSun!, null, null) : [],
          },
          "youth": {
            "total": _seSun != null ? ty(_seSun!, null, null) : [],
            "male": _seSun != null ? tym(_seSun!, null, null) : [],
            "female": _seSun != null ? tyf(_seSun!, null, null) : [],
          },
          "children": {
            "total": _seSun != null ? ti(_seSun!, null, null) : [],
            "male": _seSun != null ? tim(_seSun!, null, null) : [],
            "female": _seSun != null ? tif(_seSun!, null, null) : [],
          },
        }
      };

  Map<String, dynamic> get seRev =>
      {
        "offers": {
          "one": _seRev != null ? co(_seRev!, null, null) : [],
          "two": _seRev != null ? co1(_seRev!, null, null) : [],
        },
        "attendance": {
          "total": _seRev != null ? ta(_seRev!, null, null) : [],
          "male": _seRev != null ? tma(_seRev!, null, null) : [],
          "female": _seRev != null ? tfa(_seRev!, null, null) : [],
          "newcomers": _seRev != null ? tn(_seRev!, null, null) : [],
        },
        "categories": {
          "adults": {
            "total": _seRev != null ? tas(_seRev!, null, null) : [],
            "male": _seRev != null ? tam(_seRev!, null, null) : [],
            "female": _seRev != null ? taf(_seRev!, null, null) : [],
          },
          "youth": {
            "total": _seRev != null ? ty(_seRev!, null, null) : [],
            "male": _seRev != null ? tym(_seRev!, null, null) : [],
            "female": _seRev != null ? tyf(_seRev!, null, null) : [],
          },
          "children": {
            "total": _seRev != null ? ti(_seRev!, null, null) : [],
            "male": _seRev != null ? tim(_seRev!, null, null) : [],
            "female": _seRev != null ? tif(_seRev!, null, null) : [],
          },
        }
      };

  Map<String, dynamic> get seBib =>
      {
        "offers": {
          "one": _seBib != null ? co(_seBib!, null, null) : [],
          "two": _seBib != null ? co1(_seBib!, null, null) : [],
        },
        "attendance": {
          "total": _seBib != null ? ta(_seBib!, null, null) : [],
          "male": _seBib != null ? tma(_seBib!, null, null) : [],
          "female": _seBib != null ? tfa(_seBib!, null, null) : [],
          "newcomers": _seBib != null ? tn(_seBib!, null, null) : [],
        },
        "categories": {
          "adults": {
            "total": _seBib != null ? tas(_seBib!, null, null) : [],
            "male": _seBib != null ? tam(_seBib!, null, null) : [],
            "female": _seBib != null ? taf(_seBib!, null, null) : [],
          },
          "youth": {
            "total": _seBib != null ? ty(_seBib!, null, null) : [],
            "male": _seBib != null ? tym(_seBib!, null, null) : [],
            "female": _seBib != null ? tyf(_seBib!, null, null) : [],
          },
          "children": {
            "total": _seBib != null ? ti(_seBib!, null, null) : [],
            "male": _seBib != null ? tim(_seBib!, null, null) : [],
            "female": _seBib != null ? tif(_seBib!, null, null) : [],
          },
        }
      };

  Map<String, dynamic> get seOth =>
      {
        "offers": {
          "one": _seOth != null ? co(_seOth!, null, null) : [],
          "two": _seOth != null ? co1(_seOth!, null, null) : [],
        },
        "attendance": {
          "total": _seOth != null ? ta(_seOth!, null, null) : [],
          "male": _seOth != null ? tma(_seOth!, null, null) : [],
          "female": _seOth != null ? tfa(_seOth!, null, null) : [],
          "newcomers": _seOth != null ? tn(_seOth!, null, null) : [],
        },
        "categories": {
          "adults": {
            "total": _seOth != null ? tas(_seOth!, null, null) : [],
            "male": _seOth != null ? tam(_seOth!, null, null) : [],
            "female": _seOth != null ? taf(_seOth!, null, null) : [],
          },
          "youth": {
            "total": _seOth != null ? ty(_seOth!, null, null) : [],
            "male": _seOth != null ? tym(_seOth!, null, null) : [],
            "female": _seOth != null ? tyf(_seOth!, null, null) : [],
          },
          "children": {
            "total": _seOth != null ? ti(_seOth!, null, null) : [],
            "male": _seOth != null ? tim(_seOth!, null, null) : [],
            "female": others.isNotEmpty ? tif(_seOth!, null, null) : [],
          },
        }
      };

  Map<String, dynamic> get seAll =>
      {
        "offers": {
          "one": all(co(_seOth!, null, null), co(_seSun!, null, null),
              co(_seRev!, null, null), co(_seBib!, null, null)),
          "two": all(co1(_seOth!, null, null), co1(_seSun!, null, null),
              co1(_seRev!, null, null), co1(_seBib!, null, null)),
        },
        "attendance": {
          "total": all(ta(_seOth!, null, null), ta(_seSun!, null, null),
              ta(_seRev!, null, null), ta(_seBib!, null, null)),
          "male": all(tma(_seOth!, null, null), tma(_seSun!, null, null),
              tma(_seRev!, null, null), tma(_seBib!, null, null)),
          "female": all(tfa(_seOth!, null, null), tfa(_seSun!, null, null),
              tfa(_seRev!, null, null), tfa(_seBib!, null, null)),
          "newcomers": all(tn(_seOth!, null, null), tn(_seSun!, null, null),
              tn(_seRev!, null, null), tn(_seBib!, null, null)),
        },
        "categories": {
          "adults": {
            "total": all(tas(_seOth!, null, null), tas(_seSun!, null, null),
                tas(_seRev!, null, null), tas(_seBib!, null, null)),
            "male": all(tam(_seOth!, null, null), tam(_seSun!, null, null),
                tam(_seRev!, null, null), tam(_seBib!, null, null)),
            "female": all(taf(_seOth!, null, null), taf(_seSun!, null, null),
                taf(_seRev!, null, null), taf(_seBib!, null, null)),
          },
          "youth": {
            "total": all(ty(_seOth!, null, null), ty(_seSun!, null, null),
                ty(_seRev!, null, null), ty(_seBib!, null, null)),
            "male": all(tym(_seOth!, null, null), tym(_seSun!, null, null),
                tym(_seRev!, null, null), tym(_seBib!, null, null)),
            "female": all(tyf(_seOth!, null, null), tyf(_seSun!, null, null),
                tyf(_seRev!, null, null), tyf(_seBib!, null, null)),
          },
          "children": {
            "total": all(ti(_seOth!, null, null), ti(_seSun!, null, null),
                ti(_seRev!, null, null), ti(_seBib!, null, null)),
            "male": all(tim(_seOth!, null, null), tim(_seSun!, null, null),
                tim(_seRev!, null, null), tim(_seBib!, null, null)),
            "female": all(tif(_seOth!, null, null), tif(_seSun!, null, null),
                tif(_seRev!, null, null), tif(_seBib!, null, null)),
          },
        },
      };
}
