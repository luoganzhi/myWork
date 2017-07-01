//
//  D5SearchSongsViewController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SearchSongsViewController.h"
#import "D5MusicCategoryPopView.h"
#import "D5SearchMusicModel.h"
#import "D5MusicLibraryData.h"
@interface D5SearchSongsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property(strong,nonatomic)NSArray*hotMusicDataArray;


@end

@implementation D5SearchSongsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [_collectionView registerClass:[D5MusicCategoryPopViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[D5MusicCategoryPopViewFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Header"];

    [self getHotMusicData];

}

-(void)getHotMusicData
{
    [D5SearchMusicModel getHotMusic:^(id response) {
        
        _hotMusicDataArray=response;
        
       dispatch_async(dispatch_get_main_queue(), ^{
           
           [_collectionView reloadData];
           
       });
        
    } fail:^(NSError *error) {
     
        
    }];


}

-(CGFloat)getItemWidth:(NSInteger)row
{
    MusicModel*model=_hotMusicDataArray[row];
    NSString*titile=model.musicName;

    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:[UIFont systemFontOfSize:18] forKey:NSFontAttributeName];
    CGSize size = [titile boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.width;
   
}

#pragma mark --collectionView委托事件

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotMusicDataArray.count;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = {MainScreenWidth,1.0f};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    D5MusicCategoryPopViewFootView *footView=nil;
    
    if([kind isEqual:UICollectionElementKindSectionFooter])
    {
        footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
    }
    footView.backgroundColor=[UIColor clearColor];
    
    return footView;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    D5MusicCategoryPopViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath ];
    
    if (cell==nil) {
        
        cell=[[D5MusicCategoryPopViewCell alloc]initWithFrame:CGRectZero];
        
    }
     MusicModel*model=_hotMusicDataArray[indexPath.row];
    [cell.title setTitle:model.musicName forState:UIControlStateNormal];
//    MusicModel*musicModel=_dataArray[indexPath.row];
//    [cell setBackgroundColor:[UIColor whiteColor]];
//    cell.row=indexPath.row;
//    [cell.title setTitle:musicModel.musicName forState:UIControlStateNormal];
//    cell.touchCategory=^(NSInteger row)
//    {
//        MusicModel*selectMusicModel=_dataArray[indexPath.row];
//        _selectedMusicCategoryList(selectMusicModel.musicName,[NSString stringWithFormat:@"%ld",selectMusicModel.musicID]);
//        [self removeView];
//        
//        
//    };
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择view");
    
}



//实体大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([self getItemWidth:indexPath.row], 40);
    
}


-(CGFloat)getSpace
{
    return 20.0f;
//    return (MainScreenWidth-40*5.0)/6.0;
    
}
//间边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return   UIEdgeInsetsMake(10.0f, [self getSpace], 0.0f, [self getSpace]*2);
}

//竖向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
//横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return [self getSpace]/2.0;
}


@end
