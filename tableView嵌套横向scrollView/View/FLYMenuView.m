//
//  FLYMenuView.m
//  tableView嵌套横向scrollView
//
//  Created by fly on 2020/7/10.
//  Copyright © 2020 fly. All rights reserved.
//

#import "FLYMenuView.h"

@interface FLYMenuView ()

@property (nonatomic, strong) UIButton * button1;
@property (nonatomic, strong) UIButton * button2;
@property (nonatomic, strong) UIButton * button3;

@end

@implementation FLYMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.button1.frame = CGRectMake(0, 80, self.frame.size.width / 3.0, 30);
    self.button2.frame = CGRectMake(CGRectGetMaxX(self.button1.frame), 80, self.frame.size.width / 3.0, 30);
    self.button3.frame = CGRectMake(CGRectGetMaxX(self.button2.frame), 80, self.frame.size.width / 3.0, 30);
}



#pragma mark - UI

- (void)initUI
{
    [self addSubview:self.button1];
    [self addSubview:self.button2];
    [self addSubview:self.button3];
}



#pragma mark - event handler

- (void)click:(UIButton *)button
{
    !self.block ?: self.block(button.tag);
}



#pragma mark - setters and getters

- (UIButton *)button1
{
    if( _button1 == nil )
    {
        _button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button1 setTitle:@"第一页" forState:UIControlStateNormal];
        [_button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _button1.backgroundColor = [UIColor lightGrayColor];
        [_button1 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _button1.tag = 0;
    }
    return _button1;
}

- (UIButton *)button2
{
    if( _button2 == nil )
    {
        _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button2 setTitle:@"第二页" forState:UIControlStateNormal];
        [_button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _button2.backgroundColor = [UIColor lightGrayColor];
        [_button2 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _button2.tag = 1;
    }
    return _button2;
}

- (UIButton *)button3
{
    if( _button3 == nil )
    {
        _button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button3 setTitle:@"第三页" forState:UIControlStateNormal];
        [_button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _button3.backgroundColor = [UIColor lightGrayColor];
        [_button3 addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        _button3.tag = 2;
    }
    return _button3;
}


@end
