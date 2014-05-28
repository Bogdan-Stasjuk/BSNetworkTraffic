BSNetworkTraffic
================

A singleton for calculating app's network traffic and system network traffic's changes between calls of method `resetChanges`. Thus you can get approximate values of app's sent/recieved data in bytes.

Traffic values are stored in BSNetworkTrafficValues structure:

```objc
struct BSNetworkTrafficValues
{
    NSUInteger WiFiSent;
    NSUInteger WiFiReceived;
    NSUInteger WWANSent;
    NSUInteger WWANReceived;
    NSUInteger errorCnt;
};
```

For initialization you have to call `resetChanges`.
Current values of network traffic changes you can get from property `changes`. This struc will be being recalculated every time you will call it. For zeroing `changes` you have to call `resetChanges`.

At the same time on each call of `changes` app's traffic `counters` will be increased on corresponding values.

App's traffic `counters` is stored at `standardUserDefaults` and will be being increased constantly on each call of `changes` from app's installation till app's removing.
