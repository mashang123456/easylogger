ifeq ("$(PLATFORM)","X86") #X86平台编译器
    GCC = gcc
    CFLAGS  += -I/usr/local/include/
	LDFLAGS += -L/usr/local/lib -lpthread
	LDFLAGS += -D X86 #参数传入src文件
endif

ifeq ("$(PLATFORM)","MIPS") #OpenWrt平台编译器
    GCC = /home/xiaomi/OpenWrt-Toolchain-ramips-for-mipsel_24kec+dsp-gcc-4.8-linaro_uClibc-0.9.33.2/toolchain-mipsel_24kec+dsp_gcc-4.8-linaro_uClibc-0.9.33.2/bin/mipsel-openwrt-linux-gcc
	CFLAGS += -I/home/openwrt/mosquitto/include
	LDFLAGS+= -L/home/openwrt/mosquitto/lib -lpthread
	LDFLAGS += -D MIPS #参数传入src文件
endif

OUTPUT=libeasylogger.so 

all: $(OUTPUT) 

elog_file.o: 
	$(GCC) -shared -fPIC -c plugins/file/elog_file.c -I./plugins/ -I./inc/ $(CFLAGS) $(LDFLAGS)
	
elog_file_port.o: 
	$(GCC) -shared -fPIC -c plugins/file/elog_file_port.c -I./plugins/ -I./inc/ $(CFLAGS) $(LDFLAGS)

elog_port.o: 
	$(GCC) -shared -fPIC -c port/elog_port.c -I./plugins/ -I./inc/ $(CFLAGS) $(LDFLAGS)
	
*.o: 
	$(GCC) -shared -fPIC -c src/*.c  -I./inc/ $(CFLAGS) $(LDFLAGS)

$(OUTPUT): elog_file.o elog_file_port.o elog_port.o *.o
	$(GCC) -shared -fPIC  -o $(OUTPUT) *.o $(CFLAGS) $(LDFLAGS)


.PHONY: clean
clean:
	rm -rf $(OUTPUT) *.o
	

	
