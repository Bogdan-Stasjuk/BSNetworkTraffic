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
    
    NSLog(@"viewDidLoad = %@", [BSNetworkTraffic sharedInstance].appStartTime);
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
        
        [networkTraffic changes];
        
        counter++;
        
        sleep(1);
    }

    NSLog(@"viewDidAppear = %@", [BSNetworkTraffic sharedInstance].appStartTime);

    [self.navigationController pushViewController:[UIViewController new] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
