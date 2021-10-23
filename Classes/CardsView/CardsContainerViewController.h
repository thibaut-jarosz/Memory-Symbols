//
//  CardsContainerViewController.h
//  Memory
//
//  Created by Thibaut on 3/14/10.
//  Copyright 2010 Thibaut Jarosz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@protocol CardsContainerViewControllerDelegate;

#pragma mark -
@interface CardsContainerViewController : UIViewController <CardViewDelegate> {
	id<CardsContainerViewControllerDelegate> _delegate;
	NSInteger _counter;
	NSMutableArray *_returnedCardsList;
}

@property(nonatomic,retain) id<CardsContainerViewControllerDelegate> delegate;
@property(nonatomic,assign) NSInteger counter;
@property(nonatomic,retain) NSMutableArray *returnedCardsList;

#pragma mark View initialization & deallocation
- (id)init;
- (void)dealloc;
- (void)viewDidLoad;

#pragma mark Reorganization
- (void)reorganizeCards;
- (void)hideAllCards;

#pragma mark Restart
- (void)restartGameAfterGameFinished:(BOOL)gameFinished;

#pragma mark Finish
- (void)finishGame;

#pragma mark Animation delegate
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context;

#pragma mark CardView delegate
- (void)touchesBeganOnCardView:(CardView*)aCardView;

@end

#pragma mark -
@protocol CardsContainerViewControllerDelegate <NSObject>

@optional
- (void)gameFinishedInCardsContainer:(CardsContainerViewController*)aCardsContainer;

@end
