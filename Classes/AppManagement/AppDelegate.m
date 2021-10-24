//
//  MemoryAppDelegate.m
//  Memory
//
//  Created by Thibaut on 3/6/10.
//  Copyright Thibaut Jarosz 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@implementation AppDelegate

@synthesize window=_window;
@synthesize mainViewController=_mainViewController;

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
	self.mainViewController = [MainViewController new];
	self.mainViewController.view.frame = [UIScreen mainScreen].bounds;
	
	[self.window addSubview:self.mainViewController.view];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
