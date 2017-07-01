//
//  D5SearchViewController.m
//  D5LedLightSystem
//
//  Created by PangDou on 16/7/12.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SearchViewController.h"
#import "D5SearchTagCell.h"
#import "D5SearchTagData.h"
#import "UIColor+Image.h"
#import "D5HUploadLocalMusic.h"
#import "D5MusicLibraryData.h"
#import "D5SearchMusicModel.h"
#import "D5SearchKeyWorldsController.h"

#define HEADER_HEIGHT 26

@interface D5SearchViewController() <UITableViewDelegate, UITableViewDataSource, D5FlowButtonViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopMargin;
@property (weak, nonatomic) IBOutlet UITableView *searchTagTableView;

- (IBAction)btnCancelClicked:(UIButton *)sender;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray *tagDatas;

@property(nonatomic,strong)NSMutableArray*classifyArray;
@property(nonatomic,strong)NSMutableArray*hotMusicArray;
@property(nonatomic,strong)NSMutableArray*languageArray;
@property(nonatomic,strong)NSMutableArray*hotArray;


@end

@implementation D5SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hotMusicArray=[NSMutableArray array];
//    _hotSingerArray=[NSMutableArray array];
    _datas=[NSMutableArray array];
     _tagDatas=[NSMutableArray array];
    [self getHotSearch];
    [self getClassifyMusicList];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self animationWithSearchView];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



#pragma mark - 初始化
- (void)initView {
    [self initSearchView];
}

/**
 *  初始化searchview
 */
- (void)initSearchView {
    [D5Round setSmallRound:_searchView];
    _searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Search" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.3f]}];
    _searchTF.clearButtonMode = UITextFieldViewModeAlways;
}

/**
 *  searchview的入场动画--从上往下
 */
- (void)animationWithSearchView {
    _searchView.alpha = 0;
    [_searchView setNeedsLayout];
    [UIView animateWithDuration:0.25f animations:^{
        _searchView.alpha = 1;
        _searchViewTopMargin.constant = 20;
        [_searchView layoutIfNeeded];
    }];
}

#pragma mark - 初始化数据
//- (NSMutableArray *)datas {
////    if (!_datas) {
////        _datas = [NSMutableArray arrayWithObjects:
////                  @{HEADER_KEY : @"热门搜索", TAGS_KEY : @[@"突然好想你", @"漂洋过海来看你", @"做我老婆好不好", @"金志文", @"徐佳莹", @"BigBang", @"黄致列", @"纯音乐", @"中国好声音", @"Fantasy Plus"]},
////                  @{HEADER_KEY : @"选择分类"},
////                  @{HEADER_KEY : @"语言", TAGS_KEY : @[@"中文", @"粤语", @"英文", @"日韩", @"其他"]},
////                  @{HEADER_KEY : @"主题", TAGS_KEY : @[@"热门", @"流行", @"网络", @"DJ", @"影视", @"纯音乐", @"儿歌", @"神曲"]}, nil];
////    }
////    return _datas;
//}

//- (NSMutableArray *)tagDatas {
//    if (!_tagDatas) {
//        _tagDatas = [NSMutableArray array];
//        
//        [self.view layoutIfNeeded];
//        CGFloat width = CGRectGetWidth(self.searchTagTableView.frame);
//        
//        for (NSMutableDictionary *dict in self.datas) {
//            D5SearchTagData *data = [D5SearchTagData dataWithDict:dict];
//            [data setData:data viewWidth:width];
//            [_tagDatas addObject:data];
//        }
//        
//    }
//    return _tagDatas;
//}

#pragma mark --私有方法
-(void)getHotSearch
{

     _hotArray=[NSMutableArray array];
  
    [D5SearchMusicModel getHotMusic:^(id response) {
       
        for (MusicModel*model in response) {
            [_hotArray addObject:model.musicName];
        }
        if (_hotArray==nil) {
            
            return ;
        }
        [_datas addObject:@{HEADER_KEY : @"热门搜索", TAGS_KEY :_hotArray}];
        
        [self updateMusicData];
        
        
    } fail:^(NSError *error) {
        
    }];
}

-(void)getClassifyMusicList
{
    _classifyArray=[NSMutableArray array];
    _languageArray=[NSMutableArray array];
    [_datas addObject: @{HEADER_KEY : @"选择分类"}];
    [D5SearchMusicModel getClassifyMusic:^(id response) {
   
        NSArray*class=[response valueForKey:@"主题"];
        for (MusicModel*model in class) {
            [_classifyArray addObject:model.musicName];
        }
        NSArray*language=[response valueForKey:@"语言"];

        for (MusicModel*model in language) {
            [_languageArray addObject:model.musicName];
        }
        
        [_datas addObject:@{HEADER_KEY : @"语言", TAGS_KEY :_languageArray}];
        [_datas addObject:@{HEADER_KEY : @"主题", TAGS_KEY :_classifyArray}];
        [self updateMusicData];

    } fail:^(NSError *error) {
       
        
    }];
    

}

-(void)updateMusicData
{
    CGFloat width = CGRectGetWidth(self.searchTagTableView.frame);
   
    
     [self.view layoutIfNeeded];
    _tagDatas=[NSMutableArray array];
    NSMutableArray*sort=[_datas copy];
    if(_datas.count==4)
    {
        for (NSDictionary*dic in sort) {
            if([[dic valueForKey:HEADER_KEY]isEqualToString:@"热门搜索"])
            {
                [_datas removeObject:dic];
            
            }
        }
        [_datas insertObject: @{HEADER_KEY : @"热门搜索", TAGS_KEY :_hotArray} atIndex:0];
    }
    
    for (NSMutableDictionary *dict in self.datas) {
        D5SearchTagData *data = [D5SearchTagData dataWithDict:dict];
        [data setData:data viewWidth:width];
        [_tagDatas addObject:data];
    }
    
    [_searchTagTableView reloadData];

    

}


#pragma mark - btn点击事件
- (IBAction)btnCancelClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

/**
 *  热门中的按钮的点击事件
 *
 *  @param button 热门中的按钮
 */
- (void)flowButtonClicked:(UIButton *)button {
    _searchTF.text = button.currentTitle;
    D5SearchKeyWorldsController*vc=  [self.storyboard instantiateViewControllerWithIdentifier:D5_SEARCHKEYWORLDS_CONTROLLER];
//    [self presentViewController:vc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:NO];
    
    //待改 开始搜索
}

#pragma mark - tableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tagDatas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    @autoreleasepool {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), HEADER_HEIGHT);
        
        UILabel *header = [[UILabel alloc] initWithFrame:frame];
        header.textAlignment = NSTextAlignmentLeft;
        
        D5SearchTagData *data = [self.tagDatas objectAtIndex:section];
        
        NSString*headerTitle;
        if(section==0)
        {
           headerTitle =@"热门搜索";
        }else if (section==1)
        {
           headerTitle =@"选择分类";
            
        }else if (section==2)
        {
          headerTitle =@"语言";
            
        }else{
            
           headerTitle =@"主题";
        }
        
        
        header.text = data.headerTitle;
        header.font = [UIFont systemFontOfSize:12];
        header.textColor = [UIColor whiteColor];
        
        if (section > 1) {
            UIView *view = [[UIView alloc] initWithFrame:frame];
            view.backgroundColor = [UIColor clearColor];
            
            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
            [D5Round setRoundForView:circleView borderColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4f]];
            
            circleView.center = CGPointMake(CGRectGetWidth(circleView.frame) / 2, CGRectGetMidY(frame));
            
            if (section == 2) {
                circleView.backgroundColor = [UIColor colorWithRed:0.612 green:0.259 blue:1.000 alpha:1.000];
            } else if (section == 3) {
                circleView.backgroundColor = [UIColor yellowColor];
            } else {
                circleView.backgroundColor = [UIColor colorWithRed:0.941 green:0.051 blue:0.482 alpha:1.000];
            }
            [view addSubview:circleView];
            
            CGRect headerFrame = header.frame;
            headerFrame.origin.x = CGRectGetMaxX(circleView.frame) + 8;
            header.frame = headerFrame;
            
            [view addSubview:header];
            
            return view;
        } else {
            return header;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5SearchTagCell *cell = [tableView dequeueReusableCellWithIdentifier:SEARCH_TAG_CELL_ID];
        if (!cell) {
            cell = [[D5SearchTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SEARCH_TAG_CELL_ID];
        }
        
        D5SearchTagData *data = [self.tagDatas objectAtIndex:indexPath.section];
        [cell setData:data withDelegate:self];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @autoreleasepool {
        D5SearchTagData *data = [self.tagDatas objectAtIndex:indexPath.section];
        return data.height;
    }
}

/**
 *  解决tableView的header一直停留在顶部的问题
 *
 *  @param scrollView tableview
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.searchTagTableView) {
        
        CGFloat sectionHeaderHeight = HEADER_HEIGHT; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
@end
