//
//  D5MusicCategoryPopView.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/7.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5MusicCategoryPopView.h"
#import "D5MusicLibraryData.h"

@interface D5MusicCategoryPopView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL _isSelcteRow;

}
@property(strong,nonatomic)NSArray*dataArray;
@property(strong,nonatomic)NSString*selectename;
@property(strong,nonatomic)UICollectionView*collectionView;
@property(strong,nonatomic)UIView*buttomView;
@property(strong,nonatomic)UITapGestureRecognizer*tapGesture;

@end

#define POPVIEWITEMWIDTH 55
@implementation D5MusicCategoryPopView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, MainScreenWidth, 0) collectionViewLayout:layout];
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removePopView)];
        [self addGestureRecognizer:_tapGesture];
       

        [self initView];

    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
//     float y = 105.0f + 64;
//    _collectionView.frame = CGRectMake(0, y, MainScreenWidth, MainScreenHeight);
////    [self initView];
    
}
-(void)removePopView
{
    [self hidenView:YES];
    if (_popViewHiden ) {
        _popViewHiden(YES);
    }
}

-(void)hidenView:(BOOL)isHiden
{
    dispatch_async(dispatch_get_main_queue(), ^{
      
        [self.collectionView setHidden:isHiden];
        [self.buttomView setHidden:isHiden];
        [self setHidden:isHiden];

    });
    
    
}

-(void)setDataList:(NSArray*)dataArrayList selctedCategory:(NSString*)name{
    _dataArray = dataArrayList;
    _selectename = name;
    [self updateCollectionViewFrame];
    [self updateCollectView];
    [self hidenView:NO];
   
}
-(void)updateCollectionViewFrame{

    float height = 0;
    height = (_dataArray.count >5 ) ? 60*2.0:60;
    float y = 105.0f + 64;
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        //动画效果
        [weakSelf.collectionView setFrame:CGRectMake(0, y, MainScreenWidth, 0)];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            [weakSelf.collectionView setFrame:CGRectMake(0, y, MainScreenWidth, height)];
            
        } completion:^(BOOL finished) {
        }];
    });

}
-(void)updateCollectView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
        
    });

}

-(void)initView
{
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    [_collectionView registerClass:[D5MusicCategoryPopViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[D5MusicCategoryPopViewFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Header"];
    [_collectionView setDelegate:self];
    [_collectionView setDataSource:self];

    [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
     [self addSubview:_collectionView];
}


#pragma mark --collectionView委托事件

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
      return _dataArray.count;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = {MainScreenWidth,1.0f};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    D5MusicCategoryPopViewFootView *footView = nil;
    
    if([kind isEqual:UICollectionElementKindSectionFooter])
    {
        footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"Header" forIndexPath:indexPath];

    }
  footView.backgroundColor = [UIColor clearColor];

    return footView;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    D5MusicCategoryPopViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath ];
   
    if (cell==nil) {
        
        cell=[[D5MusicCategoryPopViewCell alloc]initWithFrame:CGRectZero];
        
    }
    MusicModel*musicModel=_dataArray[indexPath.row];
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    cell.row=indexPath.row;
    //设置选中的分类颜色
    [cell.title setTitle:musicModel.musicName forState:UIControlStateNormal];
   //选中状态d的颜色
    if (musicModel.musicName==_selectename) {
        
        [cell.title setTitleColor:COLOR(170/255.0, 96/255.0, 255.0/255.0, 1.0) forState:UIControlStateNormal];
    }else{
 
        [cell.title setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    cell.touchCategory = ^(NSInteger row)
    {
        MusicModel*selectMusicModel=_dataArray[indexPath.row];
        _selectedMusicCategoryList(selectMusicModel.musicName,[NSString stringWithFormat:@"%ld",(long)selectMusicModel.musicID],_categoryID);
       
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView setHidden:YES];
            [self.buttomView setHidden:YES];
            [self setHidden:YES];
            
        });


    
    };
    
    
    return cell;

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //DLog(@"选择view");
   
}


 //布局大小

//实体大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(POPVIEWITEMWIDTH, 40);

}


-(CGFloat)getSpace
{
    return (MainScreenWidth-POPVIEWITEMWIDTH*5.0)/6.0;

}
//间边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return   UIEdgeInsetsMake(10.0f, [self getSpace], 0.0f, [self getSpace]);
}

//竖向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return [self getSpace];
}



@end

@implementation D5MusicCategoryPopViewCell

-(id)initWithFrame:(CGRect)frame
{
   self= [super initWithFrame:frame];
   
    if (self) {
       
        _title=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_title.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_title setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
       
        [_title addTarget:self action:@selector(touchMusicCategory:) forControlEvents:UIControlEventTouchUpInside];
         [self setBackgroundColor:[UIColor whiteColor]];
//        [_title setText:@"粤语"];
        
        
        [self addSubview:_title];
        
    }
    
    return self;

}


-(void)touchMusicCategory:(UIButton*)btn
{
    dispatch_async(dispatch_get_main_queue(), ^{
     
        [btn setSelected:!btn.selected];
        
    });
    
    _touchCategory(self.row);

}
@end


@implementation D5MusicCategoryPopViewFootView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

@end
