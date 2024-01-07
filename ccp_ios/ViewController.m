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

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic)  MBProgressHUD *hud;
@property (nonatomic,retain) NSMutableArray <CBPeripheral*> *devices;;
@property (nonatomic,retain) NSMutableArray *localNames;
@property (nonatomic,strong) NSString *brand;
@property (nonatomic,strong) UIView *viewMusk;
@property (nonatomic,strong) UITableView *tableview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableview = [[UITableView alloc]init];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.devices = [[NSMutableArray alloc]init];
    self.localNames = [[NSMutableArray alloc]init];
   // self.strType = [NSString new];
    [self setAutoLayout];
    baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableview reloadData];
    [self babyDelegate];
    baby.scanForPeripherals().begin();
    //[self.viewMusk setHidden:NO];
}


-(void)setAutoLayout{
    
    double frameWidth = 236;
    double frameHeight = 480;
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
    
    //中间提示文字
    UILabel *lbInstruction = [UILabel new];
    [self.view addSubview:lbInstruction];
    [lbInstruction setTextColor:[UIColor whiteColor]];
    [lbInstruction setTextAlignment:NSTextAlignmentCenter];
    [lbInstruction setNumberOfLines:4];
    [lbInstruction sizeToFit];
    [lbInstruction setText:@"To connect your TREKOOL\nwith Bluetooth\nensure the cooler is set to Bluetooth ON"];
    lbInstruction.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.42)
    .widthIs(viewX*0.618)
    .heightIs(viewY*0.142);
    [lbInstruction setAdjustsFontSizeToFitWidth:YES];
    
    //扫描二维码
    UIButton *btScan = [UIButton new];
    [self.view addSubview:btScan];
    [btScan setBackgroundColor:[UIColor colorWithRed:200.0/255 green:101.0/255 blue:69.0/255 alpha:1.0]];
    [btScan setTitle:@"Scan QR Code" forState:UIControlStateNormal];
    btScan.sd_layout
    .centerXEqualToView(self.view)
    .centerYIs(viewY*0.6)
    .widthIs(viewX*0.44)
    .heightIs(viewY*0.08);
    [btScan setSd_cornerRadius:@8.0f];

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
    
    //扫描二维码
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
    
}

-(void)scan{
    //baby.scanForPeripherals().begin();
    [self.viewMusk setHidden:NO];
    //baby.scanForPeripherals().connectToPeripherals().begin();
}







#pragma mark - babyDelegate
//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    __weak typeof(self) weakSelf = self;
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"Device discovered :%@",peripheral.name);
        
//        if(([peripheral.name hasPrefix:@"CCA"]||[peripheral.name hasPrefix:@"GCA"]) && ![self.devices containsObject:peripheral])  {
        NSString *advertiseName = advertisementData[@"kCBAdvDataLocalName"];
        if([advertiseName hasPrefix:@"G29"]||[advertiseName hasPrefix:@"G29A"]||[advertiseName hasPrefix:@"EVA"]||[advertiseName hasPrefix:@"GCA"])  {
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
        weakSelf.hud.mode = MBProgressHUDModeText;
        weakSelf.hud.label.text = @"Device connected!";
        [weakSelf.hud setMinShowTime:1];
        [weakSelf.hud hideAnimated:YES];
        [peripheral discoverServices:nil];
        
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServices:^(CBPeripheral *peripheral, NSError *error) {
        for (CBService *service in peripheral.services) {
            NSLog(@"搜索到服务:%@",service.UUID.UUIDString);
            //for(CBService *service in peripheral.services){
                if([service.UUID.UUIDString isEqualToString:@"FFE0"]){
                 [peripheral discoverCharacteristics:nil forService:service];
            }
        }
    }];
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
    
            if([c.UUID.UUIDString isEqualToString:@"FFE1"]){
                [weakSelf.viewMusk setHidden:YES];
                
                /*
                if([weakSelf.brand isEqualToString:@"EVA24VTR"]){
                    TruckViewController *truckViewController = [[TruckViewController alloc]init];
                    [truckViewController setModalPresentationStyle:UIModalPresentationFullScreen];
                    truckViewController.currPeripheral = weakSelf.currPeripheral;
                    truckViewController.characteristic = c;
                    truckViewController.brand = weakSelf.brand;
                    [weakSelf presentViewController:truckViewController animated:YES completion:nil];
                }else  if([weakSelf.brand isEqualToString:@"EVA12VTR"]){
                    TruckViewController *truckViewController = [[TruckViewController alloc]init];
                    [truckViewController setModalPresentationStyle:UIModalPresentationFullScreen];
                    truckViewController.currPeripheral = weakSelf.currPeripheral;
                    truckViewController.characteristic = c;
                    truckViewController.brand = weakSelf.brand;
                    [weakSelf presentViewController:truckViewController animated:YES completion:nil];
                }else{
                    RoomViewController *roomViewController = [[RoomViewController alloc]init];
                    [roomViewController setModalPresentationStyle:UIModalPresentationFullScreen];
                    roomViewController.currPeripheral = weakSelf.currPeripheral;
                    roomViewController.characteristic = c;
                    roomViewController.brand = weakSelf.brand;
                    [weakSelf presentViewController:roomViewController animated:YES completion:nil];
                }
                 */
            }
        }
    }];
    
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"read characteristic successfully!");
        
        if([characteristics.UUID.UUIDString isEqualToString:@"FFE1"]){
            weakSelf.characteristic = characteristics;
            weakSelf.currPeripheral = peripheral;
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:peripheral.identifier.UUIDString forKey:@"UUID"];
        [defaults synchronize];
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@NO};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    //设置连接的设备的过滤器
    
     __block BOOL isFirst = YES;
     [baby setFilterOnConnectToPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
     if(isFirst && ([advertisementData[@"kCBAdvDataLocalName"] hasPrefix:@"G29"]|| [advertisementData[@"kCBAdvDataLocalName"] hasPrefix:@"EVA"]||[advertisementData[@"kCBAdvDataLocalName"] hasPrefix:@"GCA"])){
     isFirst = NO;
     return YES;
     }
     return NO;
     }];
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
    NSString *advertiseName = [self.localNames objectAtIndex:indexPath.row];
    [cell.textLabel setText:advertiseName];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [baby.centralManager stopScan];
    [baby cancelAllPeripheralsConnection];
    [baby.centralManager connectPeripheral:[self.devices objectAtIndex:indexPath.row] options:nil];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.viewMusk animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
    self.hud.label.text = @"connect to device.....";
    [self.hud showAnimated:YES];
    
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
