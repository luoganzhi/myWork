//
//  D5ConfigViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/8.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ConfigViewController.h"
#import "D5ConfigCell.h"
#import "D5MusicModel.h"
#import "D5PlayMusicViewController.h"
#import "D5EffectsModel.h"
#import "D5BaseListModel.h"

@interface D5ConfigViewController () <UITableViewDataSource, UITableViewDelegate, D5LedNetWorkErrorDelegate, D5LedCmdDelegate>

@property (weak, nonatomic) IBOutlet UITableView *configTableView;
@property (weak, nonatomic) IBOutlet UIView *configView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;


@end

@implementation D5ConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

}

- (void)setMusicModel:(D5BaseListModel *)musicModel
{
    _musicModel = musicModel;
    
    if (musicModel.effectsList && musicModel.effectsList.count <=3){
        self.height.constant = 54 + musicModel.effectsList.count * 48;
    } else if (musicModel.effectsList.count > 3) {
        self.height.constant = 54 + 3 * 48;
    }
    
    
}

#pragma mark - <歌曲返回delegate>
- (void)d5NetWorkError:(D5SocketErrorCodeType)errorType errorMessage:(NSString *)errorMesssage data:(NSDictionary *)data forHeader:(LedHeader *)header {
    @autoreleasepool {
        if (errorType == D5SocketErrorCodeTypeTimeOut) {

        }
        
    }
    
}
- (void)ledMusicPlayReturn:(int64_t)result
{
    //DLog(@"%zd", result);
    if (result < 0){
        DLog(@"播放配置失败");
        if (result == -10015) {
            [MBProgressHUD showMessage:@"歌曲已被删除，请刷新"];
        }

    }else {
        DLog(@"播放配置成功");
    }
    
}


#pragma mark - <tableviewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.musicModel.effectsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    D5ConfigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LGZConfigCell"];
    
    if (self.musicModel.effectsList || self.musicModel.effectsList.count > 0 ) {
    
        [cell setCellWithMusicModel:self.musicModel Index:indexPath];
    }

    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view removeFromSuperview];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 播放操作
    D5EffectsModel *effect = self.musicModel.effectsList[indexPath.row];
    NSDictionary *dict = @{
                           LED_STR_MUSICID : @(self.musicModel.music.musicID),
                           LED_STR_EFFECTID : @(effect.effectID)
                           };
    
    D5LedNormalCmd *musicPlay = [[D5LedNormalCmd alloc] init];
    
    musicPlay.remotePort = [D5CurrentBox currentBoxTCPPort];
    musicPlay.strDestMac =  [D5CurrentBox currentBoxMac];
    musicPlay.remoteLocalTag = tag_remote;
    musicPlay.remoteIp = [D5CurrentBox currentBoxIP];
    musicPlay.errorDelegate = self;
    musicPlay.receiveDelegate = self;
    
    DLog(@"播放音乐 %@", self.musicModel.music.name);
    [musicPlay ledSendData:Cmd_Media_Operate withSubCmd:SubCmd_Music_Play withData:dict];
    
    if (self.playConfigBlock) {
        self.playConfigBlock();
    }
    
    [self.view removeFromSuperview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

@end
