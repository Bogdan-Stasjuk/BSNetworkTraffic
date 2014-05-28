BSNetworkTraffic
================

A singleton for calculating app's network traffic and system network traffic changes between calls of method "resetChanges". Thus you can get approximate values of app's sent/recieved data in bytes.

Traffic values store in BSNetworkTrafficValues structure:
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

For initialization you have to call "resetChanges".
Current values of network traffic changes you can get from property "changes". This values will be recalculated every time you are referring to "changes". 
At the same time on each call of "changes" app's traffic "counters" will increase on prorated values.
For zeroing changes you have to call "resetChanges".
