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

#import "MHTabBarButton.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@protocol MHTabBarControllerDelegate;

/*
 * A custom tab bar container view controller. It works just like a regular
 * UITabBarController, except the tabs are at the top and look different.
 */
@interface MHTabBarController : UIViewController<UIGestureRecognizerDelegate>

/**
 *  The top bar delegate object
 */
@property (nonatomic, weak) id <MHTabBarControllerDelegate> delegate;
/**
 *  Array of view controllers to be placed on the top bar
 */
@property (nonatomic, copy) NSArray *viewControllers;
/**
 *  The visible ViewController
 */
@property (nonatomic, weak) UIViewController *selectedViewController;
/**
 *  The index of the selected View controller
 */
@property (nonatomic, assign) NSUInteger selectedIndex;
/**
 *  Height of top bar
 */
@property (nonatomic) CGFloat barHeight;
/**
 *  Color of top bar
 */
@property (nonatomic, retain) UIColor *barColor;
/**
 *  Top location of the bar
 */
@property (nonatomic) CGPoint top;
/**
 *  Width of each button on the top bar. If no size specified, the width is calculated with the top bar width and the number of view controllers
 */
@property (nonatomic) CGFloat buttonWidth;
/**
 *  View used to create the indicator
 */
@property (nonatomic, retain) UIImageView *indicator;

@property (nonatomic, strong) UIColor *topBarColor;

/**
 *  Used to change the visible view controller using the index of the view on the top bar.
 *
 *  @param index    A NSUInteger value with the index of the view controller to be selected
 *  @param animated A BOOL value that indicates if the transition to the new view controller should be animated
 */
- (void)setSelectedIndex:(NSUInteger)index animated:(BOOL)animated;
/**
 *  Used to change the visible view controller with the view controller that is to be visible.
 *
 *  @param viewController An UIViewController instance that is to shown
 *  @param animated       A BOOL value that indicates if the transition to the new view controller should be animated
 */
- (void)setSelectedViewController:(UIViewController *)viewController animated:(BOOL)animated;
/**
 *  This method is used to force the status of a button on the top bar
 *
 *  @param index A NSUInteger value with the index of the button that is to be changed
 *  @param state An UIControlState with the new state of the button
 */
- (void)changeButtonStateIndex:(NSUInteger)index toState:(UIControlState)state;

- (void)setSwipe:(UISwipeGestureRecognizerDirection)recognizerDirection;

@end

/*
 * The delegate protocol for MHTabBarController.
 */
@protocol MHTabBarControllerDelegate <NSObject>
@optional
- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)mh_tabBarController:(MHTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (MHTabBarButton*)personalizeButton:(MHTabBarButton*)button toViewController:(UIViewController*)viewController;

- (BOOL)mh_tabBarController:(MHTabBarController*)tabBarController personalizeIndicator:(UIView*)indicator toButton:(MHTabBarButton*)button;

@end
