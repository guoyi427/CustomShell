//
//  CSBluetoothManager.m
//  CustomShell
//
//  Created by 郭毅 on 16/9/28.
//  Copyright © 2016年 帅毅. All rights reserved.
//

#import "CSBluetoothManager.h"

@interface CSBluetoothManager () <CBCentralManagerDelegate, CBPeripheralDelegate>
{
    CBCentralManager *_centralManager;
    CBPeripheral *_peripheral;
    NSArray *_servicesCache;
    NSMutableArray *_characteristicsCahce;
}
@end

@implementation CSBluetoothManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _peripheralsCache = [[NSMutableDictionary alloc] init];
        _characteristicsCahce = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Public - Methods

- (void)scan {
    if (!_centralManager) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    } else if (![_centralManager isScanning]) {
        [_centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)connectPeripheral:(CBPeripheral *)peripheral {
    [_centralManager connectPeripheral:peripheral options:nil];
    _peripheral = peripheral;
}

#pragma mark - CentralManager - Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"central manager state = %ld", central.state);
    switch (central.state) {
        case CBManagerStateUnknown:
            NSLog(@"central unkonw");
            break;
        case CBManagerStatePoweredOn:
        {
            NSLog(@"central powered on");
            [self scan];
        }
            break;
        case CBManagerStatePoweredOff:
        {
            NSLog(@"central powered off");
        }
            break;
        case CBManagerStateUnsupported:
            NSLog(@"central unsupported");
            break;
        case CBManagerStateResetting:
            NSLog(@"central resetting");
            break;
        case CBManagerStateUnauthorized:
            NSLog(@"central unauthorized");
            break;
            
        default:
            break;
    }
    
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    NSLog(@"willRestoreState %@", dict);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
//    NSLog(@"discover peripheral=%@ rssi=%@ advertisementData=%@", peripheral, RSSI, advertisementData);
    [_peripheralsCache setObject:peripheral forKey:peripheral.identifier.UUIDString];
    if (_delegate && [_delegate respondsToSelector:@selector(bluetoothManager:discoverPeripherals:)]) {
        [_delegate bluetoothManager:self discoverPeripherals:_peripheralsCache.allValues];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"didConnectPeripheral %@", peripheral);
    _peripheral.delegate = self;
    [_peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didFailToConnectPeripheral error = %@", error);
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"didDisconnectPeripheral error%@",error);
}

#pragma mark - Peripheral - Delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"didDiscoverServices %@",peripheral.services);
    _servicesCache = peripheral.services;
    for (CBService *service in _servicesCache) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    NSLog(@"didDiscoverCharacteristicsForService %@", service);
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"%@", characteristic);
    }
    [_characteristicsCahce addObjectsFromArray:service.characteristics];
}

@end
