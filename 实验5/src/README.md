# 文件目录与文件解释

- 源码asm文件
  - boot.asm	：引导程序
  - myos.c    myos.asm    ：内核程序
  - prog1.asm    ：用户程序1
  - prog2.asm    ：用户程序2
  - prog3.asm    ：用户程序3
  - prog4.asm    ：用户程序4
  - 其余为需要include的文件
- Makefile
  -  Makefile
- 编译后程序
  - boot.bin    ：引导程序nasm编译后程序
  - MYOS.OBJ  ：myos.asm经tasm编译得到
  - OS.OBJ  ：myos.c经tcc编译得到
  - MYOS.COM    ：内核程序，TLINK得到
  - prog1.bin ~ prog4.bin    ：用户程序nasm编译后程序
- 系统软盘img文件
  - heze.img    ：操作系统软盘文件