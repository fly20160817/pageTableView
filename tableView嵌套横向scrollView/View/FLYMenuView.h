//
//  FLYMenuView.h
//  tableView嵌套横向scrollView
//
//  Created by fly on 2020/7/10.
//  Copyright © 2020 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLYMenuView : UIView

@property (nonatomic, copy) void(^block)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
