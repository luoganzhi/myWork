//
//  D5TanslateMusic.m
//  D5LedLightSystem
//
//  Created by 黄金 on 16/9/6.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5TanslateMusic.h"
#import "D5PCTanslateSongs.h"
#import "D5MoubileTanslateSongsController.h"
#import "D5SheetController.h"

@implementation D5TanslateMusic

+(void)showTanslateMusicSheet :(UIViewController*)vc
{
    
    UIStoryboard*boad=[UIStoryboard storyboardWithName:MUSICLIBRARY_STORYBOARD_ID bundle:nil];
    D5PCTanslateSongs*pc=[boad instantiateViewControllerWithIdentifier:PCTanslateSongsVC];
    D5MoubileTanslateSongsController*mobile=[boad instantiateViewControllerWithIdentifier:MoubileTanslateSongsVC];
    
    
    
    D5SheetController*sheet=[boad instantiateViewControllerWithIdentifier:SheetControllerVC];
    sheet.view.frame=CGRectMake(0, 0, MainScreenWidth, MainScreenHeight);
    sheet.mobileTranslate=^(void)
    {
       [vc.navigationController pushViewController:mobile animated:YES];
    
    };
    sheet.pcTranslate=^(void)
    {
      [vc.navigationController pushViewController:pc animated:YES];
    };
    [vc addChildViewController:sheet];
    [sheet.view setUserInteractionEnabled:YES];
    sheet.topview.backgroundColor=[UIColor blackColor];
    [sheet.topview setAlpha:0.5];
    [vc.view addSubview:sheet.view];
    
}
@end
