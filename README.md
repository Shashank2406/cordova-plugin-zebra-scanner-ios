# Cordova Plugin Zebra Scanner for iOS

This Cordova plugin is a wrapper for the official [iOS Zebra Scanner SDK](https://www.zebra.com/gb/en/products/software/scanning-systems/scanner-drivers-and-utilities/scanner-ios-sdk.html).

### Installation

#### For Ionic Project

```ionic cordova plugin add cordova-plugin-zebra-scanner-ios```

> You also need to install [ionic native bluetooth-serial](https://beta.ionicframework.com/docs/native/bluetooth-serial).

> For ionic versions `>4` use the following Command:
```
ionic cordova plugin add cordova-plugin-bluetooth-serial
npm install --save @ionic-native/bluetooth-serial
```
Now you have to add `BluetoothSerial` to your `app.module.ts` (for ionic Version 4 you need `@ionic-native/bluetooth-serial@5.0.0-beta.x`):
```typescript
...
// /npx is required for ionic 4
import { BluetoothSerial } from '@ionic-native/bluetooth-serial/ngx';
...
providers: [
 ...,
 BluetoothSerial
],
```

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

   // Change your Scanner here
   scannerName: string = 'cs4070';

   constructor () {
      document.addEventListener('zebra.barcodeData', this.bluetoothDataRead.bind(this), false);
   }
   
   /**
     * Demo for Output console.logs for connection status
     */
   CheckDeviceConnected (): void {
      window.ZebraScanner
         .getAvailableScanners()
         .then((res) => {
            if (res.length) {
               res.filter(item => {
                  if (String(item.name).toLowerCase().indexOf(this.scannerName) !== -1) { 
                     this.scannerID = item.scannerID;
                     window.ZebraScanner.
                        establishCommunicationSession(item.scannerID)
                        .then(data => {
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

    bluetoothDataRead (event?): void {
         console.log("Read Success",event.detail.barcodeData);
    }
      
}
```
