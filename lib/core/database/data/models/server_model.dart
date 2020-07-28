import 'package:meta/meta.dart';

import '../../domain/entities/server.dart';

class ServerModel extends Server {
  ServerModel({
    int id,
    @required String plexName,
    @required String tautulliId,
    @required String primaryConnectionAddress,
    @required String primaryConnectionProtocol,
    @required String primaryConnectionDomain,
    String primaryConnectionUser,
    String primaryConnectionPassword,
    String secondaryConnectionAddress,
    String secondaryConnectionProtocol,
    String secondaryConnectionDomain,
    String secondaryConnectionUser,
    String secondaryConnectionPassword,
    @required String deviceToken,
  }) : super(
          id: id,
          plexName: plexName,
          tautulliId: tautulliId,
          primaryConnectionAddress: primaryConnectionAddress,
          primaryConnectionProtocol: primaryConnectionProtocol,
          primaryConnectionDomain: primaryConnectionDomain,
          primaryConnectionUser: primaryConnectionUser,
          primaryConnectionPassword: primaryConnectionPassword,
          secondaryConnectionAddress: secondaryConnectionAddress,
          secondaryConnectionProtocol: secondaryConnectionProtocol,
          secondaryConnectionDomain: secondaryConnectionDomain,
          secondaryConnectionUser: secondaryConnectionUser,
          secondaryConnectionPassword: secondaryConnectionPassword,
          deviceToken: deviceToken,
        );
  
  // Create Settings from JSON data
  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      id: json['id'],
      plexName: json['plex_name'],
      tautulliId: json['tautulli_id'],
      primaryConnectionAddress: json['primary_connection_address'],
      primaryConnectionProtocol: json['primary_connection_protocol'],
      primaryConnectionDomain: json['primary_connection_domain'],
      primaryConnectionUser: json['primary_connection_user'],
      primaryConnectionPassword: json['primary_connection_password'],
      secondaryConnectionAddress: json['secondary_connection_address'],
      secondaryConnectionProtocol: json['secondary_connection_protocol'],
      secondaryConnectionDomain: json['secondary_connection_domain'],
      secondaryConnectionUser: json['secondary_connection_user'],
      secondaryConnectionPassword: json['secondary_connection_password'],
      deviceToken: json['device_token'],
    );
  }

  // Convert Settings to JSON to make it easier when we store it in the database
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plex_name': plexName,
      'tautulli_id': tautulliId,
      'primary_connection_address': primaryConnectionAddress,
      'primary_connection_protocol': primaryConnectionProtocol,
      'primary_connection_domain': primaryConnectionDomain,
      'primary_connection_user': primaryConnectionUser,
      'primary_connection_password': primaryConnectionPassword,
      'secondary_connection_address': secondaryConnectionAddress,
      'secondary_connection_protocol': secondaryConnectionProtocol,
      'secondary_connection_domain': secondaryConnectionDomain,
      'secondary_connection_user': secondaryConnectionUser,
      'secondary_connection_password': secondaryConnectionPassword,
      'device_token': deviceToken
    };
  }
}