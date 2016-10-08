//
//  NSSafeObject.h
//  MiaoShow
//
//  Created by huhang on 16/9/14.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSafeObject : NSObject

/**
 *  调整字体
 */

- (instancetype)initWithObjct:(id)object;
- (instancetype)initWithObjct:(id)object withSelector:(SEL)selector;
- (void)excute;

@end
