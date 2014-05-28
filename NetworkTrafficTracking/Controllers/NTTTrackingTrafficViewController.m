//
//  NTTTrackingTrafficViewController.m
//  NetworkTrafficTracking
//
//  Created by Bogdan Stasjuk on 4/6/14.
//  Copyright (c) 2014 Bogdan Stasjuk. All rights reserved.
//

#import "NTTTrackingTrafficViewController.h"

#import "BSNetworkTraffic.h"


@interface NTTTrackingTrafficViewController ()

@end


@implementation NTTTrackingTrafficViewController

#pragma mark - Private methods

#pragma mark -UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[BSNetworkTraffic sharedInstance] resetChanges];
    
    NSLog(@"reseted");
}

- (void)viewDidAppear:(BOOL)animated
{
    BSNetworkTraffic *networkTraffic = [BSNetworkTraffic sharedInstance];
    
    NSInteger counter = 0;
    while (counter < 3) {
        
        struct BSNetworkTrafficValues trafficChanges = *[networkTraffic changes];
        NSLog(@"\nChanges: WiFiSent = %lu, WiFiReceived = %lu, WWANSent = %lu, WWANReceived = %lu, errorCnt = %lu \nCounters: WiFiSent = %lu, WiFiReceived = %lu, WWANSent = %lu, WWANReceived = %lu, errorCnt = %lu",
                (unsigned long)trafficChanges.WiFiSent,
                (unsigned long)trafficChanges.WiFiReceived,
                (unsigned long)trafficChanges.WWANSent,
                (unsigned long)trafficChanges.WWANReceived,
                (unsigned long)trafficChanges.errorCnt,
                (unsigned long)networkTraffic.counters->WiFiSent,
                (unsigned long)networkTraffic.counters->WiFiReceived,
                (unsigned long)networkTraffic.counters->WWANSent,
                (unsigned long)networkTraffic.counters->WWANReceived,
                (unsigned long)networkTraffic.counters->errorCnt);
        
        counter++;
        
        sleep(1);
    }

    [self.navigationController pushViewController:[UIViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
