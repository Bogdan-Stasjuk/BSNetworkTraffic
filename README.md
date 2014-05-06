BSNetworkTraffic
================

A singleton for calculating system network traffic between calls of method "resetCounters". Thus you can get approximate values of app's sent/recieved data in bytes.

For initialization you have to call "resetCounters".
Current values of network traffic you can get from property "counters" of type struct BSNetworkTrafficValues:
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
This values will be recalculated every time you are refering to "counters".
For zeroing counters and starting from scratch you have to call "resetCounters".
