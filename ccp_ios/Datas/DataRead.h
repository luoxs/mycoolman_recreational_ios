//
//  DataRead.h
//  MyCoolMan
//
//  Created by 罗路雅 on 2023/1/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataRead : NSObject
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
@end
NS_ASSUME_NONNULL_END

/*
 0    0X55    通讯开始
 1    0x00-0x01    0x01:开机 0x00:关机
 2    0X00-0xff    设定制冷温度
 3    0x00-0xff    实时制冷温度或加热温度
 4    0x00-0xff    冷冻箱设定温度 （双温区冰箱才有效，单温区冰箱忽略该数据）
 5    0x00-0xff    冷冻箱实时温度 （双温区冰箱才有效，单温区冰箱忽略该数据）
 6    0x00-0x01    TURBOM模式 0X00-ECO  0X01-TURBO
 7    0x00-0x01    加热或制冷模式 0X00-制冷模式 0X01-加热模式（单冷冰箱没有此值）
 8    0X00-0X02    电池保护设置 0-低档 1-中档 2-高档
 9    0x00-0x01    温度单温 0-华氏度 1-摄氏度
 10    0x00-0x01    工作状态  0-停机 1-工作
 11    0X00-0XFF    故障代码
 12    0x00-0XFF    电压高八位
 13    0X00-0XFF    电压低八位
 14    0x00-0xff    GC单温冰箱 固定0x03
 15    0x00-0xff    加热设定温度
 16    0X00-0X03    定时关机时间
 17    0X00-0XFF    备用
 18    0X00-0XFF    备用
 19    0x00-0xff    CRC校验高八位
 20    0x00-0xff    CRC校验低八位
 21    0xaa    通讯结束

 */
