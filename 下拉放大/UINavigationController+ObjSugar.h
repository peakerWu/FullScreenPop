//
//  UINavigationController+ObjSugar.h
//  下拉放大
//
//  Created by peaker on 2017/3/1.
//  Copyright © 2017年 peaker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (ObjSugar)

@property (nonatomic, strong, readonly) UIPanGestureRecognizer *popGestureRecognizer;

@end
