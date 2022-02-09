import 'package:whois/whois.dart';

main() async {
  // The domain we want to query, and options for the whois server
  const domain = 'google.com';

  // Additional options to the query
  var options = const LookupOptions(
    // Set timeout to 10 seconds
    timeout: Duration(milliseconds: 10000),

    // Set the whois port, default is 43
    port: 43,
  );

  try {
    final whoisResponse = await Whois.lookup(domain, options);

    // print(whoisResponse);

    // A parsed key/value of the whois results
    final parsedResponse = Whois.formatLookup(whoisResponse);

    print(
        'The domain ${parsedResponse['Domain Name'].toLowerCase()} is registered with ${parsedResponse['Registrar']}');
    print('Domain is due to expire, ${parsedResponse['Registry Expiry Date']}');
    print(
        'For abuse please contact, ${parsedResponse['Registrar Abuse Contact Email']}');
  } catch (e) {
    print('Error: $e');
  }
}
