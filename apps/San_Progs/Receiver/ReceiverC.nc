#include "Wireless.h"
 
module ReceiverC {
   uses interface Leds;
   uses interface Boot;
   uses interface Receive;
   uses interface SplitControl as AMControl;
   uses interface Packet;
}
implementation {
 
  message_t packet;
 
  bool locked;
  uint16_t msg = 0;
 
  event void Boot.booted() {
    call AMControl.start();
  }
 
  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      // do nothing
    }
    else {
      call AMControl.start();
    }
  }
 
  event void AMControl.stopDone(error_t err) {
    // do nothing
  }
 
  event message_t* Receive.receive(message_t* bufPtr, 
				   void* payload, uint8_t len) {
    if (len != sizeof(wireless_msg_t)) {return bufPtr;}
    else {
      wireless_msg_t* rcm = (wireless_msg_t*)payload;
 
      if (rcm->msg == 123) {
        call Leds.led0Toggle();
        call Leds.led2Toggle();
      } 
      else 
        call Leds.led1Toggle();
 
    
      return bufPtr;
    }
  }
 
}
