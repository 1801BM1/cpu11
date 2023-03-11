TARGET = mcode
LIBS = -lm
CC = gcc
CFLAGS = -g -Wall -O3

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)
CFLAGS += -msse -msse2 -mfxsr -mavx -mavx2 -mxsave

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@ -Wa,-adhln=$@.lst

.PRECIOUS: $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -Wall $(LIBS) -o $@

clean:
	-rm -f *.o
	-rm -f $(TARGET)
