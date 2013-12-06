//
//  MHTabBarButton.h
//
//  Created by Luís Portela Afonso on 01/11/13.
//  Copyright (c) 2013 Hollance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHTabBarButton : UIButton
{
	UIColor *normalColor;
	UIColor *selectedColor;
	UIColor *highlightedColor;
	UIColor *reservedColor;
}

- (id)initWithImage:(UIImage*)image;
- (id)initWithTitle:(NSString*)title;

- (void)setColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (void)setReserved:(BOOL)reserved;
- (void)setState:(UIControlState)state;

@end
