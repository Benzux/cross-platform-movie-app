// pastebin.com/x5sChMiL
import 'dart:async';
 
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:movie_app/generated/movieapp.pbgrpc.dart';

 
class MovieAppProvider extends ChangeNotifier {
  late final ClientChannel _channel;
  late final MovieAppClient _stub;
  late final StreamController<StateMessage> _send;
  late final ResponseStream<StateMessage> _receive;
  String userName = WordPair.random().join();
 
  MovieAppProvider() {
    _channel = ClientChannel('10.0.2.2', // android emulator's proxy to localhostt on host machine
        port: 50051,
        options: ChannelOptions(credentials: ChannelCredentials.insecure()));
 
    _stub = MovieAppClient(_channel);
    _send = StreamController<StateMessage>();
    _receive = _stub.streamState(_send.stream);
 
    _receive.listen((msg) {
      print("message: ${msg.user}: ${msg.data}");
    });
 
  }

  void setUserName(String name) {
    userName = name;
    notifyListeners();
  }
 
  void send(movieName) {
    var msg = StateMessage()
      ..data = movieName
      ..user = userName;
 
    _send.add(msg);
  }
}