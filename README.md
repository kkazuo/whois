Lightweight and performant WHOIS client supporting hundreds of TLDs.

An easy way to perform whois queries from mobile applications, desktop and CLI.

## Usage

You can get a raw result of a whois query as follows:

```dart
    final whoisResponse = await Whois.lookup('xeost.com');

    print(whoisResponse);
```

You can also convert this result to a Map with individual values:

```dart
    // A parsed key/value of the whois results
    final parsedResponse = Whois.formatLookup(whoisResponse);

    print(parsedResponse);
```
