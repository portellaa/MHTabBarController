MHTabBarController
==================

This is a custom container view controller that works on iOS 5, 6 and 7 and behaves just like a regular UITabBarController, except the tabs are at the top. It is possible too to fully customize the tab bar, with a different indicator, icons and text.

![Screenshot](https://github.com/hollance/MHTabBarController/raw/master/ss_multipletabs.png)

<iframe width="420" height="315" src="//www.youtube.com/embed/jA6YD3ctNdA" frameborder="0" allowfullscreen></iframe>

<p>To customize the tab bar look, you can delegate the controller, or if you are subclassing, override the method:</p>
<code>
- (MHTabBarButton*)personalizeButton:(MHTabBarButton*)button toViewController:(UIViewController *)viewController
</code>

## MHTabBarControllerDelegate

- <b>- (MHTabBarButton*)personalizeButton:(MHTabBarButton*)button toViewController:(UIViewController*)viewController</b>

Allows tab button customization. For example, to archive the screenshot customization, you can use the following block of code:
<code>
	
	button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
	
	[button setBackgroundColor:UIColorFromRGB(COLOR_MENU_COMBO) forState:UIControlStateReserved];
	[button setTitleColor:UIColorFromRGB(COLOR_SELECTED_LINE) forState:UIControlStateReserved];
	
	[button setBackgroundColor:UIColorFromRGB(COLOR_MENU_SUBMENU) forState:UIControlStateNormal];
	[button setTitleColor:UIColorFromRGB(COLOR_SELECTED_LINE) forState:UIControlStateNormal];
	
	[button setBackgroundColor:UIColorFromRGB(COLOR_BUTTON_SELECTED) forState:UIControlStateSelected];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	
	[button setTitle:viewController.tabBarItem.title forState:UIControlStateNormal];
	
</code>

- <b>- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController personalizeIndicator:(UIView *)indicator toButton:(MHTabBarButton *)button</b>

Allows indicator customization to each tab button. Example:
<code>

	if (tabBarController.selectedIndex == 0)
	{
		[tabBarController changeButtonStateIndex:1 toState:UIControlStateReserved];
		[tabBarController changeButtonStateIndex:2 toState:UIControlStateReserved];
		
		CGRect rect = indicator.frame;
		
		rect.origin.x = 0.0f;
		rect.size.width = 50.0f * 3;
		indicator.frame = rect;
		
		indicator.hidden = NO;
	}
	else
	{
		CGRect rect = indicator.frame;
		rect.size.width = 50.0f;
		rect.origin.x = 50.0f * tabBarController.selectedIndex;
		indicator.frame = rect;
		
		indicator.hidden = NO;
	}
	
	return YES;

</code>


&copy;Luís Portela Afonso, 2013-2014

The MHTabBarController source code is copyright 2011-2012 Matthijs Hollemans and is licensed under the terms of the MIT license.
