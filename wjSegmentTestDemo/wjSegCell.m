//
//  wjWineCell.m
//  1-数据刷新
//
//  Created by gouzi on 2017/5/11.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjSegCell.h"
#import "wjSegModel.h"


@interface wjSegCell ()

@property (nonatomic, strong) UIImageView *checkImageView;

@end


@implementation wjSegCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 添加选中控件
        self.checkImageView = [[UIImageView alloc] init];
        self.checkImageView.hidden = YES;
        self.checkImageView.image = [UIImage imageNamed:@"check"];
        [self.contentView addSubview:self.checkImageView];
//        self.textLabel.text = self.model.name_;
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    // 选中控件
    CGFloat WH = 24;
    CGFloat X = self.contentView.frame.size.width - WH - 10;
    CGFloat Y = (self.contentView.frame.size.height - WH) * 0.5;
    self.checkImageView.frame = CGRectMake(X, Y, WH, WH);
    
    // 调整label的宽度
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.size.width = self.contentView.frame.size.width - WH - 20 - self.textLabel.frame.origin.x;
    self.textLabel.frame = labelFrame;
}






- (void)setModel:(wjSegModel *)model {
    _model = model;
    self.textLabel.text = [model.name_ mutableCopy];
    
    if (model.checked) {
        self.checkImageView.hidden = NO;
    } else {
        self.checkImageView.hidden = YES;
    }
    
}

@end
