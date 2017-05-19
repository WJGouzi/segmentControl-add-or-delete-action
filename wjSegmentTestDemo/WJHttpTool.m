//
//  WJHttpTool.m
//  sinaWeibo_dome
//
//  Created by JerryWang on 16/8/15.
//  Copyright © 2016年 JerryWang. All rights reserved.
//

#import "WJHttpTool.h"
#import "AFNetworking.h"

@implementation WJHttpTool

+ (AFHTTPSessionManager *)wjRequestManagerWithResponseSerializer:(AFHTTPResponseSerializer *) responseSerializer{
    
       AFHTTPSessionManager *  _wjRequestManager = [AFHTTPSessionManager manager];
        _wjRequestManager.responseSerializer = responseSerializer;

        _wjRequestManager.responseSerializer.acceptableContentTypes = [_wjRequestManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromArray:@[@"text/html", @"application/json"]];
        _wjRequestManager.requestSerializer.timeoutInterval = 15;
    
    return _wjRequestManager;
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [self wjRequestManagerWithResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    // 2.发送请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success) {
            success(responseObject); // block回调
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getXML:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{

    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [self wjRequestManagerWithResponseSerializer:[AFHTTPResponseSerializer serializer]];
    
    // 2.发送请求
    [mgr GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject); // block回调
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [self wjRequestManagerWithResponseSerializer:[AFJSONResponseSerializer serializer]];

    // 2.发送请求
    
    [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject); // block回调
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)post:(NSString *)url params:(NSDictionary *)params constructingBody:(void(^)(id<AFMultipartFormData> formData))constructingBody success:(void (^)(id respenseObject))success failure:(void (^)(NSError *error))failure{

    AFHTTPSessionManager * mgr = [self wjRequestManagerWithResponseSerializer:[AFJSONResponseSerializer serializer]];
    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (constructingBody) {
            constructingBody(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        float progress = uploadProgress.completedUnitCount/uploadProgress.totalUnitCount;
        NSLog(@"上传进度：%.f%%",progress*100);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
