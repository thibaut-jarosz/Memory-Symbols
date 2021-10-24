//
//  MemoryViewController.h
//  Memory
//
//  Created by Thibaut on 3/6/10.
//  Copyright Thibaut Jarosz 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#import "CardsContainerViewController.h"
#import "CardView.h"

@interface MainViewController : UIViewController <CardViewDelegate,InfoViewControllerDelegate,CardsContainerViewControllerDelegate> {
	InfoViewController *_infoViewController;
	CardsContainerViewController *_cardsContainerViewController;
	NSTimer *_difficultyTimer;
	
	
	UIView *_gameFinishedView;
	UIView *_headerView;
}

@property(nonatomic,retain) InfoViewController *infoViewController;
@property(nonatomic,retain) CardsContainerViewController *cardsContainerViewController;
@property(nonatomic,retain) NSTimer *difficultyTimer;


@property(nonatomic,retain) UIView *gameFinishedView;
@property(nonatomic,retain) UIView *headerView;


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

