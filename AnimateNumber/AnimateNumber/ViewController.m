//
//  ViewController.m
//  AnimateNumber
//
//  Created by zhoushengjian on 17/2/6.
//  Copyright © 2017年 zhoushengjian. All rights reserved.
//

#import "ViewController.h"
#import "WLAnimateNumberView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WLAnimateNumberView *animateNumberView;
@property (weak, nonatomic) IBOutlet WLAnimateNumberView *animateNormalView;

@end

@implementation ViewController {
    double _number;
    NSTimer *_timer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _number = 1233213.0012;
    self.animateNumberView.text = [NSString stringWithFormat:@"%.5lf", _number];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

}

#pragma mark - Action

- (IBAction)upScrollAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    if (_timer) {
        [_timer invalidate];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        _number += 0.003345;
        weakSelf.animateNumberView.text = [NSString stringWithFormat:@"%.5f", _number];
    }];
}

- (IBAction)interactScrollAction:(id)sender {
    _number += 0.87897;
    self.animateNormalView.text = [NSString stringWithFormat:@"%.5f", _number];
}

@end
