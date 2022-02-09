import 'package:whois/whois.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    // final awesome = Awesome();

    setUp(() {
      // Additional setup goes here.
    });

    test('Simple Test', () async {
      final whoisResponse = await Whois.lookup('google.com');
      final parsedResponse = Whois.formatLookup(whoisResponse);
      expect(parsedResponse['Domain Name'].toLowerCase(), 'google.com');
    });
  });
}
