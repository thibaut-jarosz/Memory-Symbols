//
//  InfoViewController.h
//  Memory
//
//  Created by Thibaut on 3/13/10.
//  Copyright 2010 Thibaut Jarosz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InfoViewControllerDelegate;

#pragma mark -
@interface InfoViewController : UIViewController <UIActionSheetDelegate> {
	id<InfoViewControllerDelegate> _delegate;
	UISegmentedControl *_difficultyControl;
	BOOL _lockConfirmDifficultyChanged;
}

@property(nonatomic,retain) id<InfoViewControllerDelegate> delegate;
@property(nonatomic,retain) UISegmentedControl *difficultyControl;
@property(nonatomic,assign) BOOL lockConfirmDifficultyChanged;

#pragma mark View initialization & deallocation
- (void)dealloc;
- (void)viewDidLoad;
- (void)addDescritionViews;
- (void)addDifficultyViews;

#pragma mark View displaying
- (void)displayView;
- (void)hideView;

#pragma mark Animation delegate
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context;

#pragma mark Difficulty management
- (void)confirmDifficultyChanged:(id)sender;

#pragma mark ActionSheet delegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end


#pragma mark -
@protocol InfoViewControllerDelegate <NSObject>

@required
- (NSInteger)getDifficulty;
- (void)setDifficulty:(NSInteger)difficulty;

@optional
- (void)infoViewDidShow:(InfoViewController*)infoViewConroller;
- (void)infoViewDidHide:(InfoViewController*)infoViewConroller;
- (BOOL)difficultyChangeConfirmationNeeded;

@end
