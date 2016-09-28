//
//  CSBluetoothManager.h
//  CustomShell
//
//  Created by 郭毅 on 16/9/28.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

@class CSBluetoothManager;
@protocol CSBluetoothManagerDelegate <NSObject>

@optional
- (void)bluetoothManager:(CSBluetoothManager *)manager discoverPeripherals:(NSArray *)peripherals;

@end

@interface CSBluetoothManager : NSObject

@property (nonatomic, strong) NSMutableDictionary *peripheralsCache;
@property (nonatomic, weak) id <CSBluetoothManagerDelegate> delegate;

- (void)scan;
- (void)connectPeripheral:(CBPeripheral *)peripheral;

@end
