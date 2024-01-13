//
//  ViewController.m
//  ccp_ios
//
//  Created by 罗路雅 on 2024/1/7.
//

#import "ViewController.h"
#import "BabyBluetooth.h"
#import "SDAutoLayout.h"
#import "MBProgressHUD.h"
#import "crc.h"
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "PassViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,AVCaptureMetadataOutputObjectsDelegate>
@property (retain, nonatomic)  MBProgressHUD *hud;
@property (nonatomic,retain) NSMutableArray <CBPeripheral*> *devices;;
@property (nonatomic,retain) NSMutableArray *localNames;
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) UIView *viewMusk;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong)  UIButton *btclose;
//@property (nonatomic,retain)  UIView * viewPass;  //密码界面
//@property(nonatomic, strong) UITextField *tfPass1;
//@property(nonatomic, strong) UITextField *tfPass2;
//@property(nonatomic, strong) UITextField *tfPass3;
@property(nonatomic,strong) NSString *strpass;
@property Byte bytePass1;
@property Byte bytePass2;
@property Byte bytePass3;

@property NSString *deviceprofix;

@property (nonatomic,retain)  AVCaptureSession *session; //扫描二维码会话
@property (nonatomic,retain)  AVCaptureVideoPreviewLayer *layer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hud = [[MBProgressHUD alloc]init];
    
    self.dataRead = [[DataRead alloc] init];
    self.tableview = [[UITableView alloc]init];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.devices = [[NSMutableArray alloc]init];
    self.localNames = [[NSMutableArray alloc]init];
    [self setAutoLayout];
    [self creatview];
    baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
}

-(void)viewDidAppear:(BOOL)animated{
   // [self.viewMusk setHidden:YES];
    [self.tableview reloadData];
    [self babyDelegate];
    baby.scanForPeripherals().begin();
    //[self.viewMusk setHidden:NO];
}

-(void)setAutoLayout{
    
    double viewX = [UIScreen mainScreen].bounds.size.width;
    double viewY = [UIScreen mainScreen].bounds.size.height;
    [self.view setBackgroundColor:[UIColor colorWithRed:142.0/255 green:150.0/255 blue:143.0/255 alpha:1.0]];
    
    //导航栏
    UIView *viewTop = [UIView new];
    [self.view addSubview:viewTop];
    [viewTop setBackgroundColor:[UIColor colorWithRed:105.0/255 green:79.0/255 blue:83.0/255 alpha:1.0]];
    viewTop.sd_layout
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .topEqualToView(self.view)
    .heightRatioToView(self.view, 0.1);
    
    //商标
    UIImageView *imglogo = [UIImageView new];
    [self.view addSubview:imglogo];
    [imglogo setImage:[UIImage imageNamed:@"MYCOOLMAN"]];
    imglogo.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY * 0.07)
    .widthIs(viewX*0.443)
    .heightRatioToView(self.view, 0.031);
    
    //返回
    //47 86 ，77，136
    UIButton *btReturn =[UIButton new];
    [self.view addSubview:btReturn];
    [btReturn setImage:[UIImage imageNamed:@"APP-Surface16_05"] forState:UIControlStateNormal];
    btReturn.sd_layout
    .leftSpaceToView(self.view, 0.062*viewX)
    .topSpaceToView(self.view, 0.054*viewY)
    .widthIs(0.039*viewX)
    .heightIs(0.031*viewY);
    
    //设置
    //673 88 ，721，698
    UIButton *btSetting =[UIButton new];
    [self.view addSubview:btSetting];
    [btSetting setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    btSetting.sd_layout
    .leftSpaceToView(self.view, 0.876*viewX)
    .topSpaceToView(self.view, 0.055*viewY)
    .widthIs(0.062*viewX)
    .heightEqualToWidth();
    
    
    //文字 recreational seris
    UIImageView *imgRCeational = [UIImageView new];
    [imgRCeational setImage:[UIImage imageNamed:@"APP-Surface10_05"]];
    [self.view addSubview:imgRCeational];
    imgRCeational.sd_layout
    .centerXEqualToView(self.view)
    .widthRatioToView(self.view, 0.88)
    .centerYIs(viewY*0.222)
    .heightIs(viewY*0.115);
    
    //中间提示文字
    UILabel *lbInstruction = [UILabel new];
    [self.view addSubview:lbInstruction];
    [lbInstruction setTextColor:[UIColor whiteColor]];
    [lbInstruction setTextAlignment:NSTextAlignmentCenter];
    [lbInstruction setNumberOfLines:4];
    [lbInstruction sizeToFit];
    [lbInstruction setText:@"To connect your MyCoolman\nwith Bluetooth\nensure the cooler is set to Bluetooth ON"];
    lbInstruction.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.42)
    .widthIs(viewX*0.622)
    .heightIs(viewY*0.142);
    [lbInstruction setAdjustsFontSizeToFitWidth:YES];
    
    //扫描二维码
    UIButton *btScan = [UIButton new];
    [self.view addSubview:btScan];
    [btScan setBackgroundColor:[UIColor colorWithRed:105.0/255 green:79.0/255 blue:83.0/255 alpha:1.0]];
    [btScan setTitle:@"Scan QR Code" forState:UIControlStateNormal];
    btScan.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.6)
    .widthIs(viewX*0.44)
    .heightIs(viewY*0.08);
    [btScan setSd_cornerRadius:@8.0f];
    [btScan addTarget:self action:@selector(scanQRcode) forControlEvents:UIControlEventTouchUpInside];

    //下面提示文字
    UILabel *lbInstr = [UILabel new];
    [self.view addSubview:lbInstr];
    [lbInstr setTextColor:[UIColor whiteColor]];
    [lbInstr setTextAlignment:NSTextAlignmentCenter];
    [lbInstr setNumberOfLines:2];
    [lbInstr sizeToFit];
    [lbInstr setText:@"Or use the phone menue\nand search for device"];
    [lbInstr setAdjustsFontSizeToFitWidth:YES];
    
    lbInstr.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.7)
    .widthIs(viewX*0.618)
    .heightIs(viewY*0.142);
    
    //扫描蓝牙
    UIButton *btBluetooth = [UIButton new];
    [self.view addSubview:btBluetooth];
    //[btBluetooth setBackgroundColor:[UIColor colorWithRed:200.0/255 green:101.0/255 blue:69.0/255 alpha:1.0]];
    [btBluetooth setBackgroundImage:[UIImage imageNamed:@"APP-Surface3_47"] forState:UIControlStateNormal];
    btBluetooth.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.84)
    .heightIs(viewY*0.08)
    .widthEqualToHeight();
    [btBluetooth setSd_cornerRadius:@8.0f];
    [btBluetooth addTarget:self action:@selector(bleTouched) forControlEvents:UIControlEventTouchUpInside];
}


#pragma  - mark 弹窗
-(void)creatview{
    CGRect parentFrame = self.view.frame;
    float rwidth = parentFrame.size.width/390;
    float rheight = parentFrame.size.height/844;
    
    CGRect muskFrame = CGRectMake(parentFrame.origin.x, parentFrame.origin.y, parentFrame.size.width, parentFrame.size.height);
    self.viewMusk = [[UIView alloc] initWithFrame:muskFrame];
    [self.viewMusk setBackgroundColor:[UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:0.5]];
    [self.view addSubview:self.viewMusk];
    
    [self.viewMusk addSubview:self.tableview];
    [self.tableview setBackgroundColor:[UIColor colorWithRed:212.0/255 green:211.0/255 blue:207.0/255 alpha:1.0]];
    self.tableview.sd_layout
        .centerXEqualToView(self.viewMusk)
        .widthRatioToView(self.viewMusk, 0.9)
        .centerYEqualToView(self.viewMusk)
        .heightRatioToView(self.viewMusk, 0.5);
    self.tableview.layer.cornerRadius = 10.0f;
    self.tableview.layer.masksToBounds = YES;
    
    self.btclose = [UIButton new];
    [self.btclose setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [self.viewMusk addSubview:self.btclose];
    self.btclose.sd_layout
        .rightEqualToView(self.tableview)
        .bottomSpaceToView(self.tableview, 0)
        .widthIs(self.view.size.width/10.0)
        .heightEqualToWidth();
    [self.btclose addTarget:self action:@selector(closeTableView) forControlEvents:UIControlEventTouchUpInside];
    [self.viewMusk setHidden:YES];
}


#pragma mark - babyDelegate
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"Device discovered :%@",peripheral.name);
        
        /*
        NSString *advertiseName = advertisementData[@"Local Name"];
        if([advertiseName hasPrefix:@"CCP15R"]||[advertiseName hasPrefix:@"CCP15R"]||[advertiseName hasPrefix:@"EVA"]||[advertiseName hasPrefix:@"GCA"])  {
            [weakSelf.devices addObject:peripheral];
            [weakSelf.localNames addObject:advertiseName];
            // weakSelf.currPeripheral = peripheral;
            [weakSelf.tableview reloadData];
            if([weakSelf.devices count]>5){
                [central stopScan];
            }
            if([advertiseName hasPrefix:@"EVA24"]) {
                weakSelf.brand = @"EVA24VTR";
            }else if([advertiseName hasPrefix:@"EVA12"]){
                weakSelf.brand = @"EVA12VTR";
            }else{
                weakSelf.brand = @"EVA2700RV";
            }
        }
        */
    
        if([peripheral.name hasPrefix:@"CCP15R"] ||[peripheral.name hasPrefix:@"CCP20R"]){
            [weakSelf.devices addObject:peripheral];
            [weakSelf.tableview reloadData];
          //  [baby.centralManager connectPeripheral:peripheral options:nil];
        }
        // [weakSelf.tableView reloadData];
        if([weakSelf.devices count]>5){
            [central stopScan];
        }
    }];
    
    //设置连接设备失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        weakSelf.hud.label.text = @"Device connected failed!\nPlease check the bluetooth!";
        [weakSelf.hud setMinShowTime:1];
        [weakSelf.hud showAnimated:YES];
        [weakSelf.hud hideAnimated:YES];
    }];
    
    //设置断开设备的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        weakSelf.hud.mode = MBProgressHUDModeIndeterminate;
        weakSelf.hud.label.text = @"Disconnet devices";
        [weakSelf.hud setMinShowTime:1];
        [weakSelf.hud showAnimated:YES];
    }];
    
    //设置设备连接成功的委托
    [baby setBlockOnConnected:^(CBCentralManager *central, CBPeripheral *peripheral) {
        [central stopScan];
        NSLog(@"设备：%@--连接成功",peripheral.name);
        weakSelf.currPeripheral = peripheral;
        [peripheral discoverServices:nil];
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
            for(CBService *service in peripheral.services){
                [peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }];
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        // NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            //NSLog(@"charateristic name is :%@",c.UUID);
            if([c.UUID.UUIDString isEqualToString:@"FEE1"]){
                weakSelf.currPeripheral = peripheral;
                weakSelf.characteristic = c;
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                weakSelf.strpass = [defaults  objectForKey:peripheral.identifier.UUIDString];
                
                if(weakSelf.strpass != nil){
                    weakSelf.bytePass1 = (int)strtoul([[weakSelf.strpass substringWithRange:NSMakeRange(0, 1)] UTF8String],0,16);
                    weakSelf.bytePass2 = (int)strtoul([[weakSelf.strpass substringWithRange:NSMakeRange(1, 1)] UTF8String],0,16);
                    weakSelf.bytePass3 = (int)strtoul([[weakSelf.strpass substringWithRange:NSMakeRange(2, 1)] UTF8String],0,16);
                    [weakSelf.viewMusk setHidden:YES];
                    
                    if(self.characteristic != nil){
                        Byte  write[8];
                        write[0] = 0xAA;
                        write[1] = 0x01;
                        write[2] = 0x00;
                        write[3] = (Byte)weakSelf.bytePass1;
                        write[4] = (Byte)weakSelf.bytePass2*16+weakSelf.bytePass3;
                        write[6] = 0xFF & CalcCRC(&write[1], 4);
                        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
                        write[7] = 0x55;
                        
                        //首次连接 write = AA 09 01 00 00 78 52 55
                        
                        NSData *data = [[NSData alloc]initWithBytes:write length:8];
                        [weakSelf.currPeripheral writeValue:data forCharacteristic:weakSelf.characteristic type:CBCharacteristicWriteWithResponse];
                        [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:weakSelf.characteristic];
                    }
                }
                [peripheral readValueForCharacteristic:c];
            }
        }
    }];
    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //   NSLog(@"read characteristic successfully!");
        
        [weakSelf.hud hideAnimated:YES];
        [weakSelf.hud removeFromSuperview];
        
        if([characteristics.UUID.UUIDString isEqualToString:@"FEE1"]){
            
            weakSelf.characteristic = characteristics;
            weakSelf.currPeripheral = peripheral;
            
            NSData *data = characteristics.value;
            Byte r[22] = {0};
            
            if(data.length == 0){
                [weakSelf getPassWord];
            }
            /*
             @property Byte  start; //通讯开始
             @property Byte  power; //0x01开机，0x00关机
             @property Byte  tempcool;  //设定制冷温度
             @property Byte  tempReal;  //实时制冷温度或加热温度
             @property Byte  frozesetting;  //   冷冻箱设定温度 （双温区冰箱才有效，单温区冰箱忽略该数据）
             @property Byte  frozereal;  // 冷冻箱实时温度 （双温区冰箱才有效，单温区冰箱忽略该数据）
             @property Byte  turbo;  //TURBOM模式 0X00-ECO  0X01-TURBO
             @property Byte  heat; //加热或制冷模式 0X00-制冷模式 0X01-加热模式（单冷冰箱没有此值）
             @property Byte  battery;  //电池保护设置 0-低档 1-中档 2-高档
             @property Byte  unit;  //温度单温 0-华氏度 1-摄氏度
             @property Byte  status;  //工作状态  0-停机 1-工作
             @property Byte  errorcode;  //故障代码
             @property Byte  vhigh;   //电压高八位
             @property Byte  vlow;  //电压低八位
             @property Byte  gc;    //GC单温冰箱 固定0x03
             @property Byte  tempheat;   //加热设定温度
             @property Byte  timer;    //定时关机时间
             @property Byte  code1;    //备用
             @property Byte  code2;    //备用
             @property Byte  crcH;  //CRC 校验高八位
             @property Byte  crcL;  //CRC 校验高八位
             @property Byte  end;  //通讯结束
             */
            
            if(data.length == 22){
                memcpy(r, [data bytes], 22);
                NSLog(@"copy data successfully!");
                weakSelf.dataRead.start = r[0];  //通讯开始
                weakSelf.dataRead.power = r[1];  //开机0x01 关机0x00
                weakSelf.dataRead.tempcool = r[2];  //设定制冷温度
                weakSelf.dataRead.tempReal = r[3];     //实时制冷或加热温度
                weakSelf.dataRead.frozesetting = r[4];  //冷冻箱设定温度
                weakSelf.dataRead.frozereal = r[5];   //冷冻箱实时温度
                weakSelf.dataRead.turbo = r[6];   //URBOM模式 0X00-ECO  0X01-TURBO
                weakSelf.dataRead.heat = r[7];    //加热或制冷模式 0X00-制冷模式 0X01-加热模式（单冷冰箱没有此值）
                weakSelf.dataRead.battery = r[8];   //电池保护设置 0-低档 1-中档 2-高档
                weakSelf.dataRead.unit = r[9];    //温度单位 0华氏 1摄氏
                weakSelf.dataRead.status = r[10];  //工作状态 0停机 1工作
                weakSelf.dataRead.errorcode = r[11];     //故障代码
                weakSelf.dataRead.vhigh = r[12];  //电压高八位
                weakSelf.dataRead.vlow = r[13];   //电压低八位
                weakSelf.dataRead.gc = r[14];    //冰箱类型
                weakSelf.dataRead.tempheat = r[15];  //加热设定温度
                weakSelf.dataRead.timer = r[16]; //定时关机时间
                weakSelf.dataRead.code1 = r[17];  //备用1
                weakSelf.dataRead.code2 = r[18];  //备用2
                weakSelf.dataRead.crcH = r[19];   //CRC校验高八位
                weakSelf.dataRead.crcL = r[20];   //CRC校验低八位
                weakSelf.dataRead.end = r[21];  //通信结束
                if(self.dataRead.gc == 0x00){
                    NSLog(@"跳到密码输入界面");
                   // [weakSelf.viewPass setHidden:NO];
                    [weakSelf.viewMusk setHidden:YES];
                    PassViewController  *passViewController = [PassViewController new];
                    [passViewController setModalPresentationStyle:UIModalPresentationFullScreen];
                    passViewController.currPeripheral = weakSelf.currPeripheral;
                    passViewController.characteristic = weakSelf.characteristic;
                    [weakSelf presentViewController:passViewController animated:YES completion:nil];
                }else{
                    [weakSelf updateStatus];
                }
            }
        }
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    //设置连接的设备的过滤器
    
     __block BOOL isFirst = YES;
     [baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
     if(isFirst && ([peripheralName hasPrefix:@"CCP15R"]|| [peripheralName hasPrefix:@"CCP20R"])){
     isFirst = NO;
     return YES;
     }
     return NO;
     }];
}

//按下蓝牙按钮

-(void)bleTouched{
    [self.viewMusk setHidden:NO];
    [self.tableview setHidden:NO];
    [self.btclose setHidden:NO];
}

-(void) deviceSelected{
    //baby.scanForPeripherals().begin();
    //[self.viewMusk setHidden:NO];
   // [self.tableview setHidden:NO];
    //baby.scanForPeripherals().begin();
    
//    [self.tfPass1 setHidden:YES];
//    [self.tfPass2 setHidden:YES];
//    [self.tfPass3 setHidden:YES];
    
   // self.hud = [[MBProgressHUD alloc]initWithView:self.body];
    self.hud = [[MBProgressHUD alloc]initWithView:self.viewMusk];
    [self.viewMusk addSubview:self.hud];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    
    [self.hud setOffset:CGPointMake(0, -150 *self.view.height/844.0)];
    //self.hud.label.text = @"Scan bluetooth";
    self.hud.label.text = NSLocalizedString(@"connect", nil);
    [self.hud showAnimated:YES];
    [self.hud hideAnimated:YES afterDelay:10];
}


#pragma mark tableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.devices count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    CBPeripheral *peripheral = [self.devices objectAtIndex:indexPath.row];
   // NSString *advertiseName = [self.localNames objectAtIndex:indexPath.row];
    [cell.textLabel setText:peripheral.name];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableview setHidden:YES];
    [self.btclose setHidden:YES];
    
    [baby.centralManager stopScan];
    [baby cancelAllPeripheralsConnection];
    [baby.centralManager connectPeripheral:[self.devices objectAtIndex:indexPath.row] options:nil];

    
    self.hud = [MBProgressHUD showHUDAddedTo:self.viewMusk animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.label.text = @"connect to device.....";
    [self.hud showAnimated:YES];
    
}


//关闭密码框
-(void)closeTableView{
    [self.tableview setHidden:YES];
    [self.btclose setHidden:YES];
    [self.viewMusk setHidden:YES];
}


//获取密码
-(void)getPassWord{
    //大板 A46
//    [self.tfPass1 setHidden:NO];
//    [self.tfPass2 setHidden:NO];
//    [self.tfPass3 setHidden:NO];
    
    if(self.characteristic != nil){
        Byte  write[8];
        write[0] = 0xAA;
        write[1] = 0x09;
        write[2] = 0x01;
        write[3] = 0x00;
        write[4] = 0x00;
        write[6] = 0xFF & CalcCRC(&write[1], 4);
        write[5] = 0xFF & (CalcCRC(&write[1], 4)>>8);
        write[7] = 0x55;
        
        //首次连接 write = AA 09 01 00 00 78 52 55
        
        NSData *data = [[NSData alloc]initWithBytes:write length:8];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithResponse];
        [self.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic];
        // [self updateStatus];
    }
}

//执行扫描二维码
-(void)scanQRcode{
    //设置会话
    AVAuthorizationStatus authStatus =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //判断摄像头状态是否可用
    if(authStatus==AVAuthorizationStatusAuthorized){
        //开始扫描二维码
        [self startScanQR];
    }else{
        NSLog(@"未开启相机权限，请前往设置中开启");
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                [self startScanQR];
            } else {
                // 拒绝
            }
        }];
    }
}

//开始扫描
-(void) startScanQR{
    self.session = [[AVCaptureSession alloc]init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    [self.session addInput:input];
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addOutput:output];
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    AVCaptureVideoPreviewLayer *layer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    layer.frame = self.view.bounds;
    [self.view.layer addSublayer:layer];
    self.layer = layer;
    [self.session startRunning];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0)
    {
        //1.获取到扫描的内容
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        NSLog(@"扫描的内容==%@",object.stringValue);
        NSString *strtype = [[NSString alloc]init];
        if(object.stringValue.length>=10){
            NSArray *strs = [object.stringValue componentsSeparatedByString:@"="];
            if(strs.count >=2){
                strtype = [strs objectAtIndex:2];
            }
        }
        NSLog(@"---------%@",strtype);
        
        for(CBPeripheral *peripheral in self.devices){
            if([peripheral.name isEqualToString:strtype]){
                [self.viewMusk setHidden:YES];
                [baby.centralManager stopScan];
                [baby cancelAllPeripheralsConnection];
                [baby.centralManager connectPeripheral:peripheral options:nil];
                //2.停止会话
                [self.session stopRunning];
                //3.移除预览图层
                [self.layer removeFromSuperlayer];
            }
        }
        
        
        /*
        int i=0;
        for(i=0;i<self.devices.count;i++){
            if([[self.devices objectAtIndex:i].name isEqualToString:strtype]){
                [self.viewMusk setHidden:NO];
                [self.tableview setHidden:YES];
                [self.btclose setHidden:YES];
                //[self.viewPass setHidden:YES];
                [baby.centralManager stopScan];
                [baby cancelAllPeripheralsConnection];
                [baby.centralManager connectPeripheral:[self.devices objectAtIndex:i] options:nil];
                //2.停止会话
                [self.session stopRunning];
                //3.移除预览图层
                [self.layer removeFromSuperlayer];
                return;
            }
        }*/
        //没有找到设备
       
            self.hud.mode = MBProgressHUDModeText;
            [self.view addSubview:self.hud];
            self.hud.label.text = @"Device not found!";
            [self.hud setMinShowTime:3];
            [self.hud showAnimated:YES];
            [self.hud hideAnimated:YES];
        
    
        /*
        int i=0;
        for(i=0;i<self.devices.count;i++){
            if([[self.devices objectAtIndex:i].name hasPrefix:strtype]){
                [baby.centralManager stopScan];
                [baby cancelAllPeripheralsConnection];
                [baby.centralManager connectPeripheral:[self.devices objectAtIndex:i] options:nil];
            }
        }
        //没有找到设备
        if(i==self.devices.count){
            self.hud.mode = MBProgressHUDModeText;
            [self.view addSubview:self.hud];
            self.hud.label.text = @"Device not found!";
            [self.hud setMinShowTime:3];
            [self.hud showAnimated:YES];
            [self.hud hideAnimated:YES];
        }
        */
        //2.停止会话
        [self.session stopRunning];
        //3.移除预览图层
        [self.layer removeFromSuperlayer];
    }
}


//更新状态
-(void)updateStatus{
    //有返回非零数字，密码正确。保存密码
    if( self.dataRead.gc!= 0 ){
        [self.viewMusk setHidden:YES];
//        if(self.strpass == nil){
//            //保存密码
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            self.strpass = [NSString stringWithFormat:@"%@%@%@",self.tfPass1.text,self.tfPass2.text,self.tfPass3.text];
//            [defaults setValue:self.strpass forKey:self.currPeripheral.identifier.UUIDString];
//            self.bytePass1 = (Byte)strtoul([self.tfPass1.text UTF8String],0,16);  //16进制字符串转换成int
//            self.bytePass2 = (Byte)strtoul([self.tfPass2.text UTF8String],0,16);  //16进制字符串转换成int
//            self.bytePass3 = (Byte)strtoul([self.tfPass3.text UTF8String],0,16);  //16进
//        }
    
        [self.viewMusk setHidden:YES];
        //  [baby.centralManager  stopScan];
        [self.hud setHidden:YES];
        [self.hud removeFromSuperview];
        [self.viewMusk removeFromSuperview];
        
        MainViewController *mainViewController = [[MainViewController alloc]init];
        [mainViewController setModalPresentationStyle:UIModalPresentationFullScreen];
        mainViewController.currPeripheral = self.currPeripheral;
        mainViewController.characteristic = self.characteristic;
        [self presentViewController:mainViewController animated:YES completion:nil];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
   // TruckViewController *ViewController = (TruckViewController *) segue.destinationViewController;
   // ViewController.currPeripheral = self.currPeripheral;
   // ViewController.characteristic = self.characteristic;
}



@end
