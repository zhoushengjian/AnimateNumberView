//
//  AnimateNumberView.h
//  AnimateNumber
//
//  Created by zhoushengjian on 17/2/6.
//  Copyright © 2017年 zhoushengjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WLAnimateNumberView : UIView

@property (nonatomic, copy)  NSString *text;
@property (nonatomic, assign) IBInspectable BOOL isAttributeString;
@property (nonatomic, assign) IBInspectable CGFloat fontSize;
@property (nonatomic, assign) IBInspectable CGFloat fontSmallSize;
@property (nonatomic, strong) IBInspectable UIColor *textColor;
@property (nonatomic, copy) IBInspectable NSString *fontName;
/** 1：左对齐 2：居中 3：右对齐 */
@property (nonatomic, assign) IBInspectable NSInteger textAlignment;

@property (nonatomic, strong) NSMutableArray *digitViews;


@end

@interface WLAnimateNumberCell : UITableViewCell

@property (nonatomic, weak) UILabel *label;

@end
