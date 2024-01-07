//
//  MainViewController.m
//  ccp_ios
//
//  Created by 罗路雅 on 2024/1/7.
//

#import "MainViewController.h"
#import "BabyBluetooth.h"
#import "SDAutoLayout.h"
#import "MBProgressHUD.h"

@interface MainViewController ()
@property (nonatomic,retain) UILabel *label0;  //提示功能状态
@property (nonatomic,retain) UILabel *label1;  //开机提示
@property (nonatomic,retain) UILabel *label2;  //开机提示
@property (nonatomic,retain) UILabel *label3;  //提示温度
@property (nonatomic,retain) UIButton *btpower;
@property (nonatomic,retain) UIButton *bttemp;
@property (nonatomic,retain) UIButton *btbattery;
@property (nonatomic,retain) UIButton *btturbo;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAutoLayout];
    // Do any additional setup after loading the view.
    
    [self.label1 setHidden:YES];
    [self.label2 setHidden:YES];
    
    
}

-(void)setAutoLayout{
    
    //double frameWidth = 272;
    //double frameHeight = 564;
    double viewX = [UIScreen mainScreen].bounds.size.width;
    double viewY = [UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:[UIColor colorWithRed:42.0/255 green:70.0/255 blue:90.0/255 alpha:1.0]];
    
    //导航栏
    UIView *viewTop = [UIView new];
    [self.view addSubview:viewTop];
    [viewTop setBackgroundColor:[UIColor colorWithRed:200.0/255 green:101.0/255 blue:69.0/255 alpha:1.0]];
    viewTop.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightRatioToView(self.view, 0.1);
    
    //顶部文字0
    self.label0 = [UILabel new];
    [self.view addSubview:self.label0];
    [self.label0 setTextColor:[UIColor whiteColor]];
    [self.label0 setTextAlignment:NSTextAlignmentCenter];
    [self.label0 sizeToFit];
    [self.label0 setText:@"Current Temperature"];
    self.label0.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.177)
    .widthIs(viewX*0.618)
    .heightIs(viewY*0.142);
    [self.label0 setAdjustsFontSizeToFitWidth:YES];
    
    //中间提示文字1
    self.label1 = [UILabel new];
    [self.view addSubview:self.label1];
    [self.label1 setTextColor:[UIColor whiteColor]];
    [self.label1 setTextAlignment:NSTextAlignmentCenter];
    [self.label1 setNumberOfLines:4];
    [self.label1 sizeToFit];
    [self.label1 setText:@"You TREKOOL is\nconnected to Bluetooth."];
    self.label1.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.38)
    .widthIs(viewX*0.618)
    .heightIs(viewY*0.142);
    [self.label1 setAdjustsFontSizeToFitWidth:YES];
    
    //下面提示文字2
    self.label2 = [UILabel new];
    [self.view addSubview:self.label2];
    [self.label2 setTextColor:[UIColor whiteColor]];
    [self.label2 setTextAlignment:NSTextAlignmentCenter];
    [self.label2 setNumberOfLines:3];
    [self.label2 sizeToFit];
    [self.label2 setText:@"You can now turn it on\nand control all functions\nwith the App"];
    [self.label2 setAdjustsFontSizeToFitWidth:YES];
    self.label2.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.51)
    .widthIs(viewX*0.618)
    .heightIs(viewY*0.142);
    
    //  //下面提示文字3
    self.label3 = [UILabel new];
    [self.view addSubview:self.label2];
    [self.label2 setTextColor:[UIColor whiteColor]];
    [self.label2 setTextAlignment:NSTextAlignmentCenter];
    [self.label2 setNumberOfLines:3];
    [self.label2 sizeToFit];
    [self.label2 setText:@"You can now turn it on\nand control all functions\nwith the App"];
    [self.label2 setAdjustsFontSizeToFitWidth:YES];
    self.label2.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.51)
    .widthIs(viewX*0.618)
    .heightIs(viewY*0.142);
    
    
#pragma mark 底部图标
    //1.开关
    self.btpower = [UIButton new];
    [self.view addSubview: self.btpower];
    [ self.btpower setBackgroundImage:[UIImage imageNamed:@"APP-Surface3_11"] forState:UIControlStateNormal];
    self.btpower.sd_layout
    .centerXIs(viewX*0.166)
    .centerYIs(viewY*0.84)
    .widthIs(viewX*0.206)
    .heightEqualToWidth();
    [self.btpower addTarget:self action:@selector(power) forControlEvents:UIControlEventTouchUpInside];
    
    //2.设置温度
    self.bttemp = [UIButton new];
    [self.view addSubview: self.bttemp];
    [ self.bttemp setBackgroundImage:[UIImage imageNamed:@"APP-Surface3_13"] forState:UIControlStateNormal];
    self.bttemp.sd_layout
    .centerXIs(viewX*0.39)
    .centerYIs(viewY*0.84)
    .widthIs(viewX*0.206)
    .heightEqualToWidth();
   
    //3.设置电池
    self.btbattery = [UIButton new];
    [self.view addSubview: self.btbattery];
    [ self.btbattery setBackgroundImage:[UIImage imageNamed:@"APP-Surface3_15"] forState:UIControlStateNormal];
    self.btbattery.sd_layout
    .centerXIs(viewX*0.615)
    .centerYIs(viewY*0.84)
    .widthIs(viewX*0.206)
    .heightEqualToWidth();
   
    //4.设置模式
    self.btturbo = [UIButton new];
    [self.view addSubview: self.btturbo];
    [ self.btturbo setBackgroundImage:[UIImage imageNamed:@"APP-Surface3_17"] forState:UIControlStateNormal];
    self.btturbo.sd_layout
    .centerXIs(viewX*0.838)
    .centerYIs(viewY*0.84)
    .widthIs(viewX*0.206)
    .heightEqualToWidth();
    
#pragma mark 底部图标文字
    //底部文字1
    UILabel * label11 = [UILabel new];
    [self.view addSubview:label11];
    [label11 setTextColor:[UIColor whiteColor]];
    [label11 setTextAlignment:NSTextAlignmentCenter];
    [label11 setNumberOfLines:2];
    [label11 sizeToFit];
    [label11 setText:@"ON\nOFF"];
    [label11 setAdjustsFontSizeToFitWidth:YES];
    label11.sd_layout
    .centerXIs(viewX*0.166)
    .centerYIs(viewY*0.91)
    .widthIs(viewX*0.154)
    .heightIs(viewY*0.035);
    
    //底部文字2
    UILabel * label12 = [UILabel new];
    [self.view addSubview:label12];
    [label12 setTextColor:[UIColor whiteColor]];
    [label12 setTextAlignment:NSTextAlignmentCenter];
    [label12 setNumberOfLines:2];
    [label12 sizeToFit];
    [label12 setText:@"Temperature\nSetting"];
    [label12 setAdjustsFontSizeToFitWidth:YES];
    label12.sd_layout
    .centerXIs(viewX*0.39)
    .centerYIs(viewY*0.91)
    .widthIs(viewX*0.206)
    .heightIs(viewY*0.035);
    
    //底部文字3
    UILabel * label13 = [UILabel new];
    [self.view addSubview:label13];
    [label13 setTextColor:[UIColor whiteColor]];
    [label13 setTextAlignment:NSTextAlignmentCenter];
    [label13 setNumberOfLines:2];
    [label13 sizeToFit];
    [label13 setText:@"Battery\nProtection"];
    [label13 setAdjustsFontSizeToFitWidth:YES];
    label13.sd_layout
    .centerXIs(viewX*0.615)
    .centerYIs(viewY*0.91)
    .widthIs(viewX*0.162)
    .heightIs(viewY*0.035);
    
    
    //底部文字4
    UILabel * label14 = [UILabel new];
    [self.view addSubview:label14];
    [label14 setTextColor:[UIColor whiteColor]];
    [label14 setTextAlignment:NSTextAlignmentCenter];
    [label14 setNumberOfLines:2];
    [label14 sizeToFit];
    [label14 setText:@"Turbo\nMode"];
    [label14 setAdjustsFontSizeToFitWidth:YES];
    label14.sd_layout
    .centerXIs(viewX*0.838)
    .centerYIs(viewY*0.91)
    .widthIs(viewX*0.092)
    .heightIs(viewY*0.035);
}

-(void) power{
    [self.label1 setHidden:YES];
    [self.label2 setHidden:YES];
    
}

@end
