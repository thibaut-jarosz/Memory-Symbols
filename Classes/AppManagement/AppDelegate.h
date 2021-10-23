//
//  MemoryAppDelegate.h
//  Memory
//
//  Created by Thibaut on 3/6/10.
//  Copyright Thibaut Jarosz 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *_window;
    MainViewController *_mainViewController;
}

@property(nonatomic,retain) IBOutlet UIWindow *window;
@property(nonatomic,retain) IBOutlet MainViewController *mainViewController;

@end
