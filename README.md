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
Current values of network traffic changes you can get from property `changes`. This struct will be being recalculated every time you will call it. For zeroing `changes` you have to call `resetChanges`.

App's traffic `counters` is stored at `standardUserDefaults` and will be being increased constantly on each call of `changes` from app's installation till app's removing.


Demo
====

Clone project and run it. You can find examples of usage at `NTTTrackingTrafficViewController.m`.


Compatibility
=============

This class has been tested back to iOS 6.0.


Installation
============

__Cocoapods__: `pod 'BSNetworkTraffic'`<br />
__Manual__: Copy the __BSNetworkTraffic__ folder in your project<br />

Import header in your project:

    #import "BSNetworkTraffic.h"


License
=======

This code is released under the MIT License. See the LICENSE file for
details.

