# Cordova Plugin Zebra Scanner for iOS

Cordova Wrapper for iOS Zebra Scanner SDK

### Installation

#### For Ionic Project

```ionic cordova plugin add cordova-plugin-zebra-scanner-ios```

#### For Cordova Project 

```cordova plugin add cordova-plugin-zebra-scanner-ios```


### Example

#### For Ionic Project (Connection for Zebra CS4070)

```jsx
import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs/BehaviorSubject';
import { BluetoothSerial } from '@ionic-native/bluetooth-serial';
import { Platform } from 'ionic-angular';

declare var window: any;

@Injectable()
export class BluetoothService {
   constructor() {
            document.addEventListener('zebra.barcodeData',
            this.bluetoothDataRead.bind(this), false);
        }
   CheckDeviceConnected(): void {
      window.ZebraScanner.getAvailableScanners().then((res) => {
                if (res.length) {
                    res.filter(item => {
                        if (String(item.name).toLowerCase().indexOf('cs4070') !== -1) {    // Change your Scanner here 
                            this.scannerID = item.scannerID;
                            window.ZebraScanner.
                            establishCommunicationSession(item.scannerID).then(data => {
                               console.log("Device Connected")
                            }, error => {
                               console.log(error)
                            });
                        }
                    });
                } else {
                    console.log("No Device Found")
                }
            });
        }
    }  
   bluetoothDataRead(event?): void {
            console.log("Read Success",event.detail.barcodeData);
        }
        
 
}

```
