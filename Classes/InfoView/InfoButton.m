//
//  InfoButton.m
//  TouchTest
//
//  Created by Thibaut on 3/23/10.
//  Copyright 2010 Thibaut Jarosz. All rights reserved.
//

#import "InfoButton.h"


@implementation InfoButton

+ (InfoButton*)button {
	return [[[InfoButton alloc] init] autorelease];
}

+ (InfoButton*)buttonWithType:(UIButtonType)aButtonType {
	return [[[InfoButton alloc] initWithType:aButtonType] autorelease];
}

- (id)initWithType:(UIButtonType)aButtonType {
	self = [super init];
	if (self != nil) {
		
		UIButton *infoButton = nil;
		if (aButtonType == UIButtonTypeInfoDark || aButtonType == UIButtonTypeInfoLight)
			infoButton = [[UIButton buttonWithType:aButtonType] retain];
		
		if (infoButton) {
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, infoButton.frame.size.width, infoButton.frame.size.height);
			[self setImage:[infoButton imageForState:UIControlStateNormal] forState:UIControlStateNormal];
			self.showsTouchWhenHighlighted = YES;
		}
		[infoButton release], infoButton = nil;
	}
	return self;
}

- (id)init {
	return [self initWithType:UIButtonTypeInfoDark];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
	CGSize minTouchableSize = CGSizeMake(40, 40);
	CGSize currentSize = self.frame.size;
	
	if (currentSize.width < minTouchableSize.width &&
		currentSize.height < minTouchableSize.height &&
		point.x > currentSize.width/2	- minTouchableSize.width/2	&&
		point.x < currentSize.width/2	+ minTouchableSize.width/2	&&
		point.y > currentSize.height/2	- minTouchableSize.height/2	&&
		point.y < currentSize.height/2	+ minTouchableSize.height/2	) {
		return self;
	}
	
	return [super hitTest:point withEvent:event];
}


@end
