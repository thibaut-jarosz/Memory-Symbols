//
//  CardsContainerViewController.m
//  Memory
//
//  Created by Thibaut on 3/14/10.
//  Copyright 2010 Thibaut Jarosz. All rights reserved.
//

#import "CardsContainerViewController.h"


@implementation CardsContainerViewController

@synthesize delegate=_delegate;
@synthesize counter=_counter;
@synthesize returnedCardsList=_returnedCardsList;


#pragma mark -
#pragma mark View initialization & deallocation
- (id)init {
	self = [super init];
	if (self != nil) {
		self.counter = 0;
		self.returnedCardsList = [NSMutableArray arrayWithCapacity:2];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CGRect frame = CGRectMake(3, 75, 314, 349);
	self.view.frame = frame;
	
	CGRect cardFrame = CGRectMake(frame.size.width/2, frame.size.height/2, 0, 0);
	for (NSUInteger i=0; i<45; i++) {
        UIImage *anImage = [UIImage imageNamed:[NSString stringWithFormat:@"%lu.png", i]];
		for (NSUInteger j=0; j<2; j++) {
			CardView *cardView = [[CardView alloc] initWithFrame:cardFrame];
			cardView.image = anImage;
			cardView.delegate = self;
			cardView.imageID = i;
			[self.view addSubview:cardView];
		}
	}
	
	[self reorganizeCards];
}


#pragma mark -
#pragma mark Reorganization
- (void)reorganizeCards {
	NSMutableArray *cardList = [self.view.subviews mutableCopy];
	NSUInteger nbItems = [cardList count];
	
	[UIView beginAnimations:@"CardReorganization" context:nil];
	[UIView	setAnimationDuration:0.5];
	for (NSUInteger i=0; i<nbItems; i++) {
		NSUInteger randomNumber = arc4random()%[cardList count];
		
		CardView *cardView = [cardList objectAtIndex:randomNumber];
		[cardList removeObjectAtIndex:randomNumber];
		cardView.frame = CGRectMake(35*((NSInteger)(i/10)%9), 35*((NSUInteger)i%10), 34, 34);
	}
	[UIView commitAnimations];
}

- (void)hideAllCards {
	for (CardView *aCardView in [self.view subviews]) {
		aCardView.visible = NO;
		aCardView.alpha = 1;
	}
}


#pragma mark -
#pragma mark Restart
- (void)restartGameAfterGameFinished:(BOOL)gameFinished {
	self.counter = 0;
	[self.returnedCardsList removeAllObjects];
	if (gameFinished) {
		CGFloat containerHalfWidth = self.view.frame.size.width/2;
		for (CardView *aCardView in [self.view subviews]) {
			CGPoint cardCenter = aCardView.center;
			aCardView.center = CGPointMake((cardCenter.x < containerHalfWidth ? cardCenter.x+containerHalfWidth+30 : cardCenter.x-containerHalfWidth-30), cardCenter.y);
		}
	}
	else {
		for (CardView *aCardView in [self.view subviews]) {
			aCardView.alpha = 1;
			aCardView.visible = NO;
		}
	}
}


#pragma mark -
#pragma mark Finish
- (void)finishGame {
	CGFloat containerHalfWidth = self.view.frame.size.width/2;
	for (CardView *aCardView in [self.view subviews]) {
		CGPoint cardCenter = aCardView.center;
		aCardView.center = CGPointMake((cardCenter.x < containerHalfWidth ? cardCenter.x-containerHalfWidth-30 : cardCenter.x+containerHalfWidth+30), cardCenter.y);
	}
}


#pragma mark -
#pragma mark Animation delegate
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
	if ([animationID isEqualToString:@"CardViewValidation"]) {
		BOOL gameFinished = YES;
		for (CardView *aCardView in [self.view subviews]) {
			if (!aCardView.visible) {
				gameFinished = NO;
				break;
			}
		}
		if (gameFinished && [self.delegate respondsToSelector:@selector(gameFinishedInCardsContainer:)])
			[self.delegate gameFinishedInCardsContainer:self];
	}
}


#pragma mark -
#pragma mark CardView delegate
- (void)touchesBeganOnCardView:(CardView*)aCardView {
	if (!aCardView.visible) {
		self.counter++;
		if ([self.returnedCardsList count] == 1) {
			CardView *cardView = [self.returnedCardsList objectAtIndex:0];
			aCardView.visible = YES;
			if (aCardView.imageID == cardView.imageID) {
				[UIView beginAnimations:@"CardViewValidation" context:nil];
				[UIView setAnimationDelegate:self];
				[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
				[UIView setAnimationDuration:0.5];
				cardView.alpha = 0.5;
				aCardView.alpha = 0.5;
				[UIView commitAnimations];
				[self.returnedCardsList removeAllObjects];
			}
			else {
				[self.returnedCardsList addObject:aCardView];
			}
		}
		else {
			for (CardView *cardView in self.returnedCardsList)
				cardView.visible = NO;
			aCardView.visible = YES;
			[self.returnedCardsList removeAllObjects];
			[self.returnedCardsList addObject:aCardView];
		}
	}
}


@end
