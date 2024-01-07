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
@property (nonatomic,retain) UILabel *lbmode;  //提示功能状态
@property (nonatomic,retain) UILabel *label1;  //开机提示
@property (nonatomic,retain) UILabel *label2;  //开机提示
@property (nonatomic,retain) UILabel *label3;  //提示温度

@property (nonatomic,retain) UILabel *lbselect;  //提示设置温度
@property (nonatomic,retain) UILabel *lbcurrent;  //当前温度
@property (nonatomic,retain) UILabel *lbsetting;  //设置温度
@property (nonatomic,retain) UIButton *btadd;    //按钮加
@property (nonatomic,retain) UIButton *btdrop;   //按钮减

@property (nonatomic,retain) UIButton *bthigh;   //按钮高
@property (nonatomic,retain) UIButton *btmedium;   //按钮中
@property (nonatomic,retain) UIButton *btlow;   //按钮低

@property (nonatomic,retain) UIButton *bton;   //按钮开
@property (nonatomic,retain) UIButton *btoff;   //按钮关

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
    [self.lbselect setHidden:YES];
    [self.lbcurrent setHidden:YES];
    [self.lbsetting setHidden:YES];
    [self.btadd setHidden:YES];
    [self.btdrop setHidden:YES];
    [self.bthigh setHidden:YES];
    [self.btmedium setHidden:YES];
    [self.btlow setHidden:YES];
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
    
    //显示功能
    self.lbmode = [UILabel new];
    [self.view addSubview:self.lbmode];
    [self.lbmode setTextColor:[UIColor whiteColor]];
    [self.lbmode setTextAlignment:NSTextAlignmentCenter];
    [self.lbmode sizeToFit];
    [self.lbmode setText:@"Current Temperature"];
    self.lbmode.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.177)
    .widthIs(viewX*0.618)
    .heightIs(viewY*0.142);
    [self.lbmode setAdjustsFontSizeToFitWidth:YES];
    
    //提示设置温度
    self.lbselect = [UILabel new];
    [self.view addSubview:self.lbselect];
    [self.lbselect setTextColor:[UIColor colorWithRed:152.0/255 green:159.0/255 blue:175.0/255 alpha:1.0]];
    [self.lbselect setTextAlignment:NSTextAlignmentCenter];
    [self.lbselect sizeToFit];
    [self.lbselect setText:@"Preselected Temperature"];
    self.lbselect.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.716)
    .widthIs(viewX*0.618)
    .heightIs(viewY*0.142);
    [self.lbmode setAdjustsFontSizeToFitWidth:YES];
    
    
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
    
#pragma mark 温度相关
    //按钮加
    self.btadd = [UIButton new];
    [self.view addSubview: self.btadd];
    [ self.btadd setBackgroundImage:[UIImage imageNamed:@"APP-Surface5_07"] forState:UIControlStateNormal];
    self.btadd.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.388)
    .widthIs(viewX*0.162)
    .heightEqualToWidth();
    [self.btadd addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮减
    self.btdrop = [UIButton new];
    [self.view addSubview: self.btdrop];
    [ self.btdrop setBackgroundImage:[UIImage imageNamed:@"APP-Surface5_09"] forState:UIControlStateNormal];
    self.btdrop.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.637)
    .widthIs(viewX*0.162)
    .heightEqualToWidth();
    [self.btdrop addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    
    //富文本

    //当前温度
    self.lbcurrent = [UILabel new];
    [self.view addSubview:self.lbcurrent];
    [self.lbcurrent setTextColor:[UIColor whiteColor]];
    [self.lbcurrent setTextAlignment:NSTextAlignmentCenter];
    [self.lbcurrent sizeToFit];
    [self.lbcurrent setText:@"+12°C"];
    [self.lbcurrent setAdjustsFontSizeToFitWidth:YES];
    [self.lbcurrent setFont:[UIFont fontWithName:@"Arial" size:60.0]];
    self.lbcurrent.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.26)
    .widthIs(viewX*0.507)
    .heightIs(viewY*0.087);
    
    //设置温度
    self.lbsetting = [UILabel new];
    [self.view addSubview:self.lbsetting];
    [self.lbsetting setTextColor:[UIColor whiteColor]];
    [self.lbsetting setTextColor:[UIColor colorWithRed:152.0/255 green:159.0/255 blue:175.0/255 alpha:1.0]];
    [self.lbsetting setTextAlignment:NSTextAlignmentCenter];
    [self.lbsetting sizeToFit];
    [self.lbsetting setText:@"-18°C"];
    [self.lbsetting setAdjustsFontSizeToFitWidth:YES];
    [self.lbsetting setFont:[UIFont fontWithName:@"Arial" size:60.0]];
    self.lbsetting.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.518)
    .widthIs(viewX*0.507)
    .heightIs(viewY*0.087);
    
    
#pragma mark 电池选择按钮
    //电池保护高
    self.bthigh = [UIButton new];
    [self.view addSubview: self.bthigh];
    [ self.bthigh setBackgroundImage:[UIImage imageNamed:@"APP-Surface4_07"] forState:UIControlStateNormal];
    self.bthigh.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.387)
    .widthIs(viewX*0.43)
    .heightIs(viewY *0.081);
    [self.bthigh addTarget:self action:@selector(sethigh) forControlEvents:UIControlEventTouchUpInside];
    
    //电池保护中
    self.btmedium = [UIButton new];
    [self.view addSubview: self.btmedium];
    [ self.btmedium setBackgroundImage:[UIImage imageNamed:@"APP-Surface4_17"] forState:UIControlStateNormal];
    self.btmedium.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.5)
    .widthIs(viewX*0.43)
    .heightIs(viewY *0.081);
    [self.btmedium addTarget:self action:@selector(setmedium) forControlEvents:UIControlEventTouchUpInside];
    //电池保护低
    self.btlow = [UIButton new];
    [self.view addSubview: self.btlow];
    [ self.btlow setBackgroundImage:[UIImage imageNamed:@"APP-Surface4_27"] forState:UIControlStateNormal];
    self.btlow.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.613)
    .widthIs(viewX*0.43)
    .heightIs(viewY *0.081);
    [self.btlow addTarget:self action:@selector(setlow) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark 加强模式开关
    //加强模式开
    self.bton = [UIButton new];
    [self.view addSubview: self.bton];
    [ self.bton setBackgroundImage:[UIImage imageNamed:@"APP-Surface4_37"] forState:UIControlStateNormal];
    self.bton.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.387)
    .widthIs(viewX*0.43)
    .heightIs(viewY *0.081);
    [self.bton addTarget:self action:@selector(setlow) forControlEvents:UIControlEventTouchUpInside];
    
    //加强模式关
    self.btoff = [UIButton new];
    [self.view addSubview: self.btoff];
    [ self.btoff setBackgroundImage:[UIImage imageNamed:@"APP-Surface4_47"] forState:UIControlStateNormal];
    self.btoff.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.5)
    .widthIs(viewX*0.43)
    .heightIs(viewY *0.081);
    [self.btoff addTarget:self action:@selector(setlow) forControlEvents:UIControlEventTouchUpInside];
    
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




//升温
-(void) add{
}


//降温
-(void)drop{
    
}

//电池高
-(void)sethigh{
    
}

//电池中
-(void)setmedium{
    
}
//电池低
-(void)setlow{
    
}

@end
