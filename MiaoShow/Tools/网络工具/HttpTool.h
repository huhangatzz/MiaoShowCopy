//
//  HttpTool.h
//  数据缓存
//
//  Created by huhang on 15/12/28.
//  Copyright (c) 2015年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestCachePolicy)
{
    RequestCachePolicyCacheDefault = NSURLRequestUseProtocolCachePolicy,
    RequestCachePolicyIgnoringCacheData = NSURLRequestReloadIgnoringCacheData,
    RequestCachePolicyReturnCacheDataElseLoad = NSURLRequestReturnCacheDataElseLoad,
    RequestCachePolicyReturnCacheDataDontLoad = NSURLRequestReturnCacheDataDontLoad,
};

typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailureBlock)(NSError *error);

@interface HttpTool : NSObject

/**
 *  获取热门视图中轮播图
 *
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 返回task
 */
+ (NSURLSessionDataTask *)getHomeTopScycleImage:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  热门视图数据
 *
 *  @param page    页数
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 返回task
 */
+ (NSURLSessionDataTask *)getHomeHotDataPage:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  最新视图数据
 *
 *  @param page    页数
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 返回task
 */
+ (NSURLSessionDataTask *)getHomeNewDataPage:(NSInteger)page success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *  用户http请求该地址,若请求成功表示直播未结束，否则结束
 *
 *  @param url     直播url
 *  @param success 同上
 *  @param failure 同上
 *
 *  @return 返回task
 */
+ (NSURLSessionDataTask *)getUserLiveUrl:(NSString *)url success:(SuccessBlock)success failure:(FailureBlock)failure;

@end
