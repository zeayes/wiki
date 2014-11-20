CC=gcc
CFLAGS=-Wall -lpthread
LDFLAGS=-pthread
OBJECTS=multi_process_server multi_thread_server client
SOURCES=multi_process_server.c multi_thread_server.c client.c

all:  $(OBJECTS)

OBJECTS: $(SOURCES)
	$(CC) -c -o $@ $< $(CFLAGS) $(LDFLAGS)

clean:
	rm $(OBJECTS)
