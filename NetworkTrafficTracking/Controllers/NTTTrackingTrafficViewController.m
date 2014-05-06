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

    BSNetworkTraffic *networkTraffic = [BSNetworkTraffic sharedInstance];

    NSInteger counter = 0;
    while (counter < 10) {
        
        struct BSNetworkTrafficValues *counters = networkTraffic.counters;
        
        counter++;
        
        sleep(1);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
