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
};


@interface BSNetworkTraffic : NSObject

@property(nonatomic, assign)        BOOL                    isFirstTimeAfterLaunch;
@property(nonatomic, assign) struct BSNetworkTrafficValues  *counters;

+ (instancetype)sharedInstance;

- (void)refreshCounters;

@end
