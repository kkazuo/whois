// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'servers.dart';

/// A number of options to customize the behavior of the
/// static [Whois.lookup] method.
class LookupOptions {
  final int port;
  final Duration timeout;

  const LookupOptions({
    this.port = 43,
    this.timeout = const Duration(milliseconds: 10000),
  });
}

/// An entry point for using this package.
class Whois {
  static const _CRLF = '\r\n';
  static const _LINE_BREAK = '\n';

  ///  Gets the whois server associated with a domain name
  static Map<String, dynamic> _serverDataByName(String name) {
    // Getting index of the last decimal place, where the top tld should be.
    final nameTldPosition = name.lastIndexOf('.');
    if (nameTldPosition < 0) {
      // No dots found, and therefore no tlds
      return {};
    }

    // Subtracting the TLD, and converting to lowercase.
    final nameTld = name.substring(nameTldPosition + 1).toLowerCase();

    // Checking the TLD exists
    if (!whoisServers.containsKey(nameTld)) {
      return {};
    }

    // Returning whois server informaion on the server.
    return whoisServers[nameTld]!;
  }

  /// Handles the whois results returned by a whois server. Parses them. Makes
  /// them feel pretty.
  static Map<String, dynamic> formatLookup(String rawLookup) {
    Map<String, dynamic> parsed = {};

    final lines = rawLookup.split(_LINE_BREAK);

    for (final line in lines) {
      if (line.isEmpty) {
        continue;
      }

      if (line.startsWith('>>>') && line.endsWith('<<<')) {
        break;
      }

      final keyEnd = line.indexOf(':');

      if (keyEnd < 0) {
        continue;
      }

      final key = line.substring(0, keyEnd).trim();

      final value = line.substring(keyEnd + 1).trim();

      if (key.isEmpty || value.isEmpty) {
        continue;
      }

      parsed[key] = value;
    }

    // Want it to be last thing
    parsed['_raw'] = rawLookup;

    return parsed;
  }

  /// Lookups whois information on a particular domain name.
  static Future<String> lookup(
    String domain, [
    LookupOptions options = const LookupOptions(),
  ]) async {
    // Getting whois server information
    final whoisServer = _serverDataByName(domain);
    if (whoisServer.isEmpty) {
      throw ArgumentError('Unsupported TLD');
    }

    final domainQuery = whoisServer['query'] == null
        ? domain
        : whoisServer['query'].replaceAll('{name}', domain);

    final Completer<String> completer = Completer<String>();

    // Create socket
    final socket = await Socket.connect(
      whoisServer['server'],
      options.port,
      timeout: options.timeout,
    );

    // Listen for responses from the server
    socket.listen(
      // Handle data from the server
      (Uint8List data) {
        final serverResponse = String.fromCharCodes(data);
        completer.complete(serverResponse);
      },

      // Handle errors
      onError: (error) {
        socket.destroy();
        throw const SocketException('Failed to lookup');
      },

      // Handle server ending connection
      onDone: () {
        socket.destroy();
      },
    );

    // Send initial query for whois record
    socket.write(domainQuery + _CRLF);

    return completer.future;
  }
}
