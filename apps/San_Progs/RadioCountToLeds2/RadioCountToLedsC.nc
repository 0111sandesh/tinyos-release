/*
 * Copyright (c) 2000-2005 The Regents of the University  of California.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the copyright holders nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA,
 * 94704.  Attention:  Intel License Inquiry.
 */

#include "Timer.h"
#include "RadioCountToLeds.h"
#include "printfZ1.h"

/**
 * Implementation of the RadioCountToLeds application. RadioCountToLeds
 * maintains a 4Hz counter, broadcasting its value in an AM packet
 * every time it gets updated. A RadioCountToLeds node that hears a counter
 * displays the bottom three bits on its LEDs. This application is a useful
 * test to show that basic AM communication and timers work.
 *
 * @author Philip Levis
 * @date   June 6 2005
 */

module RadioCountToLedsC {
  uses {
    interface Leds;
    interface Boot;
    interface Receive;
    interface AMSend;
    interface Timer<TMilli> as MilliTimer;
    interface SplitControl as AMControl;
    interface Packet;
    interface CC2420SecurityMode as CC2420Security;
    interface CC2420Keys;

    interface PacketLink;
  }
}
implementation {

  message_t packet;
  uint8_t key[16] = {0x55,0x66,0x77,0x88,0xD6,0xAD,0xB7,0x0C,0x59,0x9A,0x9B,0x99,0x88,0x77,0x66,0x55};
  uint8_t keyReady = 0; // should be set to 1 when key setting is done
  uint8_t light = 0;
  bool locked;


  event void Boot.booted()
  {
    printfz1_init();
    call AMControl.start();
  }

  event void AMControl.startDone(error_t err)
  {
    if (err == SUCCESS) {
      call CC2420Keys.setKey(1, key);
    } else {
        call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err)
  {
  }

  event void CC2420Keys.setKeyDone(uint8_t keyNo, uint8_t* skey)
  {
    keyReady = 1;
  }

  event void MilliTimer.fired()
  {
    
  }

  event message_t* Receive.receive(message_t* bufPtr,
           void* payload, uint8_t len)
  {
    radio_count_msg_t* rcm = (radio_count_msg_t*)payload;
    dbg("RadioCountToLedsC", "Received packet of length %hhu.\n", len);
    // if (len != sizeof(radio_count_msg_t)) {
      printfz1("len: %d, expected: %d\n", len, sizeof(radio_count_msg_t));
    //   call Leds.led2Toggle();
    //   return bufPtr;
    // }
    // else {
      
      printfz1("Receiver counter: %d\n", rcm->counter);
      light = rcm->counter % 2;
      if (light == 0)
         call Leds.led0Toggle();
      else
        call Leds.led1Toggle();
      
      return bufPtr;
    //}
  }

  event void AMSend.sendDone(message_t* msg, error_t error)
  {
  }

}
