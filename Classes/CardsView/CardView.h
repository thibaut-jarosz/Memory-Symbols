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
	UIImage *_image;
	BOOL _visible;
	NSUInteger _imageID;
}

@property(nonatomic,retain) id<CardViewDelegate> delegate;
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,assign,readonly) BOOL visible;
@property(nonatomic,assign) NSUInteger imageID;

#pragma mark View initialization & deallocation
- (id)initWithFrame:(CGRect)aFrame;

#pragma mark visible setter
- (void)setVisible:(BOOL)visible;

#pragma mark View Events
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

@end

#pragma mark -
@protocol CardViewDelegate<NSObject>

@optional
- (void)touchesBeganOnCardView:(CardView*)aCardView;

@end
