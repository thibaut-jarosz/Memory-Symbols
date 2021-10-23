//
//  InfoButton.h
//  TouchTest
//
//  Created by Thibaut on 3/23/10.
//  Copyright 2010 Thibaut Jarosz. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoButton : UIButton {
	UIButtonType _buttonType;
}

+ (InfoButton*)button;
+ (InfoButton*)buttonWithType:(UIButtonType)aButtonType;
- (id)initWithType:(UIButtonType)aButtonType;

@end
