//
//  ViewController.m
//  wjSegmentTestDemo
//
//  Created by gouzi on 2017/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "ViewController.h"
#import "wjSegmentFirstVC.h"
#import "wjSegmentSecondVC.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *wjSegmentView;

/** seg1*/
@property (nonatomic, strong) wjSegmentFirstVC *firstVC;
/** seg2*/
@property (nonatomic, strong) wjSegmentSecondVC *secondVC;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.wjSegmentView addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.wjSegmentView.selectedSegmentIndex = 0;

    self.firstVC = [[wjSegmentFirstVC alloc] init];
    self.firstVC.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.secondVC = [[wjSegmentSecondVC alloc] init];
    self.secondVC.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:self.firstVC.view];
}




- (void)segmentClick:(UISegmentedControl *)segment {
    
    if (segment.selectedSegmentIndex == 0) {
        NSLog(@"");
        [self.view addSubview:self.firstVC.view];
        [self.secondVC.view removeFromSuperview];
    }
    if (segment.selectedSegmentIndex == 1) {
        [self.view addSubview:self.secondVC.view];
        [self.firstVC.view removeFromSuperview];
    }
}


@end
