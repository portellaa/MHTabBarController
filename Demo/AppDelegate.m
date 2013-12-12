
#define COLOR_MENU_SUBMENU 0x414042
#define COLOR_BUTTON_SELECTED 0x1d1d24
#define COLOR_SELECTED_LINE 0x00d2ff
#define COLOR_MENU_COMBO 0x363436

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#import "AppDelegate.h"
#import "ListViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	ListViewController *listViewController1 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController2 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	ListViewController *listViewController3 = [[ListViewController alloc] initWithStyle:UITableViewStylePlain];
	
	listViewController1.title = @"1";
	listViewController2.title = @"2";
	listViewController3.title = @"3";

//	listViewController2.tabBarItem.image = [UIImage imageNamed:@"Taijitu"];
//	listViewController2.tabBarItem.imageInsets = UIEdgeInsetsMake(0.0f, -4.0f, 0.0f, 0.0f);
//	listViewController2.tabBarItem.titlePositionAdjustment = UIOffsetMake(4.0f, 0.0f);

	NSArray *viewControllers = @[listViewController1, listViewController2, listViewController3];
	MHTabBarController *tabBarController = [[MHTabBarController alloc] init];
	[tabBarController setButtonWidth:50.0f];
	[tabBarController setBarHeight:50.0f];
	[tabBarController setBarColor:UIColorFromRGB(COLOR_MENU_SUBMENU)];
	[tabBarController setSwipe:(UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight)];
	
	UIImageView *indicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, ([tabBarController barHeight] - 5.0f), [tabBarController buttonWidth], 5.0f)];
	[indicator setBackgroundColor:UIColorFromRGB(COLOR_SELECTED_LINE)];
	[tabBarController setIndicator:indicator];

	tabBarController.delegate = self;
	tabBarController.viewControllers = viewControllers;

	// Uncomment this to select "Tab 2".
	//tabBarController.selectedIndex = 1;

	// Uncomment this to select "Tab 3".
	//tabBarController.selectedViewController = listViewController3;

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = tabBarController;
	[self.window makeKeyAndVisible];
	return YES;
}

- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);

	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);

	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
}

- (MHTabBarButton*)personalizeButton:(MHTabBarButton*)button toViewController:(UIViewController*)viewController
{
	button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
	
//	
	[button setBackgroundColor:UIColorFromRGB(COLOR_MENU_COMBO) forState:UIControlStateReserved];
	[button setTitleColor:UIColorFromRGB(COLOR_SELECTED_LINE) forState:UIControlStateReserved];
//	[button setTitle:@"4" forState:UIControlStateHighlighted];
	
//	Normal status of the button
	[button setBackgroundColor:UIColorFromRGB(COLOR_MENU_SUBMENU) forState:UIControlStateNormal];
	[button setTitleColor:UIColorFromRGB(COLOR_SELECTED_LINE) forState:UIControlStateNormal];
	
//	UIImage *image = [[UIImage imageNamed:@"MHTabBarInactiveTab"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
//	[button setBackgroundImage:image forState:UIControlStateNormal];
	
//	[button setTitleColor:[UIColor colorWithRed:175/255.0f green:85/255.0f blue:58/255.0f alpha:1.0f] forState:UIControlStateNormal];
//	[button setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	
//	Selected status and highlighted
	[button setBackgroundColor:UIColorFromRGB(COLOR_BUTTON_SELECTED) forState:UIControlStateSelected];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
//	[button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//	image = [[UIImage imageNamed:@"MHTabBarActiveTab"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//	[button setBackgroundImage:image forState:UIControlStateSelected];
//	
//	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
//	[button setTitleShadowColor:[UIColor colorWithWhite:0.0f alpha:0.5f] forState:UIControlStateSelected];
//	
//	
//	UIOffset offset = viewController.tabBarItem.titlePositionAdjustment;
//	button.titleEdgeInsets = UIEdgeInsetsMake(offset.vertical, offset.horizontal, 0.0f, 0.0f);
//	button.imageEdgeInsets = viewController.tabBarItem.imageInsets;
	[button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
//	[button setImage:viewController.tabBarItem.image forState:UIControlStateNormal];
	
	return button;
}

- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController personalizeIndicator:(UIView *)indicator toButton:(MHTabBarButton *)button
{
	NSLog(@"[Delegate] Selected Index: %u - New Selected Index: %u", tabBarController.selectedIndex, tabBarController.selectedIndex);
	
	if (tabBarController.selectedIndex == 0)
	{
		[tabBarController changeButtonStateIndex:1 toState:UIControlStateReserved];
		[tabBarController changeButtonStateIndex:2 toState:UIControlStateReserved];
		
		CGRect rect = indicator.frame;
		
		rect.origin.x = 0.0f;
		rect.size.width = 60.0f * 3;
		indicator.frame = rect;
		
		indicator.hidden = NO;
	}
	else
	{
//		[tabBarController changeButtonStateIndex:1 toState:UIControlStateNormal];
//		[tabBarController changeButtonStateIndex:2 toState:UIControlStateNormal];
		
		CGRect rect = indicator.frame;
		rect.size.width = 60.0f;
//		rect.origin.x = button.center.x - floorf(indicator.frame.size.width/2.0f);
		rect.origin.x = 60.0f * tabBarController.selectedIndex;
		//	rect.origin.y = _barHeight - _indicator.frame.size.height;
		indicator.frame = rect;
		
		indicator.hidden = NO;
	}
	
	return YES;
}

#pragma mark Style methods

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
