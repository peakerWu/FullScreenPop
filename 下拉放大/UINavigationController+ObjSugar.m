//
//  UINavigationController+ObjSugar.m
//  下拉放大
//
//  Created by peaker on 2017/3/1.
//  Copyright © 2017年 peaker. All rights reserved.
//

#import "UINavigationController+ObjSugar.h"
#import <objc/runtime.h>

@interface FullScreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation FullScreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // 如果是根控制器不需要手势
    if (self.navigationController.viewControllers.count <= 1) return NO;
    
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) return NO;
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    // 去除右滑的情况(右滑不删除)
    if (translation.x <= 0) return NO;
    
    return YES;
}

@end

@implementation UINavigationController (ObjSugar)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod([self class], @selector(pushViewController:animated:));

    Method swizzledMethod = class_getInstanceMethod([self class],  @selector(pk_pushViewController:animated:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
    
}

- (void)pk_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.popGestureRecognizer]) {
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.popGestureRecognizer];
        
        NSArray *targets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [targets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        
        self.popGestureRecognizer.delegate = [self fullScreenPopGestureRecognizerDelegate];
        [self.popGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // 禁用系统的交互手势
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (![self.viewControllers containsObject:viewController]) {
        [self pk_pushViewController:viewController animated:animated];
    }
}

- (UIPanGestureRecognizer *)popGestureRecognizer
{
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
    if (!pan) {
        pan = [[UIPanGestureRecognizer alloc] init];
        pan.maximumNumberOfTouches = 1;
        objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return pan;
}

- (FullScreenPopGestureRecognizerDelegate *)fullScreenPopGestureRecognizerDelegate
{
    FullScreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    // 进行懒加载
    if (!delegate) {
        
        delegate = [[FullScreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

@end
