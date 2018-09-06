var CONSTANTS = {
    /**
     * Result Codes
     * @name Basic These constants are defined to represent result codes that can be returned by SDK API functions.
     * * @{
    */
    SBT_RESULT_SUCCESS :                        0,      // API function has completed successfully
    SBT_RESULT_FAILURE :                        1,      // API function has completed unsuccessfully
    SBT_RESULT_SCANNER_NOT_AVAILABLE :          2,      // API function has completed unsuccessfully because a specified scanner was not available.
    SBT_RESULT_SCANNER_NOT_ACTIVE :             3,      // API function has completed unsuccessfully because a specified scanner was not active.
    SBT_RESULT_INVALID_PARAMS :                 4,      // API function has completed unsuccessfully due to invalid input and/or output parameters.
    SBT_RESULT_RESPONSE_TIMEOUT :               5,      // API function has completed unsuccessfully due to expiration of a response timeout during communication with a specific scanner.
    SBT_RESULT_OPCODE_NOT_SUPPORTED :           6,      // API function has completed unsuccessfully due to unsupported opcode.
    SBT_RESULT_SCANNER_NO_SUPPORT :             7,      // API function and/or a corresponding SSI command are not supported by a specific model of scanner.

    /**
     * Operating Modes
     * @brief  These constants are defined to represent operating modes of the Zebra Scanner SDK for iOS.
    */
    SBT_OPMODE_MFI :                            1,      // Communicate with scanners in "iOS BT MFi" mode only.
    SBT_OPMODE_BTLE :                           2,      // Communicate with scanners in "iOS BT LE" mode only.
    SBT_OPMODE_ALL :                            3,      // Communicate with scanners in "iOS BT MFi" mode and with scanners in "iOS BT LE" mode.

    /**
     * Scanner Modes
     * @brief These constants are defined to represent communication modes of scanners.
    */
    SBT_CONNTYPE_INVALID :                      0,      // Unable to determine communication mode of a specific scanner.
    SBT_CONNTYPE_MFI :                          1,      // A specific scanner is in "iOS BT MFi" mode.
    SBT_CONNTYPE_BTLE :                         2,      // A specific scanner is in "iOS BT LE" mode.

    /**
     * Notifications
     * @brief  These constants are defined to represent notifications provided by Zebra Scanner SDK for iOS.
    */
    SBT_EVENT_BARCODE :                         1,      // "Barcode event" notification (reception of a specific bar code of specific type from a specific active scanner).
    SBT_EVENT_IMAGE :                           2,      // "Image event" notification (triggered when an imaging scanner captures images in image mode).
    SBT_EVENT_VIDEO :                           4,      // "Video event" notification (triggered when an imaging scanner captures video in video mode).
    SBT_EVENT_SCANNER_APPEARANCE :              8,      // "Device Arrival" notification (appearance of an available scanner).
    SBT_EVENT_SCANNER_DISAPPEARANCE :           16,     // "Device Disappeared" notification (disappearance of an available scanner).
    SBT_EVENT_SESSION_ESTABLISHMENT :           32,     // "Session Established" notification (appearance of a specific active scanner).
    SBT_EVENT_SESSION_TERMINATION :             64,     // "Session Terminated" notification (disappearance of an active scanner).
    SBT_EVENT_RAW_DATA :                        128,    // "Raw Data Received" notification (reception of raw data from a specific active scanner in "raw data pipe" mode).

    /**
     * Opcodes
     * @brief  These constants are defined to represent opcodes of methods supported by "Execute Command" API function.
    */
    SBT_DEVICE_PULL_TRIGGER :                   2011,      // Opcode of DEVICE_PULL_TRIGGER method of the "Execute Command" API.
    SBT_DEVICE_RELEASE_TRIGGER :                2012,      // Opcode of DEVICE_RELEASE_TRIGGER method of the "Execute Command" API.
    SBT_DEVICE_CAPTURE_IMAGE :                  3000,      // Opcode of DEVICE_CAPTURE_IMAGE method of the "Execute Command" API.
    SBT_DEVICE_CAPTURE_VIDEO :                  4000,      // Opcode of DEVICE_CAPTURE_VIDEO method of the "Execute Command" API.
    SBT_DEVICE_CAPTURE_BARCODE :                3500,      // Opcode of DEVICE_CAPTURE_BARCODE method of the "Execute Command" API.
    SBT_DEVICE_SCAN_ENABLE  :                   2014,      // Opcode of SCAN_ENABLE method of the "Execute Command" API.
    SBT_DEVICE_SCAN_DISABLE :                   2013,      // Opcode of SCAN_DISABLE method of the "Execute Command" API.
    SBT_SET_ACTION :                            6000,      // Opcode of SET_ACTION method of the "Execute Command" API.
    SBT_RSM_ATTR_GETALL :                       5000,      // Opcode of ATTR_GETALL method of the "Execute Command" API.
    SBT_RSM_ATTR_GET :                          5001,      // Opcode of ATTR_GET method of the "Execute Command" API.
    SBT_RSM_ATTR_GET_OFFSET :                   5003,      // Opcode of ATTR_GET_OFFSET method of the "Execute Command" API.
    SBT_RSM_ATTR_SET :                          5004,      // Opcode of ATTR_SET method of the "Execute Command" API.
    SBT_RSM_ATTR_STORE :                        5005,      // Opcode of ATTR_STORE method of the "Execute Command" API.

    /**
     * Scanner Models
     * @brief  These constants are defined to represent models of scanners supported by Zebra Scanner SDK for iOS.
    */
    SBT_DEVMODEL_INVALID :                      0,      // The model either unknown, not recognized or not supported.
    SBT_DEVMODEL_SSI_RFD8500 :                  1,      // RFD8500 in SSI Imager mode.
    SBT_DEVMODEL_SSI_CS4070 :                   2,      // CS4070 scanner.
    SBT_DEVMODEL_SSI_GENERIC :                  3,      // Generic SSI imager.
    SBT_DEVMODEL_RFID_RFD8500 :                 4,      // RFD8500 in RFID reader mode.

    /**
     * LED Codes
     * @brief  These constants are defined to represent LED codes supported by "LED Control" API function.
    */
    SBT_LEDCODE_RED :                           0,      // Red LED.
    SBT_LEDCODE_GREEN :                         1,      // Green LED.
    SBT_LEDCODE_YELLOW :                        2,      // Yellow LED.
    SBT_LEDCODE_AMBER :                         3,      // Amber LED.
    SBT_LEDCODE_BLUE :                          4,      // Blue LED.

    /**
     * Beep Codes
     * @brief  These constants are defined to represent beep codes supported by "Beep Control" API function.
    */

    /**
     * Firmware Update Result Codes
    */
    SBT_FW_UPDATE_RESULT_SUCCESS :              0,      // Firmware update API call succeeded.
    SBT_FW_UPDATE_RESULT_FAILURE :              1,      // Firmware update API call failed.

    /**
     * STC Bar Code Types
    */
    BARCODE_TYPE_LEGACY :                       0,      // Legacy bar code type.
    BARCODE_TYPE_STC :                          1,      // STC 2.0 bar code type.

    /**
     * STC Communication Protocol
    */
    STC_SSI_MFI :                               0,      // SSI over MFI.
    STC_SSI_BLE :                               1,      // SSI over Bluetooth low energy.
    SBT_SSI_HID :                               2,      // SSI over HID.
    NO_COM_PROTOCOL :                           3,      // No communication protocol.

    /**
     * Set Default Status
    */
    SETDEFAULT_YES :                            0,      // Set default yes.
    SETDEFAULT_NO :                             1,      // Set default no.

    /**
     * Messages for the return codes
     * 
    */
    REGMESSAGES : {
        "0"  : 'Registration OK',
        "-1" : 'Registration Invalid Key',
        "-2" : 'Registration Invalid Checksum',
        "-3" : 'Registration Invalid Application',
        "-4" : 'Registration Invalid SDK Version',
        "-5" : 'Registration Invalid Key Version',
        "-6" : 'Registration Invalid Platform',
        "-7" : 'Registration Key Expired',
    },
};

/**
 * This represents the Zebra API instance used to scan for instances of
 * bluetooth barcode scanners.
 * 
 * @constructor
 */
function Zebra () {
    this.version = null;
    var self = this;
    this._registerEventHandler();
}

/**
 *  @name getConstants
 *  @description : exposes the contants of the scanner so we can use them when calling configuration functions
**/
Zebra.prototype.getConstants = function() {
    return CONSTANTS;
}

/**
 *  @name getVersion
 *  @description : returns the version of the API used for development
**/
Zebra.prototype._getVersion = function(success, failure) {
    cordova.exec(success, failure, "ZebraScanner", "getVersion", []);
}

Zebra.prototype.getVersion = function() {
    var self = this;
    return new Promise(function(resolve, reject) {
        self._getVersion(resolve, reject);
    });
}

/**
 *  @name setOperationalMode
 *  @description : sets the operational mode of the API
**/
Zebra.prototype._setOperationalMode = function(mode, success, failure) {
    cordova.exec(success, failure, "ZebraScanner", "setOperationalMode", [mode]);
}

Zebra.prototype.setOperationalMode = function(mode) {
    var self = this;
    return new Promise(function(resolve, reject) {
        self._setOperationalMode(mode, resolve, reject);
    });
}

/**
 *  @name enableAvailableScannersDetection
 *  @description : Requests to enable/disable "Available scanners detection" option.
**/
Zebra.prototype._enableAvailableScannersDetection = function(enable, success, failure) {
    cordova.exec(success, failure, "ZebraScanner", "enableAvailableScannersDetection", [enable]);
}

Zebra.prototype.enableAvailableScannersDetection = function(enable) {
    var self = this;
    return new Promise(function(resolve, reject) {
        self._enableAvailableScannersDetection(enable, resolve, reject);
    });
}

/**
 *  @name getAvailableScanners
 *  @description : Requests to enable/disable "Available scanners detection" option.
**/
Zebra.prototype._getAvailableScanners = function(success, failure) {
    cordova.exec(success, failure, "ZebraScanner", "getAvailableScanners", []);
}

Zebra.prototype.getAvailableScanners = function() {
    var self = this;
    return new Promise(function(resolve, reject) {
        self._getAvailableScanners(resolve, reject);
    });
}

/**
 *  @name getActiveScanners
 *  @description : Requests to enable/disable "Available scanners detection" option.
**/
Zebra.prototype._getActiveScanners = function(success, failure) {
    cordova.exec(success, failure, "ZebraScanner", "getActiveScanners", []);
}

Zebra.prototype.getActiveScanners = function() {
    var self = this;
    return new Promise(function(resolve, reject) {
        self._getActiveScanners(resolve, reject);
    });
}

/**
 *  @name establishCommunicationSession
 *  @description : Requests to enable/disable "Available scanners detection" option.
**/
Zebra.prototype._establishCommunicationSession = function(scanner, success, failure) {
    cordova.exec(success, failure, "ZebraScanner", "establishCommunicationSession", [scanner]);
}

Zebra.prototype.establishCommunicationSession = function(scanner) {
    var self = this;
    return new Promise(function(resolve, reject) {
        self._establishCommunicationSession(scanner, resolve, reject);
    });
}

/**
 *  @name terminateCommunicationSession
 *  @description : Requests to scanner/disable "Available scanners detection" option.
**/
Zebra.prototype._terminateCommunicationSession = function(scanner, success, failure) {
    cordova.exec(success, failure, "ZebraScanner", "terminateCommunicationSession", [scanner]);
}

Zebra.prototype.terminateCommunicationSession = function(scanner) {
    var self = this;
    return new Promise(function(resolve, reject) {
        self._terminateCommunicationSession(scanner, resolve, reject);
    });
}

/**
 *  @name enableAutomaticSessionReestablishment
 *  @description : Requests to enable/disable "Automatic Session Reestablishment" option.
**/
Zebra.prototype._enableAutomaticSessionReestablishment = function(enable, scanner, success, failure) {
    cordova.exec(success, failure, "ZebraScanner", "enableAutomaticSessionReestablishment", [enable, scanner]);
}

Zebra.prototype.enableAutomaticSessionReestablishment = function(enable, scanner) {
    var self = this;
    return new Promise(function(resolve, reject) {
        self._enableAutomaticSessionReestablishment(enable, scanner, resolve, reject);
    });
}

/**
 *  @name _registerEventHandler
 *  @description : Requests to scanner/disable "Available scanners detection" option.
**/
Zebra.prototype._registerEventHandler = function() {
    cordova.exec(this._dispatch, {}, "ZebraScanner", "registerEventHandler");
}

// - (void) sbtEventScannerAppeared:(SbtScannerInfo*)availableScanner;
Zebra.prototype.eventScannerAppeared = function(scanner) {
    cordova.fireDocumentEvent('zebra.scannerAppeared', { detail:
        { scanner: scanner }
    });
}

// - (void) sbtEventScannerDisappeared:(int)scannerID;
Zebra.prototype.ZebraScannerDisappeared = function(scannerID) {
    cordova.fireDocumentEvent('zebra.scannerDisappeared', { detail: { scannerID: scannerID }});
}

// - (void) sbtEventCommunicationSessionEstablished:(SbtScannerInfo*)activeScanner;
Zebra.prototype.ZebraCommunicationSessionEstablished = function(scannerID) {
    cordova.fireDocumentEvent('zebra.communicationSessionEstablished', { detail: { scannerID: scannerID }});
}

// - (void) sbtEventCommunicationSessionTerminated:(int)scannerID;
Zebra.prototype.ZebraCommunicationSessionTerminated = function(scannerID) {
    cordova.fireDocumentEvent('zebra.communicationSessionTerminated', { detail: { scannerID: scannerID }});
}

// - (void) sbtEventBarcodeData:(NSData *)barcodeData barcodeType:(int)barcodeType fromScanner:(int)scannerID;
Zebra.prototype.ZebraBarcodeData = function(data) {
    cordova.fireDocumentEvent('zebra.barcodeData', { detail: {
        barcodeData: data['barcodeData'],
        barcodeType: data['barcodeType'],
        scannerID: data['scannerID']
    } });
}

// - (void) sbtEventImage:(NSData*)imageData fromScanner:(int)scannerID;
Zebra.prototype.ZebraImage = function(scannerID) {
    cordova.fireDocumentEvent('Zebra.image', { detail: {
        data: imageData,
        scanner: fromScanner
    } });
}

// - (void) sbtEventVideo:(NSData*)videoFrame fromScanner:(int)scannerID;
Zebra.prototype.ZebraVideo = function(scannerID) {
    cordova.fireDocumentEvent('Zebra.video', { detail: {
        data: videoFrame,
        scanner: fromScanner
    } });
}

// - (void) sbtEventFirmwareUpdate:(FirmwareUpdateEvent*)event;
Zebra.prototype.ZebraFirmwareUpdate = function(scannerID) {
    cordova.fireDocumentEvent('Zebra.firmwareUpdate', { detail: {event: event} });
}

Zebra.prototype._dispatch = function(result) {
    switch(result['eventType']) {
        case 'sbtEventScannerAppeared':
            Zebra.prototype.eventScannerAppeared(result);
            break;
        case 'sbtEventScannerDisappeared':
            Zebra.prototype.ZebraScannerDisappeared(result);
            break;
        case 'sbtEventCommunicationSessionEstablished':
            Zebra.prototype.ZebraCommunicationSessionEstablished(result);
            break;
        case 'sbtEventCommunicationSessionTerminated':
            Zebra.prototype.ZebraCommunicationSessionTerminated(result);
            break;
        case 'sbtEventBarcodeData':
            Zebra.prototype.ZebraBarcodeData(result);
            break;
    }
}

module.exports = new Zebra();
