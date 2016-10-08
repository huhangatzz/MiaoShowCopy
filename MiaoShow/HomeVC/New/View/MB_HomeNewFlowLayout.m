//
//  MB_HomeNewFlowLayout.m
//  MiaoShow
//
//  Created by huhang on 16/9/9.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_HomeNewFlowLayout.h"

@implementation MB_HomeNewFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    CGFloat wh = (SCREEN_WIDTH - 3) / 3.0;
    self.itemSize = CGSizeMake(wh, wh);
    //行间距
    self.minimumLineSpacing = 1;
    //列间距
    self.minimumInteritemSpacing = 1;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = YES;
    self.collectionView.alwaysBounceVertical = YES;
}


@end
