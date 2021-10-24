//
//  CardView.h
//  Memory
//
//  Created by Thibaut on 3/6/10.
//  Copyright 2010 Thibaut Jarosz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardViewDelegate;

#pragma mark -
@interface CardView : UIView {
	id<CardViewDelegate> _delegate;
	UIColor *_frontImage;
	BOOL _frontVisible;
	NSUInteger _imageID;
	NSUInteger _cardID;
}

@property(nonatomic,retain) id<CardViewDelegate> delegate;
@property(nonatomic,retain) UIColor *frontImage;
@property(nonatomic,assign,readonly) BOOL frontVisible;
@property(nonatomic,assign) NSUInteger imageID;
@property(nonatomic,assign) NSUInteger cardID;

#pragma mark View initialization & deallocation
- (id)initWithFrame:(CGRect)aFrame;

#pragma mark frontVisible setter
- (void)setFrontVisible:(BOOL)visible;

#pragma mark View Events
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@end

#pragma mark -
@protocol CardViewDelegate<NSObject>

@optional
- (void)touchesBeganOnCardView:(CardView*)aCardView;

@end
