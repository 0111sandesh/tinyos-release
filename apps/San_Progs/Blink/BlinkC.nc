#include "Timer.h"

module BlinkC
{
	uses interface Timer<TMilli> as TimerBlink;
	uses interface Leds;
	uses interface Boot;
}
implementation
{
	event void Boot.booted()
	{
		call Leds.led2Toggle();
		call TimerBlink.startPeriodic(1000);
	}

	event void TimerBlink.fired()
	{
		call Leds.led0Toggle();
		call Leds.led1Toggle();
		call Leds.led2Toggle();
	}
}
