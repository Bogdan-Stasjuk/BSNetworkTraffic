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


@interface BSNetworkTraffic ()
{
    struct BSNetworkTrafficValues appCounters;
}

@property(nonatomic, assign) struct BSNetworkTrafficValues  networkTrafficPrevValues;

@end


@implementation BSNetworkTraffic

#pragma mark - Properties

#pragma mark -Public

- (struct BSNetworkTrafficValues *)counters
{
    if (!_counters) {
        
        _counters = &appCounters;
    }
    return _counters;
}


#pragma mark - Public methods

#pragma mark -Static

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

#pragma mark -Nonstatic

- (void)refreshCounters
{
    struct BSNetworkTrafficValues trafficCounters = {0};
    [[self class] getTrafficCounters:&trafficCounters];
    
    if (self.isFirstTimeAfterLaunch)
    {
        self.networkTrafficPrevValues = trafficCounters;
        
        self.isFirstTimeAfterLaunch = NO;
    }
    else
    {
        [self calcAppTrafficChangesForTrafficCounters:&trafficCounters];
    }
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
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([interfaceName hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    networkTrafficCounters->WiFiSent += networkStatisc->ifi_obytes;
                    networkTrafficCounters->WiFiReceived += networkStatisc->ifi_ibytes;
//                    NSLog(@"WiFiSent %lu == %d", (unsigned long)WiFiSent, networkStatisc->ifi_obytes);
//                    NSLog(@"WiFiReceived %lu == %d", (unsigned long)WiFiReceived, networkStatisc->ifi_ibytes);
                }
                
                if ([interfaceName hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *)cursor->ifa_data;
                    networkTrafficCounters->WWANSent += networkStatisc->ifi_obytes;
                    networkTrafficCounters->WWANReceived += networkStatisc->ifi_ibytes;
//                    NSLog(@"WWANSent %lu == %d", (unsigned long)WWANSent, networkStatisc->ifi_obytes);
//                    NSLog(@"WWANReceived %lu == %d", (unsigned long)WWANReceived, networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    NSLog(@"System traffic counters: WiFiSent = %lu, WiFiReceived = %lu, WWANSent = %lu, WWANReceived = %lu",
          networkTrafficCounters->WiFiSent, networkTrafficCounters->WiFiReceived, networkTrafficCounters->WWANSent, networkTrafficCounters->WWANReceived);
}

#pragma mark -Nonstatic

- (void)calcAppTrafficChangesForTrafficCounters:(struct BSNetworkTrafficValues *)trafficCounters
{
    self.counters->WiFiReceived += trafficCounters->WiFiReceived - self.networkTrafficPrevValues.WiFiReceived;
    self.counters->WiFiSent += trafficCounters->WiFiSent - self.networkTrafficPrevValues.WiFiSent;
    self.counters->WWANReceived += trafficCounters->WWANReceived - self.networkTrafficPrevValues.WWANReceived;
    self.counters->WWANSent += trafficCounters->WWANSent - self.networkTrafficPrevValues.WWANSent;
    
    NSLog(@"Counters: WiFiSent = %lu, WiFiReceived = %lu, WWANSent = %lu, WWANReceived = %lu", self.counters->WiFiSent, self.counters->WiFiReceived, self.counters->WWANSent, (unsigned long)self.counters->WWANReceived);
    
    self.networkTrafficPrevValues = *trafficCounters;
}

@end
