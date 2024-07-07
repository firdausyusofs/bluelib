#import <Flutter/Flutter.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BluelibPlugin : NSObject<FlutterPlugin, CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableArray *peripherals;

@end
