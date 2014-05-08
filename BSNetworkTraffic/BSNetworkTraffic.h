//
//  BSNetworkTraffic.h
//  NetworkTrafficTracking
//
//  Created by Bogdan Stasjuk on 4/6/14.
//  Copyright (c) 2014 Bogdan Stasjuk. All rights reserved.
//

struct BSNetworkTrafficValues
{
    NSUInteger WiFiSent;
    NSUInteger WiFiReceived;
    NSUInteger WWANSent;
    NSUInteger WWANReceived;
    NSUInteger errorCnt;
};


@interface BSNetworkTraffic : NSObject

@property(nonatomic, assign, readonly) struct   BSNetworkTrafficValues  *changes;
@property(nonatomic, assign, readonly) struct   BSNetworkTrafficValues  *counters;
@property(nonatomic, strong, readonly)          NSDate                  *appStartTime;

+ (instancetype)sharedInstance;

- (void)resetCounters;

@end
