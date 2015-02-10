//
//  BSNetworkTraffic.m
//  NetworkTrafficTracking
//
//  Created by Bogdan Stasjuk on 4/6/14.
//  Copyright (c) 2014 Bogdan Stasjuk. All rights reserved.
//

#import "BSNetworkTraffic.h"

#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>


#define APP_TRAFFIC_WIFISENT @"appTrafficWiFiSent"
#define APP_TRAFFIC_WIFIRECEIVED @"appTrafficWiFiReceived"
#define APP_TRAFFIC_WWANSENT @"appTrafficWWANSent"
#define APP_TRAFFIC_WWANRECEIVED @"appTrafficWWANReceived"
#define APP_TRAFFIC_ERRORCNT @"appTrafficErrorCnt"


@interface BSNetworkTraffic () {
  struct BSNetworkTrafficValues appCounters;
  struct BSNetworkTrafficValues appChanges;
}

@property(assign, nonatomic) struct BSNetworkTrafficValues  *changes;
@property(assign, nonatomic) struct BSNetworkTrafficValues  *counters;
@property(assign, nonatomic) struct BSNetworkTrafficValues  networkTrafficPrevValues;

@end


@implementation BSNetworkTraffic

#pragma mark - Properties

#pragma mark -Public

- (struct BSNetworkTrafficValues *)changes {
  [self calcChanges];
  
  return _changes;
}

- (struct BSNetworkTrafficValues *)counters {
  [self fillCountersByUserDefaultsValues];
  
  return _counters;
}


#pragma mark - Public methods

#pragma mark -Static

+ (instancetype)sharedInstance
{
  static id sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self class] new];
  });
  return sharedInstance;
}

#pragma mark -Nonstatic

- (void)resetChanges
{
  memset(&appChanges, 0, sizeof appChanges);
  
  struct BSNetworkTrafficValues trafficCounters = {0};
  [[self class] getTrafficCounters:&trafficCounters];
  self.networkTrafficPrevValues = trafficCounters;
}


#pragma mark - Private methods

#pragma mark -Static

+ (void)getTrafficCounters:(struct BSNetworkTrafficValues *)networkTrafficCounters
{
  BOOL   success;
  struct ifaddrs *addrs;
  const struct ifaddrs *cursor;
  const struct if_data *networkStatisc;
  
  // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
  NSString *interfaceName = nil;
  
  success = getifaddrs(&addrs) == 0;
  if (success)
  {
    cursor = addrs;
    while (cursor != NULL)
    {
      interfaceName = [NSString stringWithFormat:@"%s", cursor->ifa_name];
      //            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name, interfaceName);
      
      if (cursor->ifa_addr->sa_family == AF_LINK) {
        // WiFi
        if ([interfaceName hasPrefix:@"en"]) {
          networkStatisc = (const struct if_data *) cursor->ifa_data;
          networkTrafficCounters->WiFiSent += networkStatisc->ifi_obytes;
          networkTrafficCounters->WiFiReceived += networkStatisc->ifi_ibytes;
          networkTrafficCounters->errorCnt += networkStatisc->ifi_ierrors + networkStatisc->ifi_oerrors;
        }
        
        // WWAN
        if ([interfaceName hasPrefix:@"pdp_ip"]) {
          networkStatisc = (const struct if_data *)cursor->ifa_data;
          networkTrafficCounters->WWANSent += networkStatisc->ifi_obytes;
          networkTrafficCounters->WWANReceived += networkStatisc->ifi_ibytes;
          networkTrafficCounters->errorCnt += networkStatisc->ifi_ierrors + networkStatisc->ifi_oerrors;
        }
      }
      
      cursor = cursor->ifa_next;
    }
    
    freeifaddrs(addrs);
  }
}

#pragma mark -Nonstatic

- (void)calcChanges {
  if (!_changes) {
    _changes = &appChanges;
  }

  struct BSNetworkTrafficValues trafficCounters = {0};
  [[self class] getTrafficCounters:&trafficCounters];
  
  _changes->WiFiReceived  += trafficCounters.WiFiReceived - self.networkTrafficPrevValues.WiFiReceived;
  _changes->WiFiSent      += trafficCounters.WiFiSent - self.networkTrafficPrevValues.WiFiSent;
  _changes->WWANReceived  += trafficCounters.WWANReceived - self.networkTrafficPrevValues.WWANReceived;
  _changes->WWANSent      += trafficCounters.WWANSent - self.networkTrafficPrevValues.WWANSent;
  _changes->errorCnt      += trafficCounters.errorCnt - self.networkTrafficPrevValues.errorCnt;
  
  [self fillCountersByUserDefaultsValues];
  _counters->errorCnt     += trafficCounters.errorCnt - self.networkTrafficPrevValues.errorCnt;
  _counters->WiFiSent     += trafficCounters.WiFiSent - self.networkTrafficPrevValues.WiFiSent;
  _counters->WiFiReceived += trafficCounters.WiFiReceived - self.networkTrafficPrevValues.WiFiReceived;
  _counters->WWANSent     += trafficCounters.WWANSent - self.networkTrafficPrevValues.WWANSent;
  _counters->WWANReceived += trafficCounters.WWANReceived - self.networkTrafficPrevValues.WWANReceived;
  [[NSUserDefaults standardUserDefaults] setInteger:_counters->errorCnt forKey:APP_TRAFFIC_ERRORCNT];
  [[NSUserDefaults standardUserDefaults] setInteger:_counters->WiFiSent forKey:APP_TRAFFIC_WIFISENT];
  [[NSUserDefaults standardUserDefaults] setInteger:_counters->WiFiReceived forKey:APP_TRAFFIC_WIFIRECEIVED];
  [[NSUserDefaults standardUserDefaults] setInteger:_counters->WWANSent forKey:APP_TRAFFIC_WWANSENT];
  [[NSUserDefaults standardUserDefaults] setInteger:_counters->WWANReceived forKey:APP_TRAFFIC_WWANRECEIVED];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  self.networkTrafficPrevValues = trafficCounters;
}

- (void)fillCountersByUserDefaultsValues {
  if (!_counters) {
    _counters = &appCounters;
  }

  _counters->errorCnt = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_ERRORCNT];
  _counters->WiFiSent = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_WIFISENT];
  _counters->WiFiReceived = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_WIFIRECEIVED];
  _counters->WWANSent = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_WWANSENT];
  _counters->WWANReceived = [[NSUserDefaults standardUserDefaults] integerForKey:APP_TRAFFIC_WWANRECEIVED];
}

@end
