import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spending_analytics/data/ActionResponse.dart';

import 'BaseBloc.dart';


abstract class BaseState<T extends StatefulWidget,
BLOC_TYPE extends BaseBloC> extends State<T> {
  BLOC_TYPE _bloc;

  BLOC_TYPE get bloc => _bloc;

  @override
  void initState() {
    _bloc = initBloC();
    preInitState();
    super.initState();
  }

  BLOC_TYPE initBloC();

  void preInitState();

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar = buildTopToolbarTitleWidget();
    Widget root;
    root = Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: SafeArea(child: buildStateContent()),
    );
    return root;
  }

  @override
  void dispose() {
    _bloc ?? _bloc.disposeSubjects();
    disposeExtra();
    super.dispose();
  }

  void disposeExtra();

  Widget buildStateContent();

  PreferredSizeWidget buildTopToolbarTitleWidget();
}

class _StreamWidget<DATA_TYPE> {
  Observable<DATA_TYPE> _stream;
  Widget Function(DATA_TYPE) _streamResolver;
  StreamBuilder<DATA_TYPE> _streamBuilder;
  DATA_TYPE _initialData;

  _StreamWidget._(this._stream, this._initialData, this._streamResolver) {
    _streamBuilder = StreamBuilder<DATA_TYPE>(
        stream: _stream,
        initialData: _initialData,
        builder: (context, snapshot) {
          if (_streamResolver != null)
            return _streamResolver(snapshot.data);
          else
            return Container();
        });
  }

  StreamBuilder<DATA_TYPE> get streamBuilder => _streamBuilder;

  factory _StreamWidget._build(Observable<DATA_TYPE> _stream,
      DATA_TYPE _initialData, Widget Function(DATA_TYPE) _streamResolver) =>
      _StreamWidget._(_stream, _initialData, _streamResolver);
}

StreamBuilder<ActionResponse<TYPE>> streamBuilder<TYPE>(
    Observable<ActionResponse<TYPE>> _stream,
    ActionResponse<TYPE> _initialData,
    Widget Function(ActionResponse<TYPE>) _streamResolver) {
  return _StreamWidget<ActionResponse<TYPE>>._build(
      _stream, _initialData, _streamResolver)
      ._streamBuilder;
}

StreamBuilder<TYPE> streamBuilderPrimitive<TYPE>(Observable<TYPE> _stream,
    TYPE _initialData, Widget Function(TYPE) _streamResolver) {
  return _StreamWidget<TYPE>._build(_stream, _initialData, _streamResolver)
      ._streamBuilder;
}