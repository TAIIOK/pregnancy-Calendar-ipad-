//
//  UIViewController+UIVCOrientationFix.m
//  Календарь беременности
//
//  Created by deck on 04.05.16.
//  Copyright © 2016 deck. All rights reserved.
//

#import "UIViewController+UIVCOrientationFix.h"

@implementation UIViewController (UIVCOrientationFix)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

@end
