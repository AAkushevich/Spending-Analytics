import 'package:flutter/material.dart';
import 'package:spending_analytics/data/repository/ApiReposytory.dart';
import 'package:spending_analytics/data/repository/IApiRepository.dart';
import 'package:spending_analytics/data/repository/ISharedPrefRepository.dart';
import 'package:spending_analytics/data/repository/SharPrefRepositiry.dart';
import 'package:spending_analytics/ui/BaseSate/BaseState.dart';
import 'package:spending_analytics/ui/MainPage/AccountsPage/AccountsScreen.dart';
import 'package:spending_analytics/ui/MainPage/AnalyticsPage/AnalyticsScreen.dart';
import 'package:spending_analytics/ui/MainPage/MainPageBloc.dart';
import 'package:spending_analytics/ui/MainPage/OperationsPage/OperationsScreen.dart';
import 'package:spending_analytics/ui/MainPage/SettingsPage/SettingsScreen.dart';
import 'package:spending_analytics/ui/Widgets/Preloader.dart';

class MainPage extends StatefulWidget {

  MainPage(this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;

  @override
  State<StatefulWidget> createState() {
    return MainPageState(_sharedPrefRepository);
  }

}

class MainPageState extends BaseState<MainPage, MainPageBloc> {

  MainPageState(this._sharedPrefRepository);

  final ISharedPrefRepository _sharedPrefRepository;

  List<dynamic> components = List();

  int currentComponentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      currentComponentIndex = index;
    });
  }


  @override
  Widget buildStateContent() {
    return StreamBuilder(
      stream: bloc.mainPageStateStream,
      initialData: MAIN_PAGE_STATE.LOADING,
      builder: (context, snapshot) {
        if(snapshot.data != null) {
          switch(snapshot.data) {
            case MAIN_PAGE_STATE.SUCCESS:
              return components[currentComponentIndex];
              break;
            case MAIN_PAGE_STATE.LOADING:
              return Container(
                  color: Colors.white,
                  child: SpinKitPouringHourglass(color: Colors.black)
              );
              break;
            case MAIN_PAGE_STATE.ERROR:
              return Container(
                child: Center(
                  child: Text(
                    "Что-то случилось",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              );
              break;
            default:
              return Container();
              break;
          }
        } else {
          return Container();
        }
      },

    );
  }

  @override
  PreferredSizeWidget buildTopToolbarTitleWidget() {
    // TODO: implement buildTopToolbarTitleWidget
    return null;
  }

  @override
  void disposeExtra() {
    // TODO: implement disposeExtra
  }

  @override
  initBloC() {
    return MainPageBloc(ApiRepository(), SharedPrefRepository());
  }

  void checkIfDataLoaded() {

  }

  Future<void> saveBaseCurrency(String baseCurrency) async{
    await _sharedPrefRepository.setBaseCurrency(baseCurrency);
  }

  @override
  void preInitState() async {
    String baseCurrency = await _sharedPrefRepository.getBaseCurrency();
    if(baseCurrency == null) {
     await showDialog(
        context: context,
        builder: (_) => FunkyOverlay(saveBaseCurrency),
      );
    }
    components.add(AccountsScreen());
    components.add(OperationsScreen());
    components.add(AnalyticsScreen());
    components.add(SettingsScreen());
    bloc.fetchAllData();
  }

  @override
  BottomNavigationBar bottomBarWidget() {
    return BottomNavigationBar(
      currentIndex: currentComponentIndex,
      type: BottomNavigationBarType.shifting,
      showUnselectedLabels: true,
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance, color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Accounts', style: TextStyle(color: Colors.black))
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.credit_card, color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Transactions', style: TextStyle(color: Colors.black))
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.poll, color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Statistics', style: TextStyle(color: Colors.black))
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Color.fromARGB(255, 0, 0, 0)),
            title: new Text('Settings', style: TextStyle(color: Colors.black))
        )
      ],
      onTap: (index) {
        _onItemTapped(index);
      },
    );
  }

}

class FunkyOverlay extends StatefulWidget {

  final Function(String baseCurrency) saveBaseCurrency;

  FunkyOverlay(this.saveBaseCurrency);

  @override
  State<StatefulWidget> createState() => FunkyOverlayState(saveBaseCurrency);
}

class FunkyOverlayState extends State<FunkyOverlay>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> scaleAnimation;

  final Function(String baseCurrency) saveBaseCurrency;

  FunkyOverlayState(this.saveBaseCurrency);


  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0))),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Text("Необходимо выбрать основноую валюту", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        color: Colors.black,
                        height: 0.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: FlatButton(
                        child: Text("Российский рубль"),
                        onPressed: () {
                          saveBaseCurrency("RUB");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    FlatButton(
                      child: Text("Белорусский рубль"),
                      onPressed: () {
                        saveBaseCurrency("BYN");
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("Доллар США"),
                      onPressed: () {
                        saveBaseCurrency("USD");
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: FlatButton(
                        child: Text("Евро"),
                        onPressed: () {
                          saveBaseCurrency("EUR");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}