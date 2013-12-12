/*
 * Copyright (c) 2011-2012 Matthijs Hollemans
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#define BAR_HEIGHT 50.0f

#import "MHTabBarController.h"

static const NSInteger TagOffset = 1000;

@interface MHTabBarController ()

@property CGRect indicatorOriginalFrame;

@property (nonatomic, retain) UISwipeGestureRecognizer *swipeLeft, *swipeRight;

@end

@implementation MHTabBarController
{
	UIView *tabButtonsContainerView;
	UIView *contentContainerView;
	UIView *topBarView;
	
	BOOL customButtonWidth, customIndicator, customTopBarColor;
}

- (id)init
{
	self = [super init];
	
	if (self)
	{
		_barHeight = BAR_HEIGHT;
		_buttonWidth = 0.0f;
		_barColor = [UIColor blackColor];
		
		_top = CGPointMake(0.0f, 0.0f);
		
		customButtonWidth = NO;
		customIndicator = NO;
		customTopBarColor = NO;

		_indicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MHTabBarIndicator"]];
	}
	
	return self;
}

- (void)awakeFromNib
{
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
	{
		[self setExtendedLayoutIncludesOpaqueBars:YES];
		[self setEdgesForExtendedLayout:UIRectEdgeAll];
	}
	
	[super awakeFromNib];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	CGRect frame = CGRectZero;
	frame.size.width = self.view.bounds.size.width;
	if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
	{
		[self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
		[self.navigationController.navigationBar setShadowImage:[UIImage new]];
		[self.navigationController.navigationBar setTranslucent:YES];
		[self.navigationController.navigationBar setTitleTextAttributes:@{
																		  NSForegroundColorAttributeName : [UIColor whiteColor]
																		  }];
		
		frame.size.height += [[UIApplication sharedApplication] statusBarFrame].size.height;
		frame.size.height += self.navigationController.navigationBar.frame.size.height;
		topBarView = [[UIView alloc] initWithFrame:frame];
		
		if (customTopBarColor == NO)
			_topBarColor = _barColor;
		[topBarView setBackgroundColor:_topBarColor];
		
		[self.view addSubview:topBarView];
	}

	[self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
	
	frame.origin.y += topBarView.frame.size.height;
	frame.size.height = _barHeight;
	
	tabButtonsContainerView = [[UIView alloc] initWithFrame:frame];
	[tabButtonsContainerView setBackgroundColor:_barColor];
	[tabButtonsContainerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[tabButtonsContainerView setOpaque:NO];
	[self.view addSubview:tabButtonsContainerView];
	
	NSLog(@"[MHTabBarController]: Rect before tabButtonsContainerView: %@", NSStringFromCGRect(contentContainerView.frame));

	frame.origin.y += _barHeight;
	frame.size.height = self.view.bounds.size.height - frame.origin.y;
	contentContainerView = [[UIView alloc] initWithFrame:frame];
	
	[contentContainerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

	if (_swipeLeft != nil)
		[contentContainerView addGestureRecognizer:_swipeLeft];
	if (_swipeRight != nil)
		[contentContainerView addGestureRecognizer:_swipeRight];
	
	[self.view addSubview:contentContainerView];
	NSLog(@"[MHTabBarController]: Size of contentContainer: %@", NSStringFromCGRect(contentContainerView.frame));
	
	CGRect frameIndicator = _indicator.frame;
	frameIndicator.origin.y += tabButtonsContainerView.frame.origin.y;
	[_indicator setFrame:frameIndicator];
	_indicatorOriginalFrame = frameIndicator;
	
	[self.view addSubview:_indicator];

	[self reloadTabButtons];
}

- (void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];
	[self layoutTabButtons];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Only rotate if all child view controllers agree on the new orientation.
	for (UIViewController *viewController in self.viewControllers)
	{
		if (![viewController shouldAutorotateToInterfaceOrientation:interfaceOrientation])
			return NO;
	}
	return YES;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];

	if ([self isViewLoaded] && self.view.window == nil)
	{
		self.view = nil;
		tabButtonsContainerView = nil;
		contentContainerView = nil;
	}
}


#pragma mark - Override Methods

- (void)setSwipe:(UISwipeGestureRecognizerDirection)recognizerDirection
{
	NSLog(@"[MHTabBarController]: Set Swipe to direction: value: %d - Left: %d - Right: %d", (recognizerDirection), UISwipeGestureRecognizerDirectionLeft, UISwipeGestureRecognizerDirectionRight);
	
	if ((recognizerDirection == UISwipeGestureRecognizerDirectionLeft) || (recognizerDirection == (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)))
	{
		NSLog(@"[MHTabBarController]: Swipe Left configured");
		_swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
		[_swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
	}
	
	if ((recognizerDirection == UISwipeGestureRecognizerDirectionRight) || (recognizerDirection == (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)))
	{
		NSLog(@"[MHTabBarController]: Swipe Right configured");
		_swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
		[_swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
	}
}

- (void)setButtonWidth:(CGFloat)buttonWidth
{
	customButtonWidth = YES;
	_buttonWidth = buttonWidth;
	
	if (customIndicator == YES)
	{
		CGRect frame = [_indicator frame];
		frame.size.width = buttonWidth;
		[_indicator setFrame:frame];
	}
}

- (void)setTopBarColor:(UIColor *)topBarColor
{
	customTopBarColor = YES;
	_topBarColor = topBarColor;
	
	if ((self.isViewLoaded == YES) && (topBarView != nil))
		[topBarView setBackgroundColor:_topBarColor];
}

- (void)changeButtonStateIndex:(NSUInteger)index toState:(UIControlState)state
{
	NSAssert(index < [self.viewControllers count], @"");
	
	MHTabBarButton *button = (MHTabBarButton*)[[tabButtonsContainerView subviews] objectAtIndex:index];
	
	[button setState:state];
}

- (void)setIndicator:(UIImageView *)indicator
{
	customIndicator = YES;
	
	CGRect frameIndicator = indicator.frame;
	frameIndicator.origin.y += tabButtonsContainerView.frame.origin.y;
	[indicator setFrame:frameIndicator];
	
	_indicatorOriginalFrame = frameIndicator;
	
	_indicator = indicator;
}

- (void)setViewControllers:(NSArray *)newViewControllers
{
	NSAssert([newViewControllers count] >= 1
			 , @"MHTabBarController requires at least two view controllers");
	
	UIViewController *oldSelectedViewController = self.selectedViewController;
	
	// Remove the old child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[viewController willMoveToParentViewController:nil];
		[viewController removeFromParentViewController];
	}
	
	_viewControllers = [newViewControllers copy];
	
	//	Calculate new width of button if no custom value specified
	if (customButtonWidth == NO)
		[self setButtonWidth:floorf(self.view.bounds.size.width / [_viewControllers count])];
	
	// This follows the same rules as UITabBarController for trying to
	// re-select the previously selected view controller.
	NSUInteger newIndex = [_viewControllers indexOfObject:oldSelectedViewController];
	if (newIndex != NSNotFound)
		_selectedIndex = newIndex;
	else if (newIndex < [_viewControllers count])
		_selectedIndex = newIndex;
	else
		_selectedIndex = 0;
	
	// Add the new child view controllers.
	for (UIViewController *viewController in _viewControllers)
	{
		[self addChildViewController:viewController];
		[viewController didMoveToParentViewController:self];
	}
	
	if ([self isViewLoaded])
		[self reloadTabButtons];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
	[self setSelectedIndex:newSelectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex animated:(BOOL)animated
{
	NSAssert(newSelectedIndex < [self.viewControllers count], @"View controller index out of bounds");
	
	if ([self.delegate respondsToSelector:@selector(mh_tabBarController:shouldSelectViewController:atIndex:)])
	{
		UIViewController *toViewController = (self.viewControllers)[newSelectedIndex];
		if (![self.delegate mh_tabBarController:self shouldSelectViewController:toViewController atIndex:newSelectedIndex])
			return;
	}
	
	if (![self isViewLoaded])
	{
		_selectedIndex = newSelectedIndex;
	}
	else if (_selectedIndex != newSelectedIndex)
	{
		for (unsigned int i = 0; i < [self.viewControllers count]; i++)
		{
			[self changeButtonStateIndex:i toState:UIControlStateNormal];
		}
		
		UIViewController *fromViewController;
		UIViewController *toViewController;
		
		if (_selectedIndex != NSNotFound)
		{
			MHTabBarButton *fromButton = (MHTabBarButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self deselectTabButton:fromButton];
			fromViewController = self.selectedViewController;
		}
		
		NSUInteger oldSelectedIndex = _selectedIndex;
		_selectedIndex = newSelectedIndex;
		
		MHTabBarButton *toButton;
		if (_selectedIndex != NSNotFound)
		{
			toButton = (MHTabBarButton *)[tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
			[self selectTabButton:toButton];
			toViewController = self.selectedViewController;
		}
		
		if (toViewController == nil)  // don't animate
		{
			[fromViewController.view removeFromSuperview];
		}
		else if (fromViewController == nil)  // don't animate
		{
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
			
			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
		else if (animated)
		{
			CGRect rect = contentContainerView.bounds;
			if (oldSelectedIndex < newSelectedIndex)
				rect.origin.x = rect.size.width;
			else
				rect.origin.x = -rect.size.width;
			
			toViewController.view.frame = rect;
			//			tabButtonsContainerView.userInteractionEnabled = NO;
			
			[self transitionFromViewController:fromViewController
							  toViewController:toViewController
									  duration:0.3f
									   options:UIViewAnimationOptionLayoutSubviews | UIViewAnimationOptionCurveEaseOut
									animations:^
			 {
				 CGRect rect = fromViewController.view.frame;
				 if (oldSelectedIndex < newSelectedIndex)
					 rect.origin.x = -rect.size.width;
				 else
					 rect.origin.x = rect.size.width;
				 
				 fromViewController.view.frame = rect;
				 toViewController.view.frame = contentContainerView.bounds;
				 //					dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
				 //						dispatch_async(dispatch_get_main_queue(), ^{
				 //							CGRect rect = fromViewController.view.frame;
				 //							if (oldSelectedIndex < newSelectedIndex)
				 //								rect.origin.x = -rect.size.width;
				 //							else
				 //								rect.origin.x = rect.size.width;
				 //
				 //							fromViewController.view.frame = rect;
				 //							toViewController.view.frame = contentContainerView.bounds;
				 //						});
				 //					});
				 
				 [self centerIndicatorOnButton:toButton];
			 }
									completion:^(BOOL finished)
			 {
				 tabButtonsContainerView.userInteractionEnabled = YES;
				 
				 if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
					 [self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
			 }];
		}
		else  // not animated
		{
			[fromViewController.view removeFromSuperview];
			
			toViewController.view.frame = contentContainerView.bounds;
			[contentContainerView addSubview:toViewController.view];
			[self centerIndicatorOnButton:toButton];
			
			if ([self.delegate respondsToSelector:@selector(mh_tabBarController:didSelectViewController:atIndex:)])
				[self.delegate mh_tabBarController:self didSelectViewController:toViewController atIndex:newSelectedIndex];
		}
	}
}

- (UIViewController *)selectedViewController
{
	if (self.selectedIndex != NSNotFound)
		return (self.viewControllers)[self.selectedIndex];
	else
		return nil;
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController
{
	[self setSelectedViewController:newSelectedViewController animated:NO];
}

- (void)setSelectedViewController:(UIViewController *)newSelectedViewController animated:(BOOL)animated
{
	NSUInteger index = [self.viewControllers indexOfObject:newSelectedViewController];
	if (index != NSNotFound)
		[self setSelectedIndex:index animated:animated];
}


#pragma mark - Private Methods

- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];

	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)addTabButtons
{
	NSUInteger index = 0;
	for (UIViewController *viewController in self.viewControllers)
	{
		MHTabBarButton *button = [[MHTabBarButton alloc] initWithTitle:viewController.tabBarItem.title];
		button.tag = TagOffset + index;
		
		if ([self.delegate respondsToSelector:@selector(personalizeButton:toViewController:)])
			button = [self.delegate personalizeButton:button toViewController:viewController];
		else button = [self personalizeButton:button toViewController:viewController];

		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];

		[self deselectTabButton:button];
		[tabButtonsContainerView addSubview:button];

		++index;
	}
}

- (void)removeTabButtons
{
	while ([tabButtonsContainerView.subviews count] > 0)
	{
		[[tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.viewControllers count];
	if (count == 0)
		return;

	CGRect rect = CGRectMake(0.0f, 0.0f, _buttonWidth, _barHeight);

	_indicator.hidden = YES;

	for (MHTabBarButton *button in [tabButtonsContainerView subviews])
	{
		if ((index == count - 1) && (customButtonWidth == NO))
			rect.size.width = self.view.bounds.size.width - rect.origin.x;

		button.frame = rect;
		rect.origin.x += rect.size.width;

		if (index == self.selectedIndex)
			[self centerIndicatorOnButton:button];

		++index;
	}
}

- (void)centerIndicatorOnButton:(MHTabBarButton *)button
{
	if ([_delegate respondsToSelector:@selector(mh_tabBarController:personalizeIndicator:toButton:)])
	{
		[_delegate mh_tabBarController:self personalizeIndicator:_indicator toButton:button];
	}
	else
	{
		CGRect rect = _indicator.frame;
		rect.origin.x = (_buttonWidth * _selectedIndex);
		//	rect.origin.y = _barHeight - _indicator.frame.size.height;
		_indicator.frame = rect;
		_indicator.hidden = NO;
	}
}



#pragma mark - Delegate objects

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"[MHTabBarController]: Touch ended");
}

- (void)swipeLeft:(UISwipeGestureRecognizer*)recognizer
{
	NSLog(@"[MHTabBarController]: Swipe Left. State: %d - %d", recognizer.state, UIGestureRecognizerStateRecognized);
	
	CGPoint point = [recognizer locationInView:contentContainerView];
	NSLog(@"[MHTabBarController]: Swipe Left Location %@", NSStringFromCGPoint(point));
	
	if (point.x >= 300)
	{
		NSLog(@"[MHTabBarController]: Correct position.");
		if (_selectedIndex == ([_viewControllers count] - 1))
			[self setSelectedIndex:0 animated:YES];
		else [self setSelectedIndex:(_selectedIndex + 1) animated:YES];
	}
	
}

- (void)swipeRight:(UISwipeGestureRecognizer*)recognizer
{
	NSLog(@"[MHTabBarController]: Swipe Right. State: %d - %d", recognizer.state, UIGestureRecognizerStateRecognized);
	
	CGPoint point = [recognizer locationInView:contentContainerView];
	NSLog(@"[MHTabBarController]: Swipe Right Location %@", NSStringFromCGPoint(point));
	
	if (point.x <= 20)
	{
		NSLog(@"[MHTabBarController]: Correct position.");
		if (_selectedIndex == 0)
			[self setSelectedIndex:([_viewControllers count] - 1) animated:YES];
		else [self setSelectedIndex:(_selectedIndex - 1) animated:YES];
	}
	
}

- (void)tabButtonPressed:(MHTabBarButton *)sender
{
	[self setSelectedIndex:sender.tag - TagOffset animated:YES];
}



#pragma mark - Change these methods to customize the look of the buttons

// You can customize this method, or use the delegator to create method without change
- (MHTabBarButton*)personalizeButton:(MHTabBarButton*)button toViewController:(UIViewController *)viewController
{
	button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
	
	//	Normal status of the button
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	UIImage *image = [[UIImage imageNamed:@"MHTabBarInactiveTab"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateNormal];
	
	[button setTitleColor:[UIColor colorWithRed:175/255.0f green:85/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateNormal];
	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	//	Selected status and highlighted
	[button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
	image = [[UIImage imageNamed:@"MHTabBarActiveTab"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[button setBackgroundImage:image forState:UIControlStateSelected];
	
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateSelected];
	
	
	UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
	button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
	button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
	[button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
	[button setImage:viewController.tabBarItem.image forState:UIControlStateNormal];
	
	return button;
}

- (void)selectTabButton:(MHTabBarButton *)button
{
	[button setSelected:YES];
}

- (void)deselectTabButton:(MHTabBarButton *)button
{
	[button setSelected:NO];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//	return UIStatusBarStyleLightContent;
//}

@end
