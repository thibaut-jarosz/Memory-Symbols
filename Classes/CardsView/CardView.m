//
//  CardView.m
//  Memory
//
//  Created by Thibaut on 3/6/10.
//  Copyright 2010 Thibaut Jarosz. All rights reserved.
//

#import "CardView.h"


@implementation CardView

@synthesize delegate=_delegate;
@synthesize frontImage=_frontImage;
@synthesize frontVisible=_frontVisible;
@synthesize imageID=_imageID;
@synthesize cardID=_cardID;


#pragma mark -
#pragma mark View initialization & deallocation
- (id) initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	if (self != nil) {
		self.frontVisible = NO;
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)dealloc {
	self.delegate = nil;
	self.frontImage = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark frontVisible setter
- (void)setFrontVisible:(BOOL)visible {
	[self willChangeValueForKey:@"frontVisible"];
	if (_frontVisible != visible) {
		_frontVisible=visible;
		[UIView beginAnimations:@"CardViewRotation" context:nil];
		[UIView setAnimationDuration:0.5];
		if (visible) {
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
			self.backgroundColor = self.frontImage;
		}
		else {
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
			self.backgroundColor = [UIColor whiteColor];
		}
		[UIView commitAnimations];
	}
	[self didChangeValueForKey:@"frontVisible"];
}


#pragma mark -
#pragma mark View Events
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	if ([self.delegate respondsToSelector:@selector(touchesBeganOnCardView:)])
		[self.delegate touchesBeganOnCardView:self];
	else
		self.frontVisible = (self.frontVisible ? NO : YES);
}


@end
