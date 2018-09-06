#import <Cordova/CDV.h>
#import "SbtSdkFactory.h"


@interface ZebraScanner : CDVPlugin

// Reference to the initialised instance
@property id <ISbtSdkApi> api;
// The operation mode to run in on initialisation
@property int mode;
// Allocate an array for storage of a list of available scanners
@property NSMutableArray *availableScanners;
// Allocate an array for storage of a list of active scanners
@property NSMutableArray *activeScanners;
// Allocate a string to contain the event callback id
@property NSString *eventCallbackId;

// Override the initialisation plugin from CDVPlugin
- (void) pluginInitialize;

// - (void) setDelegate:(CDVInvokedUrlCommand*)command;
- (void) getVersion:(CDVInvokedUrlCommand*)command;
- (void) setOperationalMode:(CDVInvokedUrlCommand*)command;
- (void) enableAvailableScannersDetection:(CDVInvokedUrlCommand*)command;
- (void) getAvailableScanners:(CDVInvokedUrlCommand*)command;
- (void) getActiveScanners:(CDVInvokedUrlCommand*)command;
- (void) establishCommunicationSession:(CDVInvokedUrlCommand*)command;
- (void) terminateCommunicationSession:(CDVInvokedUrlCommand*)command;
- (void) enableAutomaticSessionReestablishment:(CDVInvokedUrlCommand*)command;

- (void) sbtEventScannerAppeared:(SbtScannerInfo*)availableScanner;
- (void) sbtEventScannerDisappeared:(int)scannerID;
- (void) sbtEventCommunicationSessionEstablished:(SbtScannerInfo*)activeScanner;
- (void) sbtEventCommunicationSessionTerminated:(int)scannerID;
- (void) sbtEventBarcodeData:(NSData *)barcodeData barcodeType:(int)barcodeType fromScanner:(int)scannerID;
- (void) sbtEventImage:(NSData*)imageData fromScanner:(int)scannerID;
- (void) sbtEventVideo:(NSData*)videoFrame fromScanner:(int)scannerID;
- (void) sbtEventFirmwareUpdate:(FirmwareUpdateEvent*)event;

@end
