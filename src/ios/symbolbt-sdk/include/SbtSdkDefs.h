/******************************************************************************
 *
 *       Copyright Zebra Technologies Corporation. 2013 - 2015
 *
 *       The copyright notice above does not evidence any
 *       actual or intended publication of such source code.
 *       The code contains Zebra Technologies
 *       Confidential Proprietary Information.
 *
 *
 *  Description:   SbtSdkDefs.h
 *
 *  Notes:
 *
 ******************************************************************************/

#ifndef _SBT_SDK_DEFS_
#define _SBT_SDK_DEFS_

/* return values */
typedef enum {
    SBT_RESULT_SUCCESS                   = 0x00,
    SBT_RESULT_FAILURE                   = 0x01,
    SBT_RESULT_SCANNER_NOT_AVAILABLE     = 0x02,
    SBT_RESULT_SCANNER_NOT_ACTIVE        = 0x03,
    SBT_RESULT_INVALID_PARAMS            = 0x04,
    SBT_RESULT_RESPONSE_TIMEOUT          = 0x05,
    SBT_RESULT_OPCODE_NOT_SUPPORTED      = 0x06,
    SBT_RESULT_SCANNER_NO_SUPPORT        = 0x07,
    SBT_RESULT_BTADDRESS_NOT_SET         = 0x08,
    SBT_RESULT_SCANNER_NOT_CONNECT_STC   = 0x09
} SBT_RESULT;

/* operating modes of SDK */
enum {
    SBT_OPMODE_MFI                       = 0x01,
    SBT_OPMODE_BTLE                      = 0x02,
    SBT_OPMODE_ALL                       = 0x03
};

/* connection/scanner types */
enum {
    SBT_CONNTYPE_INVALID                 = 0x00,
    SBT_CONNTYPE_MFI                     = 0x01,
    SBT_CONNTYPE_BTLE                    = 0x02
};

/* notifications/events masks */
enum {
    SBT_EVENT_BARCODE                    = (0x01),
    SBT_EVENT_IMAGE                      = (0x01 << 1),
    SBT_EVENT_VIDEO                      = (0x01 << 2),
    SBT_EVENT_SCANNER_APPEARANCE         = (0x01 << 3),
    SBT_EVENT_SCANNER_DISAPPEARANCE      = (0x01 << 4),
    SBT_EVENT_SESSION_ESTABLISHMENT      = (0x01 << 5),
    SBT_EVENT_SESSION_TERMINATION        = (0x01 << 6),
    SBT_EVENT_RAW_DATA                   = (0x01 << 7)
};

/* supported device models */
enum {
    SBT_DEVMODEL_INVALID                 = 0x00,
    SBT_DEVMODEL_SSI_RFD8500             = 0x01,
    SBT_DEVMODEL_SSI_CS4070              = 0x02,
    SBT_DEVMODEL_SSI_LI3678              = 0x03,
    SBT_DEVMODEL_SSI_DS3678              = 0x04,
    SBT_DEVMODEL_SSI_DS8178              = 0x05,
    SBT_DEVMODEL_SSI_DS2278              = 0x06,
    SBT_DEVMODEL_SSI_GENERIC             = 0x07,
    SBT_DEVMODEL_RFID_RFD8500            = 0x08
};

/* supported LED codes */
enum {
    SBT_LEDCODE_RED                      = 0x00,
    SBT_LEDCODE_GREEN                    = 0x01,
    SBT_LEDCODE_YELLOW                   = 0x02,
    SBT_LEDCODE_AMBER                    = 0x03,
    SBT_LEDCODE_BLUE                     = 0x04
};

/* supported BEEP codes */
enum {
    SBT_BEEPCODE_SHORT_HIGH_1            = 0x00,
    SBT_BEEPCODE_SHORT_HIGH_2            = 0x01,
    SBT_BEEPCODE_SHORT_HIGH_3            = 0x02,
    SBT_BEEPCODE_SHORT_HIGH_4            = 0x03,
    SBT_BEEPCODE_SHORT_HIGH_5            = 0x04,
    SBT_BEEPCODE_SHORT_LOW_1             = 0x05,
    SBT_BEEPCODE_SHORT_LOW_2             = 0x06,
    SBT_BEEPCODE_SHORT_LOW_3             = 0x07,
    SBT_BEEPCODE_SHORT_LOW_4             = 0x08,
    SBT_BEEPCODE_SHORT_LOW_5             = 0x09,
    SBT_BEEPCODE_LONG_HIGH_1             = 0x0A,
    SBT_BEEPCODE_LONG_HIGH_2             = 0x0B,
    SBT_BEEPCODE_LONG_HIGH_3             = 0x0C,
    SBT_BEEPCODE_LONG_HIGH_4             = 0x0D,
    SBT_BEEPCODE_LONG_HIGH_5             = 0x0E,
    SBT_BEEPCODE_LONG_LOW_1              = 0x0F,
    SBT_BEEPCODE_LONG_LOW_2              = 0x10,
    SBT_BEEPCODE_LONG_LOW_3              = 0x11,
    SBT_BEEPCODE_LONG_LOW_4              = 0x12,
    SBT_BEEPCODE_LONG_LOW_5              = 0x13,
    SBT_BEEPCODE_FAST_WARBLE             = 0x14,
    SBT_BEEPCODE_SLOW_WARBLE             = 0x15,
    SBT_BEEPCODE_MIX1_HIGH_LOW           = 0x16,
    SBT_BEEPCODE_MIX2_LOW_HIGH           = 0x17,
    SBT_BEEPCODE_MIX3_HIGH_LOW_HIGH      = 0x18,
    SBT_BEEPCODE_MIX4_LOW_HIGH_LOW       = 0x19
};
/* invalid scanner id */
#define SBT_SCANNER_ID_INVALID           0x00

/* command op codes */
//--------- Command opcodes	--------//	 // SDKCC Ref #4.00
enum
{
    /* Supported in accordance to SRS */
    /* implemented */
    SBT_DEVICE_PULL_TRIGGER                     = 0x7DB,	//2011
	SBT_DEVICE_RELEASE_TRIGGER                  = 0x7DC,	//2012
	SBT_DEVICE_SCAN_DISABLE                     = 0x7DD,	//2013
	SBT_DEVICE_SCAN_ENABLE                      = 0x7DE,	//2014
    SBT_DEVICE_CAPTURE_IMAGE                    = 0xBB8,	//3000
    SBT_DEVICE_CAPTURE_BARCODE                  = 0xDAC,	//3500
	SBT_DEVICE_CAPTURE_VIDEO                    = 0xFA0,	//4000
	SBT_RSM_ATTR_GETALL                         = 0x1388,	//5000
	SBT_RSM_ATTR_GET                            = 0x1389,	//5001
    SBT_RSM_ATTR_GET_OFFSET                     = 0x138B,	//5003
    SBT_RSM_ATTR_SET                            = 0x138C,	//5004
	SBT_RSM_ATTR_STORE                          = 0x138D,	//5005
	SBT_SET_ACTION                              = 0x1770,	//6000

    
    /* Supported in accordance to SRS */
    /* not implemented */
    SBT_START_NEW_FIRMWARE                      = 0x1396,	//5014
	SBT_UPDATE_FIRMWARE                         = 0x1398,	//5016
	SBT_UPDATE_FIRMWARE_FROM_PLUGIN             = 0x1399,	//5017
    SBT_DEVICE_SET_PARAMETER_DEFAULTS           = 0x7DF,	//2015
	SBT_DEVICE_SET_PARAMETERS                   = 0x7E0,	//2016
	SBT_DEVICE_SET_PARAMETER_PERSISTANCE        = 0x7E1,	//2017
    SBT_DEVICE_ABORT_UPDATE_FIRMWARE            = 0x7D1,	//2001
    
    /* Unsupported in accordance to SRS */
    
	SBT_DEVICE_ABORT_MACROPDF                   = 0x7D0,	//2000
	SBT_DEVICE_AIM_OFF                          = 0x7D2,	//2002
	SBT_DEVICE_AIM_ON                           = 0x7D3,	//2003
	SBT_DEVICE_ENTER_LOW_POWER_MODE             = 0x7D4,	//2004
	SBT_DEVICE_FLUSH_MACROPDF                   = 0x7D5,	//2005
	SBT_DEVICE_GET_PARAMETERS                   = 0x7D7,    //2007
	SBT_DEVICE_GET_SCANNER_CAPABILITIES         = 0x7D8,    //2008
	SBT_DEVICE_LED_OFF                          = 0x7D9,	//2009
	SBT_DEVICE_LED_ON                           = 0x7DA,	//2010
	SBT_DEVICE_BEEP_CONTROL                     = 0x7E2,	//2018
	SBT_REBOOT_SCANNER                          = 0x7E3,	//2019
	SBT_DEVICE_ABORT_IMAGE_XFER                 = 0xBB9,	//3001
	SBT_RSM_ATTR_GETNEXT                        = 0x138A,	//5002
	SBT_GET_DEVICE_TOPOLOGY                     = 0x138E,	//5006
	SBT_REFRESH_TOPOLOGY                        = 0x138F,	//5007
	SBT_GET_DEVICE_TOPOLOGY_EX                  = 0x1390,	//5008
	SBT_RSM_GET_PCKTSIZE                        = 0x1393,	//5011
	SBT_UPDATE_ATTRIB_META_FILE                 = 0x1397,	//5015
    
    /* New features required for 1.2 release */
    SBT_DEVICE_VIBRATION_FEEDBACK               = 0X7E4,    //2020
    
	SBT_ERROR_OPCODE                            = -1,
    
    
};

typedef enum {
    SBT_FW_UPDATE_RESULT_SUCCESS                   = 0x00,
    SBT_FW_UPDATE_RESULT_FAILURE                   = 0x01,
} SBT_FW_UPDATE_RESULT;

typedef enum {
    STC_SSI_MFI                   = 0x00,
    STC_SSI_BLE                   = 0x01,
    SBT_SSI_HID                   = 0x02,
    NO_COM_PROTOCOL               = 0X03
} STC_COM_PROTOCOL;

typedef enum {
    SETDEFAULT_YES                   = 0x00,
    SETDEFAULT_NO                    = 0x01,
} SETDEFAULT_STATUS;

typedef enum {
    BARCODE_TYPE_LEGACY                  = 0x00,
    BARCODE_TYPE_STC                    = 0x01,
} BARCODE_TYPE;

#define SSIMFI  @"SSI over MFi"
#define SSIBLE  @"SSI over Bluetooth Low Energy (BLE)"
#define STC  @"ScanToConnect Suite"
#define LEGACY  @"Legacy Pairing"
#define SSIHID @"HID over Bluetooth Classic"
#define NOPROTOCOL @" "

#endif /* _SBT_SDK_DEFS_ */
