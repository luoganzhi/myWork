//
//  D5SuggestiViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5SuggestiViewController.h"
#import "LGZPlaceholderTextView.h"
#import "D5Protocol.h"
#import "sys/utsname.h"


@interface D5SuggestiViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet LGZPlaceholderTextView *suggestTextView;
@property (weak, nonatomic) IBOutlet UIView *upgradeView;

@end

@implementation D5SuggestiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    [self addLeftBtn];
    [self addRightBtn];
    
    [self setTextView];
    
    [self changeRightBarItemEnabled:NO];
    

}

- (void)addLeftBtn
{
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(popVC)];

}

- (void)addRightBtn
{
    [D5BarItem addRightBarItemWithText:@"发送" color:WHITE_COLOR target:self action:@selector(suggestInfo)];

}

- (void)setTextView
{
    self.suggestTextView.placeholder = @"有什么意见、吐槽都发送给我们吧";
    self.suggestTextView.placeholderColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:199/255.0 alpha:1];
    self.suggestTextView.layer.borderColor = UIColor.yellowColor.CGColor;
    self.suggestTextView.layer.borderWidth = 1;
    self.suggestTextView.layer.cornerRadius = 4;
    self.suggestTextView.layer.masksToBounds = YES;
    
    self.suggestTextView.delegate = self;

}

- (void)popVC
{
    [self.view endEditing:YES];
    if (![self.suggestTextView.text isEqualToString:@""]) {
        self.upgradeView.hidden = NO;
    } else {
        self.upgradeView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}


- (void)suggestInfo {
    [self.view endEditing:YES];
    D5Protocol *d5 = [[D5Protocol alloc] init];

    [d5 setFinishBlock:^(NSDictionary *response){
        

    }];
    
    [d5 setFaildBlock:^(NSString *errorStr) {
        //DLog(@"errorStr = %@", errorStr);
    }];
    
    [d5 sendSuggestion:self.suggestTextView.text version:[self appVersion] phoneModel:[self phoneVersion]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showMessage:@"感谢您提的意见！"];
        [self.navigationController popViewControllerAnimated:YES];
    });

}

- (IBAction)notSuggestBtnClick:(id)sender {
    self.upgradeView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)suggestBtnClick:(id)sender {
    self.upgradeView.hidden = YES;
    [self suggestInfo];
    
}


- (NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
- (NSString *)phoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}

#pragma mark - <UITextViewDelegate>
-(void)textViewDidChange:(UITextView *)textView
{
    [self changeRightBarItemEnabled:![textView.text isEqualToString:@""]];

    //DLog(@"textViewDidChange = %@",textView.text);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    NSData *viewText = [textView.text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *replaceText = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    
    // 如果是删除 就允许输入
    if (replaceText.length == 0) {
        return  YES;

    }
    
    // 判断是否超过输入限制
    if (viewText.length + replaceText.length > 400) {
        return NO;
    }  else {
        return  YES;
    }

    return YES;
}

@end
