SENSORBOARD=quantoplus

COMPONENT=TestFtspAppC

PFLAGS += -DTIMESYNC_RATE=10
#PFLAGS += -DTIMESYNC_DEBUG
#PFLAGS += -DCC2420_CHANNEL=26
CFLAGS += -DTOSH_DATA_LENGTH=50
#CFLAGS += -DCOUNT_LOG

PFLAGS += -I$(TOSDIR)/lib/ftsp -I$(TOSDIR)/../apps/RadioCountToLeds -I$(TOSDIR)/lib/printf

CFLAGS += -DLPL_INTERVAL=200
CFLAGS += -DLOW_POWER_LISTENING

include $(MAKERULES)
