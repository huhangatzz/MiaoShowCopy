//
//  NSSafeObject.m
//  MiaoShow
//
//  Created by huhang on 16/9/14.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "NSSafeObject.h"

@interface NSSafeObject ()
{
    __weak id _object;
    SEL _sel;
}
@end

@implementation NSSafeObject

- (instancetype)initWithObjct:(id)object{

    if (self = [super init]) {
        _object = object;
        _sel = nil;
    }
    return self;
}

- (instancetype)initWithObjct:(id)object withSelector:(SEL)selector{
    if (self = [super init]) {
        _object = object;
        _sel = selector;
    }
    return self;
}

- (void)excute{

    if (_object && _sel && [_object respondsToSelector:_sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_object performSelector:_sel withObject:nil];
#pragma clang diagnostic pop
    }
}

@end
