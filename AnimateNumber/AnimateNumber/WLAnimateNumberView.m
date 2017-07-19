//
//  AnimateNumberView.m
//  AnimateNumber
//
//  Created by zhoushengjian on 17/2/6.
//  Copyright © 2017年 zhoushengjian. All rights reserved.
//

#import "WLAnimateNumberView.h"
#import "UIView+Frame.h"

#define stringFormat(string) (string == nil)?@"":[@"<null>" isEqualToString:[NSString stringWithFormat:@"%@",string]]?@"":[NSString stringWithFormat:@"%@",string]
#define kFontName @"PingFangSC-Regular"

@implementation WLAnimateNumberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:textLabel];
        self.label = textLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

@end


@interface WLAnimateNumberView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *digits;
@property (nonatomic, assign) CGFloat digitWidth;
@property (nonatomic, assign) CGFloat digitSmallWidth;
@property (assign, nonatomic) CGFloat commaViewWidth;
@property (assign, nonatomic) CGFloat dotViewWidth;

@property (nonatomic, strong) UILabel *placeHoldLabel;

@end

@implementation WLAnimateNumberView {
    NSInteger _dotDigitsViewTag;
    NSInteger _commaDigitsViewTag;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.placeHoldLabel];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self addSubview:self.placeHoldLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.placeHoldLabel.frame = self.bounds;
        
    _dotDigitsViewTag = 1000;
    _commaDigitsViewTag = 1000;
    CGFloat textWidth = [self calculateTextWidth:_text];
    
    CGFloat digitViewX = 0;
    if (_textAlignment == 3) {
        digitViewX = self.width-textWidth;
    }else if (_textAlignment == 2) {
        digitViewX = (self.width-textWidth)/2;
    }
    
    NSArray *digitViews = [self.digitViews copy];
    for (int i=0; i<_text.length; i++) {
        UITableView *digitView = digitViews[i];
        
        BOOL isSmallFont = (i>_dotDigitsViewTag)&&_isAttributeString;
        [self digitView:digitView digitViewX:digitViewX isSmallFont:isSmallFont];
        
        NSString *subString = [_text substringWithRange:NSMakeRange(i, 1)];
        if ([subString isEqualToString:@"."]) {
            digitViewX += _dotViewWidth;
        }else if ([subString isEqualToString:@","]) {
            digitViewX += _commaViewWidth;
        }else {
            digitViewX += isSmallFont?_digitSmallWidth:_digitWidth;
        }
    }
}

#pragma mark - Accessors

- (UILabel *)placeHoldLabel {
    if (!_placeHoldLabel) {
        _placeHoldLabel = [[UILabel alloc] init];
        _placeHoldLabel.text = @"--";
    }
    return _placeHoldLabel;
}

- (NSArray *)digits {
    if (!_digits) {
        _digits = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9];
    }
    return _digits;
}

- (NSMutableArray *)digitViews {
    if (!_digitViews) {
        _digitViews = [NSMutableArray array];
    }
    return _digitViews;
}

- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    _placeHoldLabel.font = [UIFont systemFontOfSize:fontSize];
}


- (void)setTextAlignment:(NSInteger)textAlignment {
    _textAlignment = textAlignment;
    self.placeHoldLabel.textAlignment = _textAlignment==1?NSTextAlignmentLeft:(_textAlignment==2?NSTextAlignmentCenter:NSTextAlignmentRight);
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.placeHoldLabel.textColor = textColor;
}

- (void)setText:(NSString *)text {
    
    if ([stringFormat(text) isEqualToString:@""] || [_text isEqualToString:text]) {
        return;
    }
    
    self.placeHoldLabel.hidden = YES;
    
    if (![self text:_text isSameFormatWithText:text]) {//两次数据格式不同 重新创建
        _text = text;
        
        for (UITableView *digitView in self.digitViews) {
            [digitView removeFromSuperview];
        }
        [self.digitViews removeAllObjects];
        
        for (int i=0; i<text.length; i++) {
            [self creatTableView:i];
        }
        //重排位置
        [self layoutSubviews];
    }
    
    _text = text;
    
    NSArray *digitViews = [self.digitViews copy];
    for (int i=0; i<text.length; i++) {
        UITableView *tableView = digitViews[i];
        
        NSString *digit = [NSString stringWithFormat:@"%@", [text substringWithRange:NSMakeRange(i, 1)]];
        NSInteger row = [digit integerValue];

        if ([digit isEqualToString:@"."]) {
            tableView.tag = _dotDigitsViewTag;
            continue;
        }
        
        if ([digit isEqualToString:@","]) {
            tableView.tag = _commaDigitsViewTag;
            continue;
        }
        
        NSArray<NSIndexPath *> *currentIndexPaths = [tableView indexPathsForRowsInRect:tableView.bounds];
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        WLAnimateNumberCell *cell = [tableView cellForRowAtIndexPath:currentIndexPaths[0]];

        if ([cell.label.text integerValue] > row) {
            scrollIndexPath = [NSIndexPath indexPathForRow:row+10 inSection:0];
        }
        
        if (scrollIndexPath.row < [tableView numberOfRowsInSection:0]) {
            [tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        if ([cell.label.text integerValue] > row) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        
    }
    
}


#pragma mark - Private

- (void)creatTableView:(NSInteger)i{
    UITableView *digitView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _digitWidth, self.fontSize)];
    
    digitView.tag = i;
    digitView.delegate = self;
    digitView.dataSource = self;
    digitView.showsVerticalScrollIndicator = NO;
    digitView.showsHorizontalScrollIndicator = NO;
    digitView.separatorStyle = UITableViewCellSeparatorStyleNone;
    digitView.userInteractionEnabled = NO;
    digitView.backgroundColor = [UIColor clearColor];
    [self addSubview:digitView];
    [self.digitViews addObject:digitView];
}

- (void)digitView:(UITableView *)digitView digitViewX:(CGFloat)digitViewX isSmallFont:(BOOL)isSmallFont {
    
    CGFloat digitViewY = (self.height-self.fontSize)/2;
    
    digitView.frame = CGRectMake(digitViewX, digitViewY, _digitWidth, self.fontSize);
    
    if (isSmallFont) {
        CGFloat extraY = round(_fontSize/_fontSmallSize)>=2?:1;
        digitView.frame = CGRectMake(digitViewX, digitViewY+(_fontSize-_fontSmallSize)-extraY, _digitSmallWidth, _fontSmallSize);
    }
    
    NSString *subString = [_text substringWithRange:NSMakeRange(digitView.tag, 1)];
    if ([subString isEqualToString:@"."]) {
        digitView.width = _dotViewWidth;//dotViewW;
    }
    if ([subString isEqualToString:@","]) {
        digitView.width = _commaViewWidth;//commaViewW;
    }
}

- (CGFloat)calculateTextWidth:(NSString *)text {
    
    [self countDigitWidth];
    
    CGFloat textWidth=0;
    
    for (int i=0; i<text.length; i++) {
        
        NSString *subString = [text substringWithRange:NSMakeRange(i, 1)];

        BOOL isSmallfont = ((i>_dotDigitsViewTag)&&_isAttributeString);

        if ([subString isEqualToString:@"."]) {
            
            textWidth += _dotViewWidth;
            _dotDigitsViewTag = i;
        }else if ([subString isEqualToString:@","]) {
            
            textWidth += _commaViewWidth;
            _commaDigitsViewTag = i;
        }else {
        
            textWidth += isSmallfont? _digitSmallWidth:_digitWidth;
            
        }
    }
    
    return textWidth;
}

- (void)countDigitWidth {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:_fontName?:kFontName size:_fontSize];
    label.text = @"0";
    [label sizeToFit];
    _digitWidth = label.width;
    label.text = @".";
    [label sizeToFit];
    _dotViewWidth = label.width;
    label.text = @",";
    [label sizeToFit];
    _commaViewWidth = label.width;
    label.font = [UIFont fontWithName:_fontName?:kFontName size:_fontSmallSize];
    label.text = @"0";
    [label sizeToFit];
    _digitSmallWidth = label.width;
}

- (BOOL)text:(NSString *)text isSameFormatWithText:(NSString *)text1 {
    
    if (text.length != text1.length) {
        return NO;
    }
    
    NSRange range = [text rangeOfString:@"."];
    NSRange range1 = [text1 rangeOfString:@"."];
    if (range.location != range1.location) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (tableView.tag==_dotDigitsViewTag || tableView.tag==_commaDigitsViewTag)? 1:20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"digitCell";
    WLAnimateNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WLAnimateNumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.label.textColor = self.textColor;

    }
    cell.backgroundColor = [UIColor clearColor];
    cell.label.font = [UIFont fontWithName:_fontName?: kFontName size:(tableView.tag>_dotDigitsViewTag)&&_isAttributeString?self.fontSmallSize:self.fontSize];
    
    if (tableView.tag == _dotDigitsViewTag) {
        cell.label.text = @".";
    }else if (tableView.tag == _commaDigitsViewTag) {
        cell.label.text = @",";

    }else {
        cell.label.text = [NSString stringWithFormat:@"%@", self.digits[indexPath.row%10]];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.height;
}

@end

