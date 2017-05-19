//
//  wjSegmentFirstVC.m
//  wjSegmentTestDemo
//
//  Created by gouzi on 2017/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjSegmentFirstVC.h"
#import "wjSegModel.h"
#import "WJHttpTool.h"
#import "wjSegCell.h"

@interface wjSegmentFirstVC ()


@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, strong) NSMutableArray *dataArray;


/** 选择的index*/
@property (nonatomic, strong) NSMutableArray *selectedIndexPathArray;

/** 没有选择的index*/
@property (nonatomic, strong) NSMutableArray *deSelectedIndexPathArray;

/** modelArray*/
@property (nonatomic, strong) NSMutableArray *selectedArray;

@end

@implementation wjSegmentFirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getPageDataFromServer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataAction:) name:@"seg2ToSeg1Action" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noDataDeleteAction:) name:@"noDataDeleteAction" object:nil];
    
}

#pragma mark - 通知相关
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataAction:(NSNotification *)notification {
    NSLog(@"seg2 to seg1 :%@",notification.object);
    NSLog(@"info is %@", notification.userInfo);
    NSMutableArray *seg2SelectedArray = (NSMutableArray *)notification.userInfo[@"selcted"];
    NSMutableArray *seg2DeSelectedArray = (NSMutableArray *)notification.userInfo[@"deSelected"];
    [self.dataArray removeObjectsInArray:seg2SelectedArray];
    [self.tableView reloadData];
    
    
    [seg2DeSelectedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isContain = [self.dataArray containsObject:obj];
        if (isContain == YES) {
            return ;
        } else {
            [self.dataArray addObjectsFromArray:seg2DeSelectedArray];
            [self.tableView reloadData];
        }
    }];
}


- (void)noDataDeleteAction:(NSNotification *)notification {
    NSMutableArray *selectedModelArray = (NSMutableArray *)notification.object;
    [self.dataArray removeObjectsInArray:selectedModelArray];
    [self.tableView reloadData];
}






- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)selectedIndexPathArray {
    if (!_selectedIndexPathArray) {
        _selectedIndexPathArray = [NSMutableArray array];
    }
    return _selectedIndexPathArray;
}

- (NSMutableArray *)deSelectedIndexPathArray {
    if (!_deSelectedIndexPathArray) {
        _deSelectedIndexPathArray = [NSMutableArray array];
    }
    return _deSelectedIndexPathArray;
}

// model
- (NSMutableArray *)selectedArray {
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}


#pragma mark - 请求数据
// url ： https://218.6.145.162:443/zxlz/ios/iosSqmyAction_iosQueryWyNameListi.action
/*
 para is {
 "accpetParam['name_']" = "";
 "accpetParam['page']" = 1;
 "accpetParam['rows']" = 10;
 */
-(void)getPageDataFromServer{
    NSString * url = @"https://218.6.145.162:443/zxlz/ios/iosSqmyAction_iosQueryWyNameListi.action";
    self.manager = [WJHttpTool wjRequestManagerWithResponseSerializer:[AFJSONResponseSerializer serializer]];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    
    self.manager.securityPolicy  = securityPolicy;
    
    self.manager.requestSerializer.timeoutInterval = 20;
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"json/html",@"text/plain",nil];
    [self.manager.securityPolicy setAllowInvalidCertificates:YES];
    
    NSMutableDictionary * parameters = @{}.mutableCopy;
    [parameters setValue:@"" forKey:@"accpetParam['name_']"];
    [parameters setValue:@1 forKey:@"accpetParam['page']"];
    [parameters setValue:@10 forKey:@"accpetParam['rows']"];
    NSMutableArray *temp = [NSMutableArray array];
    [self.manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *array = responseObject[@"data"][@"rows"];
        for (NSDictionary *dict in array) {
            [temp addObject:[wjSegModel modelWithDict:dict]];
        }
        self.dataArray = [temp mutableCopy];
//        self.tempArray = self.wineArray;
//        for (int i = 0; i < self.dataArray.count ; ++i) {
//            [self.deSelectedIndexPathArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error is %@", error);
    }];
}




#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *firstIden = @"firstCell";
    wjSegCell *cell = [tableView dequeueReusableCellWithIdentifier:firstIden];
    if (!cell) {
        cell = [[wjSegCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstIden];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    wjSegModel *model = self.dataArray[indexPath.row];
    if (model.isChecked) {
        model.checked = NO;
        //        [self.deSelectedIndexPathArray addObject:indexPath];
        [self.selectedIndexPathArray removeObject:indexPath];
        [self.selectedArray removeObject:model];
    } else {
        model.checked = YES;
        //        [self.deSelectedIndexPathArray removeObject:indexPath];
        [self.selectedIndexPathArray addObject:indexPath];
        [self.selectedArray addObject:model];
    }
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addArrayData" object:self.selectedArray userInfo:nil];
}


@end
