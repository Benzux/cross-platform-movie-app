// pastebin.com/x5sChMiL
import 'dart:async';
 
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:movie_app/generated/movieapp.pbgrpc.dart';

 
class MovieAppProvider extends ChangeNotifier {
  late final ClientChannel _channel;
  late final MovieAppClient _stub;
  late final StreamController<StateMessage> _send;
  late final ResponseStream<StateMessage> _receive;
 
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
 
  void send() {
    var msg = StateMessage()
      ..data = "test"
      ..user = "client";
 
    _send.add(msg);
  }
}