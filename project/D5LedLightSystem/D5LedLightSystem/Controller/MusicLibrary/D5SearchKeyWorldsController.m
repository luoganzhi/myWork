//
//  D5SearchKeyWorldsController.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/2.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SearchKeyWorldsController.h"
#import "D5SearchKeyworldsCell.h"
#import "D5MusicLibraryData.h"
#define CELL_HEIGHT 40.0f
typedef enum _MusicShowType {
    Music_Show_Songs=1,
     Music_Show_
    
}MusicShowType;
@interface D5SearchKeyWorldsController()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isAllSelected;

}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *selectedAll;

@end
@implementation D5SearchKeyWorldsController


//全选所有歌曲
- (IBAction)selelctedAll:(id)sender {
    
    [_selectedAll setSelected:!_selectedAll.isSelected];
    isAllSelected=!isAllSelected;
    [_tableview reloadData];
    
}

- (IBAction)cancelEvents:(id)sender {
    

    [self.navigationController popViewControllerAnimated:NO];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    isAllSelected=NO;
    
    _tableview.tableFooterView=[[UIView alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CELL_HEIGHT*MainScreenHeight/480.0f;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    D5SearchKeyworldsCell*cell=[tableView dequeueReusableCellWithIdentifier:SearchKeyworldIndentifer];
    
    if (cell==nil) {
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell.selectSong setHidden:YES];
    D5MusicLibraryData*data;
    [cell setData:data editStatus:(isAllSelected)? MusicStatusSelected:MusicStatusUnSelected];
    return cell;
    

}
@end
