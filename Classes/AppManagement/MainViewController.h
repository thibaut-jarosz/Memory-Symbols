//
//  MemoryViewController.h
//  Memory
//
//  Created by Thibaut on 3/6/10.
//  Copyright Thibaut Jarosz 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#import "Memory-Swift.h"

@interface MainViewController : UIViewController <InfoViewControllerDelegate,CardsContainerViewControllerDelegate> {
	InfoViewController *_infoViewController;
	CardsContainerViewController *_cardsContainerViewController;
	NSTimer *_difficultyTimer;
	
	
	UIView *_gameFinishedView;
	UIView *_headerView;
}

@property(nonatomic,strong) InfoViewController *infoViewController;
@property(nonatomic,strong) CardsContainerViewController *cardsContainerViewController;
@property(nonatomic,strong) NSTimer *difficultyTimer;


@property(nonatomic,strong) UIView *gameFinishedView;
@property(nonatomic,strong) UIView *headerView;


- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context;
- (void)infoButtonAction:(id)sender;
- (void)restartAction:(id)sender;
- (void)addHeaderView;
- (void)addCardsContainerView;
- (NSInteger)getDifficulty;
- (void)setDifficulty:(NSInteger)difficulty;
- (void)confirmDifficultyChanged:(id)sender;
- (void)timerInit;
- (void)timerFireMethod:(NSTimer*)theTimer;
- (NSInteger)getBestScore;
- (void)setBestScore:(NSInteger)bestScore;

@end

