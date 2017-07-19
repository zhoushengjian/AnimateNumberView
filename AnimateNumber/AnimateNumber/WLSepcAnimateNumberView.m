//
//  WLSepcAnimateNumberView2.m
//  AnimateNumber
//
//  Created by zhoushengjian on 2017/5/3.
//  Copyright © 2017年 zhoushengjian. All rights reserved.
//

#import "WLSepcAnimateNumberView.h"

@implementation WLSepcAnimateNumberView {
    NSInteger _diffColorTag;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *digitViewArr = [self.digitViews copy];
    for (int i=0; i<digitViewArr.count; i++) {
        UITableView *digitView = digitViewArr[i];
        if (digitView.tag < _diffColorTag) {
            WLAnimateNumberCell *cell = [digitView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
            cell.label.textColor = [UIColor redColor];
        }
    }
}

- (void)setText:(NSString *)text {
    
    for (int i=0; i<text.length; i++) {
        NSString *tempStr = [text substringWithRange:NSMakeRange(i, 1)];
        if ([tempStr intValue] > 0) {
            _diffColorTag = i;
            break;
        }
    }
    
    [super setText:text];
}



@end
