//
//  SettingViewController.m
//  ccp_ios
//
//  Created by 罗路雅 on 2024/1/13.
//

#import "SettingViewController.h"
#import "BabyBluetooth.h"
#import "SDAutoLayout.h"
#import "MBProgressHUD.h"
#import "crc.h"

@interface SettingViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,retain) NSArray *celltitles;
@property (nonatomic,retain) NSArray *detailtitles;
@property(nonatomic,strong) NSString *strpass;
@property Byte bytePass1;
@property Byte bytePass2;
@property Byte bytePass3;

@property UILabel *label1;
@property UILabel *label2;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataRead = [[DataRead alloc] init];
    self.tableview = [[UITableView alloc]init];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.celltitles = [[NSArray alloc] initWithObjects:@"Bluetooth",@"Temperature Alarm",@"Temperature Unit",@"Version", nil];
    self.detailtitles = [[NSArray alloc] initWithObjects:@"Connectd >",@"None >",@"°C >",@"1.2.3.45", nil];
    self.label1 = [UILabel new];
    self.label2 = [UILabel new];
    [self setAutoLayout];
    baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableview reloadData];
    [self babyDelegate];
    baby.scanForPeripherals().begin();
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
    
    //蓝牙标志
    //47 86 ，77，136
    UIImageView *imgBle =[UIImageView new];
    [self.view addSubview:imgBle];
    [imgBle setImage:[UIImage imageNamed:@"ble"]];
    imgBle.sd_layout
        .leftSpaceToView(self.view, 0.876*viewX)
        .topSpaceToView(self.view, 0.055*viewY)
        .heightRatioToView(btReturn, 1.0)
        .widthIs(0.072*viewX);
    
    [self.view addSubview:self.tableview];
    [self.tableview setBackgroundColor:[UIColor colorWithRed:142/255.0 green:150/255.0 blue:143/255.0 alpha:1]];
    self.tableview.sd_layout
    .centerXEqualToView(self.view)
    .topSpaceToView(self.view, 0.15 *viewY)
    .widthRatioToView(self.view, 1.0)
    .heightIs(self.view.height*0.38);
}


#pragma mark - babyDelegate
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"Device discovered :%@",peripheral.name);
    }];

    //设置连接设备失败的委托
    [baby setBlockOnFailToConnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        weakSelf.hud.label.text = @"Device connected failed!\nPlease check the bluetooth!";
//        [weakSelf.hud setMinShowTime:1];
//        [weakSelf.hud showAnimated:YES];
//        [weakSelf.hud hideAnimated:YES];
    }];
    
    //设置断开设备的委托
    [baby setBlockOnDisconnect:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
//        weakSelf.hud.mode = MBProgressHUDModeIndeterminate;
//        weakSelf.hud.label.text = @"Disconnet devices";
//        [weakSelf.hud setMinShowTime:1];
//        [weakSelf.hud showAnimated:YES];
    }];

    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //   NSLog(@"read characteristic successfully!");
        
     
        if([characteristics.UUID.UUIDString isEqualToString:@"FEE1"]){
       
            NSData *data = characteristics.value;
            Byte r[22] = {0};
            
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
                [weakSelf updateStatus];
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

#pragma mark tableviewdatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    [cell setBackgroundColor:[UIColor colorWithRed:142/255.0 green:150/255.0 blue:143/255.0 alpha:1]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:105/255.0 green:79.0/255 blue:83/255.0 alpha:1]];
    [cell.textLabel setText:[self.celltitles objectAtIndex:indexPath.row]];
    
    [cell.detailTextLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setText:[self.detailtitles objectAtIndex:indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

//更新状态
-(void)updateStatus{
    //有返回非零数字，密码正确。保存密码
}

@end
