//
//  FLYTableView.m
//  tableView嵌套横向scrollView
//
//  Created by fly on 2020/7/10.
//  Copyright © 2020 fly. All rights reserved.
//

#import "FLYTableView.h"

@implementation FLYTableView

// 这个方法是支持多手势，当滑动子控制器中的scrollView时，FLYTableView也能接收滑动事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

@end
