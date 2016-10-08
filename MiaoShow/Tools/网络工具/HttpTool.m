//
//  HttpTool.m
//  数据缓存
//
//  Created by huhang on 15/12/28.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import "HttpTool.h"
#import <AFNetworking.h>

@implementation HttpTool

//get请求
+ (NSURLSessionDataTask *)get:(NSString *)url params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure cachePolicy:(RequestCachePolicy)cachePolicy {
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.cachePolicy = (NSURLRequestCachePolicy) cachePolicy;
    //请求多长时间
    mgr.requestSerializer.timeoutInterval = 15;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/javascript",@"application/json",@"text/json",@"text/xml",nil];
   NSURLSessionDataTask *operation = [mgr GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        
    }];
    
    return operation;
}

//Post请求
+ (NSURLSessionDataTask *)post:(NSString *)url params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure cachePolicy:(RequestCachePolicy)cachePolicy {
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer.cachePolicy = (NSURLRequestCachePolicy) cachePolicy;
    //请求15秒
    mgr.requestSerializer.timeoutInterval = 15;
    //跟接口有关系,添加手动设置
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];

    NSURLSessionDataTask *task = [mgr POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    return task;
}

+ (NSURLSessionDataTask *)getHomeTopScycleImage:(SuccessBlock)success failure:(FailureBlock)failure{

   return [self get:HomeTopScycleImageUrl params:nil success:success failure:failure cachePolicy:RequestCachePolicyCacheDefault];
}

+ (NSURLSessionDataTask *)getHomeHotDataPage:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure{

    NSString *hotUrl = [HomeHotDataUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",page]];
    
    return [self get:hotUrl params:nil success:success failure:failure cachePolicy:RequestCachePolicyCacheDefault];
}

+ (NSURLSessionDataTask *)getHomeNewDataPage:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure{

    NSString *hotUrl = [HomeNewDateUrl stringByAppendingString:[NSString stringWithFormat:@"%ld",page]];
    
    return [self get:hotUrl params:nil success:success failure:failure cachePolicy:RequestCachePolicyCacheDefault];
}

+ (NSURLSessionDataTask *)getUserLiveUrl:(NSString *)url success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    return [self get:url params:nil success:success failure:failure cachePolicy:RequestCachePolicyCacheDefault];
}

@end
