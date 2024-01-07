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
@property Byte  tempSetting;  //设定温度
@property Byte  tempReal;  //实时温度
@property Byte  mode;  //工作模式
@property Byte  wind;  //风速档位 0-自动 1-4 是手动风速
@property Byte  errorcode;
@property Byte  vhigh;
@property Byte  vlow;
@property Byte  battery;
@property Byte  light;
@property Byte  lock;
@property Byte  crcH;  //CRC 校验高八位
@property Byte  crcL;  //CRC 校验高八位
@property Byte  end;  //通讯结束
@end

NS_ASSUME_NONNULL_END
