//
//  wjSegModel.h
//  wjSegmentTestDemo
//
//  Created by gouzi on 2017/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface wjSegModel : NSObject

/** namw*/
@property (nonatomic, strong) NSString *name_;

/** id*/
@property (nonatomic, strong) NSString *id_;



/* clicked*/
@property (nonatomic, assign, getter=isChecked) BOOL checked;


+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
