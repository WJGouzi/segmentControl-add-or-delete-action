//
//  wjSegmentSecondVC.m
//  wjSegmentTestDemo
//
//  Created by gouzi on 2017/5/18.
//  Copyright © 2017年 wj. All rights reserved.
//

#import "wjSegmentSecondVC.h"
#import "wjSegCell.h"
#import "wjSegModel.h"


@interface wjSegmentSecondVC ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *deSelectedModelArray;

/** 选择的model*/
@property (nonatomic, strong) NSMutableArray *selectedModelArray;


@end

@implementation wjSegmentSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAction:) name:@"addArrayData" object:nil];

    
}





- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


- (NSMutableArray *)deSelectedModelArray {
    if (!_deSelectedModelArray) {
        _deSelectedModelArray = [NSMutableArray array];
    }
    return _deSelectedModelArray;
}


- (NSMutableArray *)selectedModelArray {
    if (!_selectedModelArray) {
        _selectedModelArray = [NSMutableArray array];
    }
    return _selectedModelArray;
}



#pragma mark - 通知相关
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addAction:(NSNotification *)notification {
    self.selectedModelArray = (NSMutableArray *)notification.object;
    self.dataArray = self.selectedModelArray;
    [self.tableView reloadData];
//    for (int i = 0; i < self.dataArray.count; i++) {
//        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
//        [self tableView:self.tableView didSelectRowAtIndexPath:index];
//    }
}




#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *secondIden = @"secondCell";
    wjSegCell *cell = [tableView dequeueReusableCellWithIdentifier:secondIden];
    if (!cell) {
        cell = [[wjSegCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:secondIden];
    }
    cell.model = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark - delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    wjSegModel *model = self.dataArray[indexPath.row];
//    if (model.isChecked) {
//        model.checked = NO;
//        //        [self.deSelectedIndexPathArray addObject:indexPath];
////        [self.selectedIndexPathArray removeObject:indexPath];
//    } else {
//        model.checked = YES;
//        //        [self.deSelectedIndexPathArray removeObject:indexPath];
////        [self.selectedIndexPathArray addObject:indexPath];
//    }
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    
//}


#pragma mark - 左划删除
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    wjSegModel *model = self.dataArray[indexPath.row];
    if (self.dataArray.count > 0) {
        model.checked = NO;
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.deSelectedModelArray addObject:model];
        [self.selectedModelArray removeObject:model];
    }
    
    
    NSDictionary *info = @{
                           @"deSelected" : self.deSelectedModelArray,
                           @"selcted" : self.selectedModelArray
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"seg2ToSeg1Action" object:self userInfo:info];
    self.deSelectedModelArray = nil;
    self.selectedModelArray = nil;
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 这里需要重新发另外一个通知，这里主要是为了在没有进行删除操作的时候，返回到seg1的时候进行删除seg2中
    self.selectedModelArray = self.dataArray;
    self.deSelectedModelArray = nil;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noDataDeleteAction" object:self.selectedModelArray userInfo:nil];
    self.selectedModelArray = nil;
    
}




@end
