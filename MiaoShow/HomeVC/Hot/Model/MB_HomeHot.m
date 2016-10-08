//
//  MB_HomeHot.m
//  MiaoShow
//
//  Created by huhang on 16/9/7.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeHot.h"

@implementation MB_HomeHot

- (UIImage *)startImage{

    if (self.starlevel) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"girl_star%@_40x19",self.starlevel]];
    }else{
       return nil;
    }
}

@end
