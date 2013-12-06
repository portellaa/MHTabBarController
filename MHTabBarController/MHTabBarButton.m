//
//  MHTabBarButton.m
//
//  Created by Luís Portela Afonso on 01/11/13.
//  Copyright (c) 2013 Hollance. All rights reserved.
//

#import "MHTabBarButton.h"

@implementation MHTabBarButton

- (id)init
{
	self = [super init];
	
	if (self)
	{
		[self loadDefaults];
	}
	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self)
	{
		[self loadDefaults];
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self)
	{
		[self loadDefaults];
	}
	
	return self;
}

- (id)initWithImage:(UIImage *)image
{
	self = [self init];
	
	if (self)
	{
		[self setImage:image forState:UIControlStateNormal];
	}
	
	return self;
}

- (id)initWithTitle:(NSString *)title
{
	self = [self init];
	
	if (self)
	{
		[self setTitle:title forState:UIControlStateNormal];
	}
	
	return self;
}


#pragma mark class methods override

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];
	
	if ((selected == YES) && (selectedColor != nil))
		[self changeColor:UIControlStateSelected];
		
	
	if ((normalColor != nil) && (selected == NO))
		[self changeColor:UIControlStateNormal];
}

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:NO];
	
	if ((highlightedColor != nil) && (highlighted == YES))
	{
		[self changeColor:UIControlStateHighlighted];
	}
	else [super setHighlighted:highlighted];
}

- (void)setReserved:(BOOL)reserved
{
	[self changeColor:UIControlStateReserved];
}


#pragma mark new methods added to button

- (void)setColor:(UIColor *)color forState:(UIControlState)state
{
	[self setBackgroundColor:color forState:state];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
	switch (state) {
		case UIControlStateNormal:
			NSLog(@"[MHTabBarButton]: Setting normal color. %u", [backgroundColor hash]);
			normalColor = backgroundColor;
			[self setBackgroundColor:backgroundColor];
			break;
		case UIControlStateHighlighted:
			NSLog(@"[MHTabBarButton]: Setting highlighted color. %u", [backgroundColor hash]);
			highlightedColor = backgroundColor;
			break;
		case UIControlStateReserved:
			NSLog(@"[MHTabBarButton]: Setting highlighted color. %u", [backgroundColor hash]);
			reservedColor = backgroundColor;
			break;
		case UIControlStateSelected:
		default:
			NSLog(@"[MHTabBarButton]: Setting selected color. %u", [backgroundColor hash]);
			selectedColor = backgroundColor;
			break;
	}
}

- (void)setState:(UIControlState)state
{
	[self changeColor:state];
}


#pragma mark private methods

- (void)loadDefaults
{
	normalColor = nil;
	selectedColor = nil;
	highlightedColor = nil;
	
	[self setAdjustsImageWhenHighlighted:NO];
}

- (void)changeColor:(UIControlState)state
{
	NSLog(@"[MHTabBarButton]: Cenas: %u - Changing color. State: %u", UIControlStateHighlighted, state);
	switch (state) {
		case UIControlStateNormal:
			[self setBackgroundColor:normalColor];
			break;
		case UIControlStateHighlighted:
			if (highlightedColor != nil)
				[self setBackgroundColor:highlightedColor];
			break;
		case UIControlStateReserved:
			NSLog(@"[MHTabBarButton]:" );
			[self setBackgroundColor:reservedColor];
			break;
		case UIControlStateSelected:
		default:
			[self setBackgroundColor:selectedColor];
			break;
	}
}

@end
