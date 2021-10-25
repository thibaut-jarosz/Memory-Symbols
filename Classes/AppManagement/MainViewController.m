//
//  MemoryViewController.m
//  Memory
//
//  Created by Thibaut on 3/6/10.
//  Copyright Thibaut Jarosz 2010. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@implementation MainViewController

@synthesize infoViewController=_infoViewController;
@synthesize cardsContainerViewController=_cardsContainerViewController;
@synthesize difficultyTimer=_difficultyTimer;


@synthesize gameFinishedView=_gameFinishedView;
@synthesize headerView=_headerView;




#pragma mark -
#pragma mark View fisrt launch
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithRed:0.278 green:0.388 blue:0.478 alpha:1];

	[self addHeaderView];
	[self addCardsContainerView];
	[self timerInit];
}

- (void)addHeaderView {
	self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:self.headerView.frame];
	titleLabel.text = @"Memory";
	titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:25];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	[self.headerView addSubview:titleLabel];
    titleLabel = nil;
	
	UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.tintColor = UIColor.whiteColor;
	infoButton.center = CGPointMake(self.headerView.frame.size.width-25, 25);
	[infoButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	[self.headerView addSubview:infoButton];
	
	[self.view addSubview:self.headerView];
}

- (void)addCardsContainerView {
	self.cardsContainerViewController = [[CardsContainerViewController alloc] init];
	self.cardsContainerViewController.delegate = self;
	[self.view addSubview:self.cardsContainerViewController.view];
}


#pragma mark -
#pragma mark Restart management
- (void)restartAction:(id)sender {
	[UIView beginAnimations:@"RestartAction" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5];
	[self.cardsContainerViewController restartGameAfterMovingCardsAway:(self.gameFinishedView ? YES :NO)];
	self.gameFinishedView.alpha = 0;
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark CardsContainerViewController delegate
- (void)gameDidEnd:(CardsContainerViewController *)cardContainer {
	[self.difficultyTimer invalidate];
	self.difficultyTimer = nil;
	
	self.gameFinishedView = [[UIView alloc] initWithFrame:self.cardsContainerViewController.view.frame];
	self.gameFinishedView.alpha = 0;
	[self.view addSubview:self.gameFinishedView];
	
	
	CGRect mainFrame = self.gameFinishedView.frame;
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, mainFrame.size.width, 40)];
	titleLabel.text = [[NSBundle mainBundle] localizedStringForKey:@"GAME_OVER" value:@"Well done!" table:nil];
	titleLabel.textAlignment = NSTextAlignmentCenter;
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:40];
	[self.gameFinishedView addSubview:titleLabel];
    titleLabel = nil;
	
	UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake(75, mainFrame.size.height-40, mainFrame.size.width-150, 40)];
	[resetButton setTitle:[[NSBundle mainBundle] localizedStringForKey:@"RESTART" value:@"Restart" table:nil] forState:UIControlStateNormal];
	[resetButton addTarget:self action:@selector(restartAction:) forControlEvents:UIControlEventTouchUpInside];
	resetButton.backgroundColor = [UIColor clearColor];
	resetButton.titleLabel.textColor = [UIColor whiteColor];
	resetButton.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:28];
	[self.gameFinishedView addSubview:resetButton];
    resetButton = nil;
	
	
	NSInteger currentScore = self.cardsContainerViewController.revealCounter;
	NSInteger bestScore = [self getBestScore];
	
	UILabel *score = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, mainFrame.size.width, 50)];
	score.text = [NSString stringWithFormat:
				  [[NSBundle mainBundle] localizedStringForKey:@"GAME_SCORE" value:@"You have touch the screen %i times to end this game." table:nil],
				  currentScore
				  ];
	score.numberOfLines = 2;
	score.textAlignment = NSTextAlignmentCenter;
	score.backgroundColor = [UIColor clearColor];
	score.textColor = [UIColor whiteColor];
	score.font = [UIFont fontWithName:@"Marker Felt" size:20];
	[self.gameFinishedView addSubview:score];
    score = nil;
	
	score = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, mainFrame.size.width, 50)];
	score.text = [NSString stringWithFormat:
				  [[NSBundle mainBundle] localizedStringForKey:@"BEST_SCORE" value:@"Your best score %@ %i." table:nil],
				  [[NSBundle mainBundle] localizedStringForKey:(bestScore > currentScore ? @"WAS" : @"IS") value:@"is" table:nil],
				  (bestScore ? bestScore : currentScore)
				  ];
	score.numberOfLines = 2;
	score.textAlignment = NSTextAlignmentCenter;
	score.backgroundColor = [UIColor clearColor];
	score.textColor = [UIColor whiteColor];
	score.font = [UIFont fontWithName:@"Marker Felt" size:20];
	[self.gameFinishedView addSubview:score];
    score = nil;
	
	
	if (!bestScore || bestScore >= self.cardsContainerViewController.revealCounter) {
		bestScore = self.cardsContainerViewController.revealCounter;
		[self setBestScore:bestScore];
	}
	
	
	[UIView beginAnimations:@"GameFinished" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5];
	[self.cardsContainerViewController moveCardsAway];
	self.gameFinishedView.alpha = 1;
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Animation delegate
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
	if ([animationID isEqualToString:@"RestartAction"]) {
		if (self.gameFinishedView) {
			[self.gameFinishedView removeFromSuperview];
			self.gameFinishedView = nil;
		}
		[self.cardsContainerViewController shuffleCards];
		[self timerInit];
	}
	else if ([animationID isEqualToString:@"GameFinished"]) {
		[self.cardsContainerViewController hideAllCards];
	}
}


#pragma mark -
#pragma mark Information view management & InfoViewControllerDelegate
- (void)infoButtonAction:(id)sender {
	if (self.infoViewController) {
		[self.infoViewController hide];
	}
	else {
		self.infoViewController = [[InfoViewController alloc] init];
		self.infoViewController.delegate = self;
		[self.view addSubview:self.infoViewController.view];
		[self.view bringSubviewToFront:self.headerView];
		[self.infoViewController show];
	}
}

- (void)didShowInfoViewConroller:(InfoViewController *)infoViewConroller {
}

- (void)didHideInfoViewConroller:(InfoViewController *)infoViewConroller {
	if (infoViewConroller == self.infoViewController) {
		[self.infoViewController.view removeFromSuperview];
		self.infoViewController = nil;
	}
}

- (BOOL)shouldConfirmDifficultyChange {
	return (self.gameFinishedView ? NO : YES);
}


#pragma mark -
#pragma mark Difficulty management
- (NSInteger)difficulty {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults synchronize];
	NSInteger difficulty = [userDefaults integerForKey:@"difficulty"];
	if (difficulty < 0 || difficulty > 2) difficulty = 0;
	return difficulty;
}

- (void)setDifficulty:(NSInteger)difficulty {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults synchronize];
	if (difficulty < 0 || difficulty > 2)
		[userDefaults setInteger:0 forKey:@"difficulty"];
	else
		[userDefaults setInteger:difficulty forKey:@"difficulty"];
	[userDefaults synchronize];
	
	if (!self.gameFinishedView)
		[self restartAction:self];
}


#pragma mark -
#pragma mark Timer management
- (void)timerInit {
	if (self.difficultyTimer) {
		[self.difficultyTimer invalidate];
		self.difficultyTimer = nil;
	}
	
	NSInteger difficulty = self.difficulty;
	
	if (difficulty) {
		self.difficultyTimer = [NSTimer scheduledTimerWithTimeInterval:(difficulty == 2 ? 30 : 60)
																target:self
															  selector:@selector(timerFireMethod:)
															  userInfo:nil
															   repeats:YES];
	}
}

- (void)timerFireMethod:(NSTimer*)theTimer {
	[self.cardsContainerViewController shuffleCards];
}


#pragma mark -
#pragma mark BestScore management
- (NSInteger)getBestScore {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults synchronize];
	return [userDefaults integerForKey:[NSString stringWithFormat:@"bestScore%lu", self.difficulty]];
}

- (void)setBestScore:(NSInteger)bestScore {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults synchronize];
	[userDefaults setInteger:bestScore forKey:[NSString stringWithFormat:@"bestScore%lu", self.difficulty]];
	[userDefaults synchronize];
}

@end
