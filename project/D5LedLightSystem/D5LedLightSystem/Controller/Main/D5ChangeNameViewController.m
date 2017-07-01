//
//  D5ChangeNameViewController.m
//  D5LedLightSystem
//
//  Created by LGZwr on 16/9/5.
//  Copyright © 2016年 PangDou. All rights reserved.
//

#import "D5ChangeNameViewController.h"
#import "NSObject+runtime.h"

@interface D5ChangeNameViewController () <D5LedNetWorkErrorDelegate, D5LedCmdDelegate> {
    Class _oldClass;
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UIView *sureView;

@end

@implementation D5ChangeNameViewController

- (void)setDelegate:(id<D5ChangeNameViewControllerDelegate>)delegate {
    _delegate = delegate;
    _oldClass = [self objectGetClass:_delegate];
}

#pragma mark - 检测代理是否存在
- (BOOL)checkDelegate {
    if (!_delegate) {
        return NO;
    }
    Class nowClass = [self objectGetClass:_delegate];
    return nowClass && (nowClass == _oldClass);
}

- (void)setName:(NSString *)name {
    _name = name;
}

#pragma mark - <MyDelegate>

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改名称";
    

    [self addLeftBarItem];

    [self addRightBarItem];
    
    [self.nameTextField becomeFirstResponder];
    
    self.nameTextField.text = self.name;
    
    [self.nameTextField addTarget:self action:@selector(limitLength:) forControlEvents:UIControlEventEditingChanged];
    [self.nameTextField endEditing:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
}


- (void)addLeftBarItem {
    [D5BarItem setLeftBarItemWithImage:BACK_IMAGE target:self action:@selector(hiddeSureView)];
}

- (void)addRightBarItem {
    [D5BarItem addRightBarItemWithText:@"保存" color:WHITE_COLOR target:self action:@selector(saveName)];
}

- (void)hiddeSureView {
    [self.view endEditing:YES];
    if ([self.nameTextField.text isEqualToString:@""]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.sureView.hidden = NO;
    }
}

- (IBAction)cleanNameBtnClick:(id)sender {
    self.nameTextField.text = @"";
}

- (void)saveName {
    if ([self.nameTextField.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入中控名称"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        return;
    }
    
    NSDictionary *dict = @{LED_STR_TYPE : @(LedBoxSettingTypeSetName),
                           LED_STR_NAME : self.nameTextField.text};
    
    D5LedNormalCmd *boxSetInfo = [[D5LedNormalCmd alloc] init];
    
    boxSetInfo.remoteLocalTag = tag_remote;
    boxSetInfo.remotePort = [D5CurrentBox currentBoxTCPPort];
    boxSetInfo.remoteIp = [D5CurrentBox currentBoxIP];
    boxSetInfo.strDestMac = [D5CurrentBox currentBoxMac];
    boxSetInfo.receiveDelegate = self;
    
    [boxSetInfo ledSendData:Cmd_Box_Operate withSubCmd:SubCmd_Box_Set_Info withData:dict];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)ledCmdReceivedData:(LedHeader *)header withData:(NSDictionary *)dict {
    @autoreleasepool {
        if (!dict) {
            return;
        }
        
        if (header->cmd == Cmd_Box_Operate && header->subCmd == SubCmd_Box_Set_Info) {
            NSDictionary *data = dict[LED_STR_DATA];
            if (!data) {
                return;
            }
            
            LedBoxSettingType type = [data[LED_STR_TYPE] intValue];
            if (type == LedBoxSettingTypeSetName) {
                if ([self checkDelegate] && [_delegate respondsToSelector:@selector(finishChangeName:)]) {
                    [_delegate finishChangeName:self.nameTextField.text];
                }
            }
        }
    }
}

- (IBAction)notSaveName:(id)sender {
    self.sureView.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)sureSaveName:(id)sender {
    self.sureView.hidden = YES;
    [self saveName];
}

//限制字数
- (void)limitLength:(UITextField *)sender {
    NSString *language = [[[UIApplication sharedApplication] textInputMode] primaryLanguage];
    NSRange zhRange = [language rangeOfString:@"zh"];
    BOOL isChinese = NO;
    if (zhRange.location != NSNotFound) { //中文键盘
        isChinese = YES;
    }
    
    NSInteger limitLen = 36;
    if (sender == self.nameTextField) {
        NSString *str = [[self.nameTextField text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        UITextRange *selectedRange = [self.nameTextField markedTextRange];
        UITextPosition *position = [self.nameTextField positionFromPosition:selectedRange.start offset:0]; //输入的英文还没有转化为汉字的状态
        
        //英文状态 或者 中文状态下而且输入的英文已经转为汉字了
        if (!isChinese || !position) {
            if (data.length >= limitLen) {
                //截取前24位的byte得出的字符串
                Byte bytes[limitLen];
                [data getBytes:&bytes length:limitLen];
                NSString *strNew = [[NSString alloc] initWithBytes:bytes length:limitLen encoding:NSUTF8StringEncoding];
                
                [self.nameTextField setText:strNew];
            }
        }
    }
}


@end
