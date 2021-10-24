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
@synthesize image=_image;
@synthesize visible=_visible;
@synthesize imageID=_imageID;


#pragma mark -
#pragma mark View initialization & deallocation
- (id) initWithFrame:(CGRect)aFrame {
	self = [super initWithFrame:aFrame];
	if (self != nil) {
		self.visible = NO;
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}


#pragma mark -
#pragma mark visible setter
- (void)setVisible:(BOOL)visible {
	[self willChangeValueForKey:@"visible"];
	if (_visible != visible) {
		_visible=visible;
		[UIView beginAnimations:@"CardViewRotation" context:nil];
		[UIView setAnimationDuration:0.5];
		if (visible) {
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self cache:NO];
			self.backgroundColor = [UIColor colorWithPatternImage:self.image];
		}
		else {
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
			self.backgroundColor = [UIColor whiteColor];
		}
		[UIView commitAnimations];
	}
	[self didChangeValueForKey:@"visible"];
}


#pragma mark -
#pragma mark View Events
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	if ([self.delegate respondsToSelector:@selector(touchesBeganOnCardView:)])
		[self.delegate touchesBeganOnCardView:self];
	else
		self.visible = (self.visible ? NO : YES);
}


@end
