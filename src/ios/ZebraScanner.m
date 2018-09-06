#import "ZebraScanner.h"
#import <Cordova/CDV.h>
#import "SbtSdkFactory.h"
#import "RMDAttributes.h"

@implementation ZebraScanner

@synthesize eventCallbackId; // Hold the javascript event callback method id
@synthesize api; // Hold the instance of SbtSdkFactory used for hardware comms

/* pluginInitialize method
 *
 * Override the CDVPlugin pluginInitialize method to include the setup routine
 * needed to get all events firing correctly within Cordova.
 *
 * first we create a connection to the SbtSdkFactory library and create a conn
 * followed by setting the delegate (using sbtSetDelegate) to self. All the
 * callbacks will then be executed within this instance.
 *
 * Then we create the notification mask enabling all events to be triggered.
 */
- (void) pluginInitialize
{
    // Initialise the API
    self.api = [SbtSdkFactory createSbtSdkApiInstance];

    // Enable events to be delegated to the methods in this class
    [self.api sbtSetDelegate:(id)self];

    // Create the notification mask enabling all events to be triggered
    int notifications_mask = 0;
    notifications_mask |= (SBT_EVENT_SCANNER_APPEARANCE | SBT_EVENT_SCANNER_DISAPPEARANCE);
    notifications_mask |= (SBT_EVENT_SESSION_ESTABLISHMENT | SBT_EVENT_SESSION_TERMINATION);
    notifications_mask |= (SBT_EVENT_BARCODE);
    notifications_mask |= (SBT_EVENT_IMAGE);
    notifications_mask |= (SBT_EVENT_VIDEO);
    notifications_mask |= (SBT_EVENT_RAW_DATA);

    // Set the operation mode and enable all events
    // TODO: Need to read the operation mode from a property defined on initialization
    // [self.api sbtSetOperationalMode:self.mode];
    [self.api sbtSubsribeForEvents:notifications_mask];
    [self.api sbtSetOperationalMode:SBT_OPMODE_ALL];
    [self.api sbtEnableAvailableScannersDetection:true];

    // Store the list of available scanners
    self.availableScanners = [[NSMutableArray alloc] init];
    // Store the list of active scanners
    self.activeScanners = [[NSMutableArray alloc] init];
    // Clear event callback id
    self.eventCallbackId = NULL;
}

/* getVersion method
 *
 * Get the version of the sbtSdkFactory API. The resulting value gets returned
 * using Cordovas pluginResult Object passed back to javascript calling the
 * commandDelegate method. 
 *
 * @return void
 */
- (void) getVersion:(CDVInvokedUrlCommand*)command
{
    // Run in a background thread
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* result = nil;

        // Get the SDK version string
        NSString *version = [self.api sbtGetVersion];

        // Return the result to the calling js method
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:version];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

/* setOperationalMode method
 *
 * Configures the operating mode of the SDK to decide which type of devices to
 * detect. This can generally be untouched as the default os SBT_OPMODE_ALL.
 *
 * SBT_OPMODE_MFI :  1 = Communicate with scanners in "iOS BT MFi" mode only.
 * SBT_OPMODE_BTLE : 2 = Communicate with scanners in "iOS BT LE" mode only.
 * SBT_OPMODE_ALL :  3 = Communicate with scanners in "iOS BT MFi" mode and with scanners in "iOS BT LE" mode.
 */
- (void) setOperationalMode:(CDVInvokedUrlCommand*)command
{
    // Read the mode from the command arguments array
    NSNumber *mode = [command.arguments objectAtIndex:0];

    // Run in a background thread
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* result = nil;

        // If no value has been passed in, return an error else create the CDVPluginResult Object
        if (mode == nil) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        } else {
            SBT_RESULT status = [self.api sbtSetOperationalMode:mode.intValue];

            // If the api call status returns with a zero, return success else return the error
            if (status == 0) {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:status];
            } else {
                result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
            }
        }

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

/* enableAvailableScannersDetection method
 *
 * Enable or disable scanner detection. Please ensure you disable detection to
 * reduce battery usage and reduce the risk of data leakage.
 *
 * SETDEFAULT_YES : 0 = Set default yes.
 * SETDEFAULT_NO :  1 = Set default no.
 */
- (void) enableAvailableScannersDetection:(CDVInvokedUrlCommand*)command
{
    // Read the mode from the command arguments array and convert to a Boolean
    BOOL enable = [command.arguments objectAtIndex:0]!=0;

    // Run in a background thread
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* result = nil;

        SBT_RESULT status = [self.api sbtEnableAvailableScannersDetection:enable];

        // If the api call status returns with a zero, return success else return the error
        if (status == 0) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:status];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
        }

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

/* getAvailableScanners method
 *
 * Get the list of all available scanners found via bluetooth. When we get a
 * result back from the API, we loop through the list of available scanners to
 * convert the object type to a dictionary. This is in order to handle the way
 * that the JSON generator works (it does not allow custom object types).
 *
 * For more information about what the NSNumbers represent, please refer to the
 * javascript file constants
 *
 * scannerID: NSNumber
 * connectionType: NSNumber (Scanner Modes in zebrascanner.js)
 * autoCommunicationSessionReestablishment: NSNumber
 * active: NSNumber
 * available: NSNumber
 * model: NSNumber (Scanner Models in zebrascanner.js)
 */
- (void) getAvailableScanners:(CDVInvokedUrlCommand*)command
{
    // Run in a background thread
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* result = nil;
        NSMutableArray *available = [[NSMutableArray alloc] init];
        NSMutableArray *scanners = [[NSMutableArray alloc] init];

        SBT_RESULT status = [self.api sbtGetAvailableScannersList:&available];
        self.availableScanners = available;

        // If the api call status returns with a zero, return success else return the error
        if (status == 0) {
            
            // return an array of dictionaries with some of the parameters of SbtScannerInfo
            for (SbtScannerInfo *scannerObj in available) {
                NSMutableDictionary *scanner = [[NSMutableDictionary alloc] init];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj getScannerID]] forKey:@"scannerID"];
                [scanner setObject:[NSString stringWithFormat:@"%@",[scannerObj getScannerName]] forKey:@"name"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj getConnectionType]] forKey:@"connectionType"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj getAutoCommunicationSessionReestablishment]] forKey:@"autoCommunicationSessionReestablishment"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj isActive]] forKey:@"active"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj isAvailable]] forKey:@"available"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj getScannerModel]] forKey:@"model"];
                [scanners addObject:scanner];
            }
            
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:scanners];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
        }

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

/* getActiveScanners method
 *
 * Get the list of all active scanners found via bluetooth. When we get a
 * result back from the API, we loop through the list of active scanners to
 * convert the object type to a dictionary. This is in order to handle the way
 * that the JSON generator works (it does not allow custom object types).
 *
 * For more information about what the NSNumbers represent, please refer to the
 * javascript file constants
 *
 * scannerID: NSNumber
 * connectionType: NSNumber (Scanner Modes in zebrascanner.js)
 * autoCommunicationSessionReestablishment: NSNumber
 * active: NSNumber
 * available: NSNumber
 * model: NSNumber (Scanner Models in zebrascanner.js)
 */
- (void) getActiveScanners:(CDVInvokedUrlCommand*)command
{
    // Run in a background thread
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* result = nil;
        NSMutableArray *active = [[NSMutableArray alloc] init];
        NSMutableArray *scanners = [[NSMutableArray alloc] init];

        SBT_RESULT status = [self.api sbtGetActiveScannersList:&active];
        self.activeScanners = active;

        // If the api call status returns with a zero, return success else return the error
        if (status == 0) {

            // return an array of dictionaries with some of the parameters of SbtScannerInfo
            for (SbtScannerInfo *scannerObj in active) {
                NSMutableDictionary *scanner = [[NSMutableDictionary alloc] init];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj getScannerID]] forKey:@"scannerID"];
                [scanner setObject:[NSString stringWithFormat:@"%@",[scannerObj getScannerName]] forKey:@"name"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj getConnectionType]] forKey:@"connectionType"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj getAutoCommunicationSessionReestablishment]] forKey:@"autoCommunicationSessionReestablishment"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj isActive]] forKey:@"active"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj isAvailable]] forKey:@"available"];
                [scanner setObject:[NSNumber numberWithInt:[scannerObj getScannerModel]] forKey:@"model"];
                [scanners addObject:scanner];
            }

            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:scanners];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
        }

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}

/* establishCommunicationSession method
 *
 * When provided with a valid scanner id, establish a connection to the scanner
 * A scanner id needs to be used from the AvailableScanners list and once it is
 * established, the device will be returned in the active list.
 */
- (void) establishCommunicationSession:(CDVInvokedUrlCommand*)command
{
    // Read the scanner id from the command arguments array
    NSNumber *scanner = [command.arguments objectAtIndex:0];

    // Run in a background thread
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;

        // If no value has been passed in, return an error else create the CDVPluginResult Object
        if (scanner == nil) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        } else {
            SBT_RESULT result = [self.api sbtEstablishCommunicationSession:scanner.intValue];

            // If the api call status returns with a zero, return success else return the error
            if (result == 0) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:result];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:result];
            }
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

/* terminateCommunicationSession method
 *
 * When provided with a valid scanner id, terminates the connection to the
 * scanner. A valid scanner ID needs to be provided from the ActiveScanners
 * list, and once terminated, will show up in AvailableScanners list.
 */
- (void) terminateCommunicationSession:(CDVInvokedUrlCommand*)command
{
    // Read the scanner id from the command arguments array
    NSNumber *scanner = [command.arguments objectAtIndex:0];

    // Run in a background thread
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* pluginResult = nil;

        // If no value has been passed in, return an error else create the CDVPluginResult Object
        if (scanner == nil) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
        } else {
            SBT_RESULT result = [self.api sbtTerminateCommunicationSession:scanner.intValue];
            
            // If the api call status returns with a zero, return success else return the error
            if (result == 0) {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:result];
            } else {
                pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:result];
            }
        }
        
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

/* enableAutomaticSessionReestablishment method
 *
 * Enable or disable scanner automatic reconnection.
 *
 * SETDEFAULT_YES : 0 = Set default yes.
 * SETDEFAULT_NO :  1 = Set default no.
 */
- (void) enableAutomaticSessionReestablishment:(CDVInvokedUrlCommand*)command
{
    // Read the mode from the command arguments array and convert to a Boolean
    BOOL enable = [command.arguments objectAtIndex:0]!=0;
    NSNumber *scanner_p = [command.arguments objectAtIndex:1];
    int scanner = scanner_p.intValue;

    // Run in a background thread
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* result = nil;
        SBT_RESULT status = [self.api sbtEnableAutomaticSessionReestablishment:enable forScanner: scanner];

        // If the api call status returns with a zero, return success else return the error
        if (status == 0) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:status];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsInt:status];
        }

        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }];
}


/* registerEventHandler method
 *
 * Register the event handler method that will be used within javascript. The
 * gets called on each event with an eventType parameter defined. This reduces
 * the quantity of wrapper method needed.
 */
- (void) registerEventHandler:(CDVInvokedUrlCommand*)command
{
    self.eventCallbackId = command.callbackId;
}

/* sbtEventScannerAppeared method
 *
 * TODO: Write description here
 *
 * For more information about what the NSNumbers represent, please refer to the
 * javascript file constants
 *
 * eventType: NSString (sbtEventScannerAppeared)
 * scannerID: NSNumber
 * connectionType: NSNumber (Scanner Modes in zebrascanner.js)
 * autoCommunicationSessionReestablishment: NSNumber
 * active: NSNumber
 * available: NSNumber
 * model: NSNumber (Scanner Models in zebrascanner.js)
 */
- (void) sbtEventScannerAppeared:(SbtScannerInfo*)availableScanner
{
    NSLog(@"sbtEventScannerAppeared - : %d\n", [availableScanner getScannerID]);

    CDVPluginResult* result = nil;
    NSMutableDictionary *scanner = [[NSMutableDictionary alloc] init];
    [scanner setObject:@"sbtEventScannerAppeared" forKey:@"eventType"];
    [scanner setObject:[NSNumber numberWithInt:[availableScanner getScannerID]] forKey:@"scannerID"];
    [scanner setObject:[NSString stringWithFormat:@"%@",[availableScanner getScannerName]] forKey:@"name"];
    [scanner setObject:[NSNumber numberWithInt:[availableScanner getConnectionType]] forKey:@"connectionType"];
    [scanner setObject:[NSNumber numberWithInt:[availableScanner getAutoCommunicationSessionReestablishment]] forKey:@"autoCommunicationSessionReestablishment"];
    [scanner setObject:[NSNumber numberWithInt:[availableScanner isActive]] forKey:@"active"];
    [scanner setObject:[NSNumber numberWithInt:[availableScanner isAvailable]] forKey:@"available"];
    [scanner setObject:[NSNumber numberWithInt:[availableScanner getScannerModel]] forKey:@"model"];
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:scanner];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:eventCallbackId];
}

/* sbtEventScannerDisappeared method
 *
 * TODO: Write description here
 *
 * eventType: NSString (sbtEventScannerDisappeared)
 * scannerID: NSNumber
 */
- (void) sbtEventScannerDisappeared:(int)scannerID;
{
    NSLog(@"sbtEventScannerDisappeared - : %d\n", scannerID);

    CDVPluginResult* result = nil;
    NSMutableDictionary *scanner = [[NSMutableDictionary alloc] init];
    [scanner setObject:@"sbtEventScannerDisappeared" forKey:@"eventType"];
    [scanner setObject:[NSNumber numberWithInt:scannerID] forKey:@"scannerID"];
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:scanner];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:eventCallbackId];
}

/* sbtEventCommunicationSessionEstablished method
 *
 * TODO: Write description here
 *
 * For more information about what the NSNumbers represent, please refer to the
 * javascript file constants
 *
 * eventType: NSString (sbtEventCommunicationSessionEstablished)
 * scannerID: NSNumber
 * connectionType: NSNumber (Scanner Modes in zebrascanner.js)
 * autoCommunicationSessionReestablishment: NSNumber
 * active: NSNumber
 * available: NSNumber
 * model: NSNumber (Scanner Models in zebrascanner.js)
 */
- (void) sbtEventCommunicationSessionEstablished:(SbtScannerInfo*)activeScanner;
{
    NSLog(@"sbtEventCommunicationSessionEstablished - : %d\n", activeScanner.getScannerID);

    CDVPluginResult* result = nil;
    NSMutableDictionary *scanner = [[NSMutableDictionary alloc] init];
    [scanner setObject:@"sbtEventCommunicationSessionEstablished" forKey:@"eventType"];
    [scanner setObject:[NSNumber numberWithInt:[activeScanner getScannerID]] forKey:@"scannerID"];
    [scanner setObject:[NSString stringWithFormat:@"%@",[activeScanner getScannerName]] forKey:@"name"];
    [scanner setObject:[NSNumber numberWithInt:[activeScanner getConnectionType]] forKey:@"connectionType"];
    [scanner setObject:[NSNumber numberWithInt:[activeScanner getAutoCommunicationSessionReestablishment]] forKey:@"autoCommunicationSessionReestablishment"];
    [scanner setObject:[NSNumber numberWithInt:[activeScanner isActive]] forKey:@"active"];
    [scanner setObject:[NSNumber numberWithInt:[activeScanner isAvailable]] forKey:@"available"];
    [scanner setObject:[NSNumber numberWithInt:[activeScanner getScannerModel]] forKey:@"model"];
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:scanner];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:eventCallbackId];
}

/* sbtEventCommunicationSessionTerminated method
 *
 * TODO: Write description here
 *
 * eventType: NSString (sbtEventCommunicationSessionTerminated)
 * scannerID: NSNumber
 */
- (void) sbtEventCommunicationSessionTerminated:(int)scannerID;
{
    NSLog(@"sbtEventCommunicationSessionTerminated - : %d\n", scannerID);

    CDVPluginResult* result = nil;
    NSMutableDictionary *scanner = [[NSMutableDictionary alloc] init];
    [scanner setObject:@"sbtEventCommunicationSessionTerminated" forKey:@"eventType"];
    [scanner setObject:[NSNumber numberWithInt:scannerID] forKey:@"scannerID"];
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:scanner];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:eventCallbackId];
}

/* sbtEventBarcodeData method
 *
 * TODO: Write description here
*
 * For more information about what the NSNumbers represent, please refer to the
 * javascript file constants
 *
 * eventType: NSString (sbtEventBarcodeData)
 * scannerID: NSNumber
 * barcodeData: NSString
 * BarcodeType: NSNumber (STC Bar Code Types in zebrascanner.js)
 */
- (void) sbtEventBarcodeData:(NSData *)barcodeData barcodeType:(int)barcodeType fromScanner:(int)scannerID;
{
    NSLog(@"sbtEventBarcodeData - : %d %@\n", scannerID, barcodeData);

    CDVPluginResult* result = nil;
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:@"sbtEventBarcodeData" forKey:@"eventType"];
    [data setObject:[NSNumber numberWithInt:scannerID] forKey:@"scannerID"];
    [data setObject:[NSNumber numberWithInt:barcodeType] forKey:@"barcodeType"];
    [data setObject:[[NSString alloc] initWithData:barcodeData encoding:NSASCIIStringEncoding] forKey:@"barcodeData"];
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:data];
    [result setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:result callbackId:eventCallbackId];
}

/* sbtEventImage method
 *
 * Returns a image from the scanner.
 *
 * TODO: Still needs to be implemented
 */
- (void) sbtEventImage:(NSData*)imageData fromScanner:(int)scannerID;
{
    NSLog(@"sbtEventImage - : %d\n", scannerID);
}

/* sbtEventVideo method
 *
 * Returns live video from the scanner.
 *
 * TODO: Still needs to be implemented
 */
- (void) sbtEventVideo:(NSData*)videoFrame fromScanner:(int)scannerID;
{
    NSLog(@"sbtEventVideo - : %d\n", scannerID);
}

/* sbtEventFirmwareUpdate method
 *
 * Returns the state of a firmware update.
 *
 * TODO: Still needs to be implemented
 */
- (void) sbtEventFirmwareUpdate:(FirmwareUpdateEvent*)event;
{
    NSLog(@"sbtEventFirmwareUpdate - : %@\n", event);
}

@end
