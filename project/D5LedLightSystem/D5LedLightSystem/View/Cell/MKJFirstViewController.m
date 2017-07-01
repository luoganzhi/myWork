//
//  MKJFirstViewController.m
//  TagListLayoutDemo
//
//  Created by 宓珂璟 on 16/6/20.
//  Copyright © 2016年 宓珂璟. All rights reserved.
//

#import "MKJFirstViewController.h"
#import "UIImage+ImageCompress.h"
#import "SKTagView.h"
#import "D5SearchMusicModel.h"
#import "D5MusicLibraryData.h"
#import "D5SearchSongsResultController.h"
#import "D5HJMusicDownloadListManageController.h"
@interface MKJFirstViewController () <UISearchBarDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UISearchBar * searchBar;//搜索的SearchBar
@property (nonatomic,strong) SKTagView * tagSongsView;//歌手标签
@property (nonatomic,strong) SKTagView * tagSingerView;//歌曲标签

@property (nonatomic,strong) NSMutableArray * singerArray;//歌手数据列表
@property(nonatomic,strong)NSMutableArray* songsArray;//歌曲数据列表
@property (nonatomic,strong) UILabel* hotTitleTag;//热门标签


@property (nonatomic,strong) UITextField *textfiled;//输入框
@property (nonatomic,strong)D5SearchSongsResultController* searchSongResultVC;//搜索结果VC
@property(nonatomic,strong)UIView* titleView;//搜索框背景view
@property(nonatomic,strong)UIImageView* searchImage;//搜索框图片
@property (nonatomic, strong)D5HJMusicDownloadListManageController *downLoadMusicVC;

@end

@implementation MKJFirstViewController

#pragma  mark --属性方法

-(UIView*)titleView
{
    if (_titleView == nil) {
        
      _titleView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, MainScreenWidth-60, 36)];
    }
    _titleView.backgroundColor = [UIColor colorWithHex:0x0d0d0d alpha:1.0];
    
    return _titleView;

}
//搜索图标
-(UIImageView*)searchImage
{
    if (_searchImage == nil) {
        
        _searchImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 9.0, 18, 18)];
        
    }
     [_searchImage setImage:IMAGE(@"music_icon_search")];
    
    return _searchImage;

}
//
-(UITextField*)textfiled
{
    if (_textfiled == nil) {
        
       _textfiled = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, MainScreenWidth-100, 36)];
    }
    //设置搜索框属性
    [_textfiled setPlaceholder:@"搜索歌曲"];
    [_textfiled setValue:[UIColor colorWithHex:0x666666 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [_textfiled setTextColor:WHITE_COLOR];
    [_textfiled setFont:[UIFont systemFontOfSize:14.0f]];
    _textfiled.returnKeyType = UIReturnKeyDefault;
    _textfiled.enablesReturnKeyAutomatically = YES;
    [_textfiled becomeFirstResponder];
    [_textfiled setDelegate:self];
    //监听搜索内容输入情况
    [_textfiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    return _textfiled;
    

}
-(D5SearchSongsResultController*)searchSongResultVC
{
    if(_searchSongResultVC == nil)
    {
        _searchSongResultVC = [STORYBOAD_MUSICLIBRARY instantiateViewControllerWithIdentifier:SearchSongsResultVC];
        _searchSongResultVC.view.frame = self.view.bounds;//CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
        [_searchSongResultVC.searchNullDataView setHidden:YES];
        
    }
   
    return _searchSongResultVC;
}
-(D5HJMusicDownloadListManageController*)downLoadMusicVC
{
    if (!_downLoadMusicVC) {
        
    _downLoadMusicVC = [[UIStoryboard storyboardWithName:MUSICLIBRARY_STORYBOARD_ID bundle:nil]instantiateViewControllerWithIdentifier:@"D5HJMusicDownloadListManageController"];
        }
    return _downLoadMusicVC;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self getHotMusicData];//获取数据
    [self initView];
    // Do any additional setup after loading the view from its nib.
   

  

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   

}

//初始化View
-(void)initView
{
    [D5BarItem addRightBarItemWithImage:IMAGE(@"music_search_clear") target:self action:@selector(cacel)];
    [self.titleView addSubview:self.searchImage];
    [self.titleView addSubview:self.textfiled];
    self.navigationItem.titleView = self.titleView;
    
    self.singerArray = [NSMutableArray array];
    self.songsArray = [NSMutableArray array];
    
    [self.view setBackgroundColor:MUSIC_CELL_BLACk];

}
//获取热门数据
-(void)getHotMusicData
{
    [D5SearchMusicModel getHotMusic:^(id response) {
        
        NSDictionary*dic = response;
        
        _singerArray = dic[@"singer"];
        _songsArray = dic[@"songs"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //配置tagView
           [self configTagView];
            
        });
        
    } fail:^(NSError *error) {
        
        
    }];
    
    
}

// 配置
- (void)configTagView
{
    //热门搜索Label
    if (self.hotTitleTag == nil) {
       self.hotTitleTag = [[UILabel alloc] initWithFrame:CGRectMake(10, 90-64, 100, 30)];
    }
    self.hotTitleTag.textColor = [UIColor whiteColor];
    self.hotTitleTag.font = [UIFont systemFontOfSize:16];
    self.hotTitleTag.text = @"热门搜索";
    [self.view addSubview:self.hotTitleTag];
    
    //歌曲标签数据
    [self.tagSongsView removeAllTags];
    self.tagSongsView = [[SKTagView alloc] init];
    // 整个tagView对应其SuperView的上左下右距离
    self.tagSongsView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    // 上下行之间的距离
    self.tagSongsView.lineSpacing = 10;
    // item之间的距离
    self.tagSongsView.interitemSpacing = 20;
    // 最大宽度
    self.tagSongsView.preferredMaxLayoutWidth = MainScreenWidth;
    //固定高度
    self.tagSongsView.regularHeight = 30;

    // 开始加载推荐的歌曲数据
    [self.songsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       // 初始化标签
        MusicModel*musicModel = self.songsArray[idx];
        SKTag *tag = [[SKTag alloc] initWithText:musicModel.musicName];
        // 标签相对于自己容器的上左下右的距离
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        // 弧度
        tag.cornerRadius = 10.0f;
        // 字体
        tag.font = [UIFont boldSystemFontOfSize:14];
        // 边框宽度
        tag.borderWidth = 1;
        // 背景
        tag.bgColor =[UIColor clearColor];
        // 边框颜色
        tag.borderColor = [UIColor colorWithHex:0x5E3B85 alpha:1.0];
        // 字体颜色
        tag.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        // 是否可点击
        tag.enable = YES;
        // 加入到tagView
        [self.tagSongsView addTag:tag];
    }];
    
    //歌手标签数据
    [self.tagSingerView removeAllTags];
     self.tagSingerView = [[SKTagView alloc] init];
    // 整个tagView对应其SuperView的上左下右距离
    self.tagSingerView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    // 上下行之间的距离
    self.tagSingerView.lineSpacing = 10;
    // item之间的距离
    self.tagSingerView.interitemSpacing = 20;
    // 最大宽度
    self.tagSingerView.preferredMaxLayoutWidth = MainScreenWidth;
    self.tagSingerView.regularHeight=30;
    
    // 赋值歌手标签数据
    for (MusicModel* musicModel in self.singerArray) {
       
        SKTag * tag  = [[SKTag alloc] initWithText:musicModel.musicName];
        // 标签相对于自己容器的上左下右的距离
        tag.padding = UIEdgeInsetsMake(3, 15, 3, 15);
        // 弧度
        tag.cornerRadius = 10.0f;
        // 字体
        tag.font = [UIFont boldSystemFontOfSize:14];
        // 边框宽度
        tag.borderWidth = 1.0;
        // 背景
        tag.bgColor = [UIColor clearColor];
        // 边框颜色
        tag.borderColor = [UIColor colorWithHex:0xffd400 alpha:1.0];
        // 字体颜色
        tag.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
        // 是否可点击
        tag.enable = YES;
        // 加入到tagView
        
        
        [self.tagSingerView addTag:tag];
    }
    
//    [self.singerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        // 初始化标签
//        MusicModel*musicModel=self.songsArray[idx];
//        
//    }];
//
    
    __weak __typeof(self)weakSelf=self;
    //点击歌曲标签
    self.tagSongsView.didTapTagAtIndex = ^(NSUInteger idx){
        
        MusicModel*music = weakSelf.songsArray[idx];
        weakSelf.textfiled.text = music.musicName;
        [weakSelf pushResultVc:music.musicName];
        
    };
    //点击歌手标签数据
    self.tagSingerView.didTapTagAtIndex = ^(NSUInteger idx){
        
        MusicModel* music = weakSelf.singerArray[idx];
        weakSelf.textfiled.text = music.musicName;
        [weakSelf pushResultVc:music.musicName];
        
    };

    
    // 获取刚才加入所有tag之后的内在高度
    CGFloat tagHeight = self.tagSongsView.intrinsicContentSize.height;
    //DLog(@"高度%lf",tagHeight);
    tagHeight = self.tagSongsView.regularHeight * 2 + 23;
    //歌曲标签frame
     self.tagSongsView.frame = CGRectMake(0, 120 - 64, MainScreenWidth, tagHeight);
    [self.tagSongsView layoutSubviews];
    [self.view addSubview:self.tagSongsView];
    //歌手标签frame
    self.tagSingerView.frame = CGRectMake(0, 120 + tagHeight - 64, MainScreenWidth, tagHeight);
    [self.tagSingerView layoutSubviews];
    [self.view addSubview:self.tagSingerView];

}

//是否显示结果
-(BOOL)isCatainResultTableList;
{
   return  [self.view.subviews containsObject:_searchSongResultVC.view];

}

//点击取消按钮
-(void)cacel
{
    [self.textfiled resignFirstResponder];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
  

}

#pragma  mark --TextFiled 委托方法

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    return YES;
}
//清楚按钮
-(BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (textField.text.length == 0) {
        // 没有文字了
        self.hotTitleTag.hidden = NO;
        self.tagSingerView.hidden = NO;
        self.tagSongsView.hidden = NO;
        
        if ([self isCatainResultTableList]) {
            
            [_searchSongResultVC removeFromParentViewController];
            [_searchSongResultVC.view removeFromSuperview];
        }
    }

    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidChange :(UITextField *)textField
{
    [self checkScanTextData:textField.text];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    return YES;
}

//检测输入的数据
-(void)checkScanTextData:(NSString*)text{

    if (text.length == 0) {
        // 没有文字了
        self.hotTitleTag.hidden = NO;
        self.tagSingerView.hidden = NO;
        self.tagSongsView.hidden = NO;
        if ([self isCatainResultTableList]) {
            [_searchSongResultVC removeFromParentViewController];
            [_searchSongResultVC.view removeFromSuperview];
        }
    }
    else
    {
        self.hotTitleTag.hidden   = YES;
        self.tagSongsView.hidden  = YES;
        self.tagSingerView.hidden = YES;
        [self pushResultVc:text];
    }

}


//显示搜索到的数据
-(void)pushResultVc:(NSString*)keyWorlds {
   
    if(keyWorlds.length <= 0) {
      
        return;
    }
    //有效字符串
    NSString*tempString = [keyWorlds stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([tempString length] == 0){
    //输入空格提示
        [iToast showButtomTitile:@"请输入歌名或歌手"];
        return;
    }
    [self.hotTitleTag setHidden:YES];
    if ([self.searchSongResultVC.searchKeyWorlds isEqualToString:keyWorlds]) {
        return;
    }
    //开始搜索数据
    [self.searchSongResultVC startsearch:keyWorlds];
    
    if (![self isCatainResultTableList]) {
    
        [self addChildViewController: self.searchSongResultVC];
        [self.view addSubview:self.searchSongResultVC.view];
    }
}
//用户操作
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textfiled resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
