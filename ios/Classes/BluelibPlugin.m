#import "BluelibPlugin.h"
#include <Foundation/Foundation.h>

@implementation BluelibPlugin {
  FlutterEventSink _eventSink;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bluelib"
            binaryMessenger:[registrar messenger]];
  FlutterEventChannel* eventChannel = [FlutterEventChannel eventChannelWithName:@"bluelib/events" binaryMessenger:[registrar messenger]];

  BluelibPlugin* instance = [[BluelibPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  [eventChannel setStreamHandler:instance];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    _peripherals = [NSMutableArray array];
  }

  return self;;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"startScan" isEqualToString:call.method]) {
    [self startScan];
    result(nil);
  } else if ([@"stopScan" isEqualToString:call.method]) {
    [self stopScan];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)startScan {
  [_centralManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)stopScan {
  [_centralManager stopScan];

  // if (_eventSink) {
    // _eventSink(@{@"action": @"stopScan"});
  // }
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
  if (central.state == CBManagerStatePoweredOn) {
    NSLog(@"Bluetooth is available");
  } else {
    NSLog(@"Bluetooth is not available");
  }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI {
  NSLog(@"Discovered %@ (%@) at %@", peripheral.name, peripheral.identifier.UUIDString, RSSI);

  double distance = pow(10, (abs(RSSI.intValue) - 59) / (10 * 2.0));
  NSLog(@"Estimated distance: %f meters", distance);

  NSDate *now = [NSDate date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSString *timestamp = [formatter stringFromDate:now];

  // Device info
  // - name: Device name
  // - address: MAC address
  // - rssi: Signal strength
  // - distance: Distance in meters
  // - updated: Last updated timestamp
  NSDictionary *deviceInfo = @{
    @"name": peripheral.name ?: @"Unknown",
    @"address": peripheral.identifier.UUIDString,
    @"rssi": RSSI,
    @"distance": [NSNumber numberWithDouble:distance],
    @"updated_at": timestamp
  };

  if (_eventSink) {
    NSLog(@"Sending event");
    _eventSink(deviceInfo);
  }

  if (![_peripherals containsObject:peripheral]) {
    [_peripherals addObject:peripheral];
  }
}

#pragma mark - FlutterStreamHandler

- (FlutterError* _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(FlutterEventSink)events {
  _eventSink = events;
  return nil;
}

- (FlutterError* _Nullable)onCancelWithArguments:(id _Nullable)arguments {
  _eventSink = nil;
  return nil;
}

@end
