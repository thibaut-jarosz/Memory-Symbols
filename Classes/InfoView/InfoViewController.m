//
//  InfoViewController.m
//  Memory
//
//  Created by Thibaut on 3/13/10.
//  Copyright 2010 Thibaut Jarosz. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController


@synthesize delegate=_delegate;
@synthesize difficultyControl=_difficultyControl;
@synthesize lockConfirmDifficultyChanged=_lockConfirmDifficultyChanged;


#pragma mark -
#pragma mark View initialization & deallocation
- (void)viewDidLoad {
	[super viewDidLoad];
	self.lockConfirmDifficultyChanged = NO;
	CGRect frame = [[UIScreen mainScreen] bounds];
	frame.origin = CGPointMake(0, frame.size.height);
	self.view.frame = frame;
	self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
	
	[self addDescritionViews];
	[self addDifficultyViews];
}

- (void)addDescritionViews {
	UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 90, self.view.frame.size.width-40, 160)];
	textView.backgroundColor = [UIColor clearColor];
	textView.textColor = [UIColor whiteColor];
	textView.textAlignment = NSTextAlignmentCenter;
	textView.editable = NO;
	textView.scrollEnabled = NO;
	textView.dataDetectorTypes = UIDataDetectorTypeLink;
	textView.font = [UIFont fontWithName:@"Marker Felt" size:20];
	textView.text = [NSString stringWithFormat:@"%@\n%@\n\n%@\n%@\n%@",
					  [[NSBundle mainBundle] localizedStringForKey:@"INFO_DEV" value:@"Development: Thibaut Jarosz" table:nil],
					  @"www.thibaut-jarosz.com",
					  [[NSBundle mainBundle] localizedStringForKey:@"INFO_ADAPT" value:@"Adapted from a Kek's flash game" table:nil],
					  @"www.zanorg.com",
					  @"blog.zanorg.com"
					  ];
	[self.view addSubview:textView];
	
	UIView *separationView = [[UIView alloc] initWithFrame:CGRectMake(20, 290, self.view.frame.size.width-40, 1)];
	separationView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:separationView];
}

- (void)addDifficultyViews {
	CGRect frame = self.view.frame;
	
	UILabel *difficultyTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, frame.size.height-160, frame.size.width-30, 30)];
	difficultyTitle.backgroundColor = [UIColor clearColor];
	difficultyTitle.textColor = [UIColor whiteColor];
	difficultyTitle.textAlignment = NSTextAlignmentCenter;
	difficultyTitle.numberOfLines = 2;
	difficultyTitle.font = [UIFont fontWithName:@"Marker Felt" size:25];
	difficultyTitle.text = [[NSBundle mainBundle] localizedStringForKey:@"DIFFICULTY" value:@"Difficulty" table:nil];
	[self.view addSubview:difficultyTitle];
	
	self.difficultyControl = [[UISegmentedControl alloc] initWithItems:
                              [NSArray arrayWithObjects:
                               [[NSBundle mainBundle] localizedStringForKey:@"NORMAL" value:@"Normal" table:nil],
                               [[NSBundle mainBundle] localizedStringForKey:@"HARD" value:@"Hard" table:nil],
                               [[NSBundle mainBundle] localizedStringForKey:@"EXTREME" value:@"Extreme" table:nil],
                               nil]];
	self.difficultyControl.selectedSegmentIndex = [self.delegate getDifficulty];
	self.difficultyControl.center = CGPointMake(frame.size.width/2, frame.size.height-100);
	[self.difficultyControl addTarget:self action:@selector(confirmDifficultyChanged:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:self.difficultyControl];	
	
	UILabel *difficultyDescription = [[UILabel alloc] initWithFrame:CGRectMake(15, frame.size.height-70, frame.size.width-30, 60)];
	difficultyDescription.backgroundColor = [UIColor clearColor];
	difficultyDescription.font = [UIFont fontWithName:@"Marker Felt" size:difficultyDescription.font.pointSize];
	difficultyDescription.textColor = [UIColor whiteColor];
	difficultyDescription.textAlignment = NSTextAlignmentCenter;
	difficultyDescription.numberOfLines = 3;
	difficultyDescription.text = [[NSBundle mainBundle] localizedStringForKey:@"DIFFICULTY_DESCRIPTION" value:@"Hard and Extreme difficulties will respectivelly reorganize the table every 60 and 30 seconds." table:nil];
	[self.view addSubview:difficultyDescription];
}


#pragma mark -
#pragma mark View displaying
- (void)displayView {
	CGRect frame = self.view.frame;
	frame.origin = CGPointZero;
	[UIView beginAnimations:@"DisplayView" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5];
	self.view.frame = frame;
	[UIView commitAnimations];
}

- (void)hideView {
	CGRect frame = self.view.frame;
	frame.origin = CGPointMake(0, frame.size.height);
	[UIView beginAnimations:@"HideView" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.5];
	self.view.frame = frame;
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark Animation delegate
- (void)animationDidStop:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context {
	if ([animationID isEqualToString:@"DisplayView"] && [self.delegate respondsToSelector:@selector(infoViewDidShow:)]) {
		[self.delegate infoViewDidShow:self];
	}
	else if ([animationID isEqualToString:@"HideView"] && [self.delegate respondsToSelector:@selector(infoViewDidHide:)]) {
		[self.delegate infoViewDidHide:self];
	}
}


#pragma mark -
#pragma mark Difficulty management
- (void)confirmDifficultyChanged:(id)sender {
	if (!self.lockConfirmDifficultyChanged) {
		if ([self.delegate respondsToSelector:@selector(difficultyChangeConfirmationNeeded)] && [self.delegate difficultyChangeConfirmationNeeded]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"CONFIRM_DIFFICULTY_CHANGE" value:@"Changing difficulty needs to restart the game." table:nil] message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"CANCEL_BUTTON" value:@"Cancel" table:nil] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // hide the alert controller?
                [self.delegate setDifficulty:self.difficultyControl.selectedSegmentIndex];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:[[NSBundle mainBundle] localizedStringForKey:@"CHANGE_BUTTON" value:@"Change" table:nil] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                // hide the alert controller?
                self.lockConfirmDifficultyChanged = YES;
                self.difficultyControl.selectedSegmentIndex = [self.delegate getDifficulty];
                self.lockConfirmDifficultyChanged = NO;
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
		}
		else {
			[self.delegate setDifficulty:((UISegmentedControl*)sender).selectedSegmentIndex];
		}
	}
}

@end
