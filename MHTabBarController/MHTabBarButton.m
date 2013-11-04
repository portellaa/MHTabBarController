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
	
	[self changeColor:selected];
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
			normalColor = backgroundColor;
			[self setBackgroundColor:backgroundColor];
			break;
			
		case UIControlStateSelected:
		default:
			selectedColor = backgroundColor;
			break;
	}
}


#pragma mark private methods

- (void)loadDefaults
{
	normalColor = nil;
	selectedColor = nil;
	
	[self setAdjustsImageWhenHighlighted:NO];
}

- (void)changeColor:(BOOL)selectedState
{
	if (selectedState == YES)
	{
		if (selectedColor != nil)
		{
			[self setBackgroundColor:selectedColor];
			return;
		}
	}
	
	[self setBackgroundColor:normalColor];
}

@end
