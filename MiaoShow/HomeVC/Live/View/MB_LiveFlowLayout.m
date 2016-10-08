//
//  MB_LiveFlowLayout.m
//  MiaoShow
//
//  Created by huhang on 16/9/11.
//  Copyright © 2016年 huhang. All rights reserved.
//

#import "MB_LiveFlowLayout.h"

@implementation MB_LiveFlowLayout

- (void)prepareLayout{
    [super prepareLayout];
    
    self.itemSize = self.collectionView.bounds.size;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

@end
