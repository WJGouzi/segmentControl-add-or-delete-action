//
//  wjSegModel.m
//  wjSegmentTestDemo
//
//  Created by gouzi on 2017/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjSegModel.h"

@implementation wjSegModel

+ (instancetype)modelWithDict:(NSDictionary *)dict {
    wjSegModel *model = [[self alloc] init];
    model.name_ = dict[@"name_"];
    model.id_ = dict[@"id_"];
    return model;
}


@end
