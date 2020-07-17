# 实验六：实现时间片轮转的二态进程模型

# 18340052          何泽

[TOC]

## 一、实验目的

> 1. 学习多道程序与CPU分时技术
>
> 2. 掌握操作系统内核的二态进程模型设计与实现方法
>
> 3. 掌握进程表示方法
>
> 4. 掌握时间片轮转调度的实现

## 二、实验要求

> 1. 了解操作系统内核的二态进程模型
>
> 2. 扩展实验五的的内核程序，增加一条命令可同时创建多个进程分时运行，增加进程控制块和进程表数据结构。
>
> 3. 修改时钟中断处理程序，调用时间片轮转调度算法
>
> 4. 设计实现时间片轮转调度算法，每次时钟中断，就切换进程，实现进程轮流运行
>
> 5. 修改`save()`和`restart()`两个汇编过程，利用进程控制块保存当前被中断进程的现场，并从进程控制块恢复下一个 进程的现场
>
> 6. 编写实验报告，描述实验工作的过程和必要的细节，如截屏或录屏，以证实实验工作的真实性

## 三、实验内容

> 1. 修改实验5的内核代码，定义进程控制块PCB类型，包括进程号、程序名、进程内存地址信息、CPU寄存器保存区、进程状态等必要数据项，再定义一个PCB数组，最大进程数为10个
>
> 2. 扩展实验五的的内核程序，增加一条命令可同时执行多个用户程序，内核加载这些程序，创建多个进程，再实现分时运行
>
> 3. 修改时钟中断处理程序，保留无敌风火轮显示，而且增加调用进程调度过程
>
>    ```c++
>    Timer:
>    	save()
>    	call showWingFireWheel()  ;无敌风火轮显示
>    	call _schedule()          ; 调用进程调度过程
>        jmp restart
>    ```
>
> 4. 内核增加进程调度过程：每次调度，将当前进程转入就绪状态，选择下一个进程运行，如此反复轮流运行。
>
>    ```c++
>    void schedule(){
>    	CurrentProcessNo++；
>    	if (CurrentProcessNo=MaxProcessNo) 
>    		CurrentProcessNo=0；
>    }
>    ```
>
> 5. 修改save()和restart()两个汇编过程，利用进程控制块保存当前被中断进程的现场，并从进程控制块恢复下一个进程的运行
> 6. 实验5的内核其他功能，如果不必要，可暂时取消服务

## 四、实验方案

### 1.相关基础原理

- **进程模型就是实现多道程序和分时系统的一个理想的方案**
  - 多个用户程序并发执行
  - 进程模型中，操作系统可以知道有几个用户程序在内存运行，每个用户程序执行的代码和数据放在什么位置，入口位置和当前执行的指令位置，哪个用户程序可执行或不可执行，各个程序运行期间使用的计算机资源情况等等
- **二状态进程模型**
  - 执行和等待
  - 目前进程的用户程序都是`COM`格式的，是最简单的可执行程序
  - 进程仅涉及一个内存区、CPU、显示屏这几种资源，所以进程模型很简单，只要描述这几个资源
- **初级进程**
  - 现在的用户程序都很小，只要简单地将内存划分为多个小区，每个用户程序占用其中一个区，就相当于每个用户拥有独立的内存
  - 根据我们的硬件环境，CPU可访问`1M`内存，我们规定`MYOS`加载在第一个`64K`中，用户程序从第二个`64K`内存开始分配，每个进程`64K`，作为示范，我们实现的`MYOS`进程模型只有两个用户程序，大家可以简单地扩展，让`MYOS`中容纳更多的进程
  - 对于键盘，我们先放后解决，即规定用户程序没有键盘输入要求，我们将在后继的关于终端的实验中解决
  - 对于显示器，我们可以参考内存划分的方法，将`25`行`80`列的显示区划分为多个区域，在进程运行后，操作系统的显示信息是很少的我们就将显示区分为`4`个区域，用户程序如果要显示信息，规定在其中一个区域显示。当然，理想的解决方案是用户程序分别拥有一个独立的显示器，这个方案会在关于终端的实验中提供
  - 文件资源和其它系统软资源，则会通过扩展进程模型的数据结构来实现，相关内容将安排在文件系统实验和其它一些相关实验中
- **进程表**
  - 初级的进程模型可以理解为将一个CPU模拟为多个逻辑独立的CPU，每个进程具有一个独立的逻辑CPU
  - 同一计算机内并发执行多个不同的用户程序，`MYOS`要保证独立的用户程序之间不会互相干扰。为此，内核中建立一个重要的数据结构：进程表和进程控制块`PCB`
  - 现在的`PCB`它包括进程标识和逻辑CPU模拟
  - 逻辑CPU
    - `8086CPU`的所有寄存器：`AX/BX/CX/DX/BP/SP/DI/SI/CS/DS/ES/SS/IP/FLAG`
    - 用内存单元模拟
    - 逻辑CPU轮流映射到物理CPU，实现多道程序的并发执行
- **进程交替执行**
  - 在以前的原型操作系统顺序执行用户程序，内存中不会同时有两个用户程序，所以CPU控制权交接问题简单，操作系统加载了一个用户到内存中，然后将控制权交接给用户程序，用户程序执行完再将控制权交接回操作系统，一次性完成用户程序的执行过程
  - 采用时钟中断打断执行中的用户程序实现CPU在进程之间交替
  - 简单起见，我们让两个用户的程序均匀地推进，就可以在每次时钟中断处理时，将CPU控制权从当前用户程序交接给另一个用户程序
- **内核**
  - 利用时钟中断实现用户程序轮流执行 
  - 在系统启动时，将加载两个用户程序A和B，并建立相应的`PCB`。
  - 修改时钟中断服务程序
    - 每次发生时钟中断，中断服务程序就让A换B或B换A。
    - 要知道中断发生时谁在执行，还要把被中断的用户程序的CPU寄存器信息保存到对应的PCB中，以后才能恢复到CPU中保证程序继续正确执行。中断返回时，CPU控制权交给另一个用户程序
- **现场保护:`save`过程**
  - `Save`是一个非常关键的过程，保护现场不能有丝毫差错，否则再次运行被中断的进程可能出错
  - 涉及到三种不同的栈：应用程序栈、进程表栈、内核栈。其中的进程表栈，只是我们为了保存和恢复进程的上下文寄存器值，而临时设置的一个伪局部栈，不是正常的程序栈
  - 在时钟中断发生时，实模式下的CPU会将`FLAGS`、`CS`、`IP`先后压入当前被中断程序（进程）的堆栈中，接着跳转到（位于`kernel`内）时钟中断处理程序（`Timer`函数）执行。注意，此时并没有改变堆栈的`SS`和`SP`，换句话说，我们内核里的中断处理函数，在刚开始时，使用的是被中断进程的堆栈
  - 为了及时保护中断现场，必须在中断处理函数的最开始处，立即保存被中断程序的所有上下文寄存器中的当前值。不能先进行栈切换，再来保存寄存器。因为切换栈所需的若干指令，会破坏寄存器的当前值。这正是我们在中断处理函数的开始处，安排代码保存寄存器的内容
  - 我们`PCB`中的`16`个寄存器值，内核一个专门的程序`save`，负责保护被中断的进程的现场，将这些寄存器的值转移至当前进程的`PCB`中
- **进程切换:`restart`过程**
  - 用内核函数`restart`来恢复下一进程原来被中断时的上下文，并切换到下一进程运行。这里面最棘手的问题是SS的切换。
  - 使用标准的中断返回指令`IRET`和原进程的栈，可以恢复（出栈）`IP`、`CS`和`FLAGS`，并返回到被中断的原进程执行，不需要进行栈切换。
  - 如果使用我们的临时（对应于下一进程的）`PCB`栈，也可以用指令`iret`完成进程切换，但是却无法进行栈切换。因为在执行`iret`指令之后，执行权已经转到新进程，无法执行栈切换的内核代码；而如果在执行`iret`指令之前执行栈切换（设置新进程的`SS`和`SP`的值），则`iret`指令就无法正确执行，因为`iret`必须使用`PCB`栈才能完成自己的任务。
  - 解决办法有三个，一个是所有程序，包括内核和各个应用程序进程，都使用共同的栈。即它们共享一个（大栈段）`SS`，但是可以有各自不同区段的`SP`，可以做到互不干扰，也能够用`iret`进行进程切换。第二种方法，是不使用`iret`指令，而是改用`retf`指令，但必须自己恢复`FLAGS`和`SS`。第三种方法，使用`iret`指令，在用户进程的栈中保存`IP`、`CS`和`FLAGS`，但必须将`IP`、`CS`和`FLAGS `放回用户进程栈中，这也是我们程序所采用的方案

### 2.实验环境与工具版本

- 平台：`Windows + Ubuntu`

  <img src="http://www.hz-heze.com/wp-content/uploads/2020/05/Ubuntu.png" alt="Ubuntu" style="zoom: 50%;" />

  - c语言编译器：`tcc`,运行环境：`DosBox 0.74`

  - 汇编工具：`nasm`+`tasm`

    <img src="http://www.hz-heze.com/wp-content/uploads/2020/05/2-1.png" alt="2" style="zoom: 50%;" />

- `Make`：

  <img src="http://www.hz-heze.com/wp-content/uploads/2020/05/make.png" alt="make" style="zoom: 50%;" />

- 虚拟机：`VMware Workstation Pro 15`

### 3.实验思路

- 系统框架

  ```mermaid
  graph LR
    A>系统启动]-->B(引导扇区)---C(加载内核程序)-->D[用户程序]-->E[初始化时钟]-->F[设置时钟中断处理程序]
  E-.->G((计时器))
  ```

  ```mermaid
  graph LR
    A>时钟中断]-->B(保护状态寄存器save)---C(阻塞当前进程)-->D(调度程序schedule)-->E(恢复状态寄存器,切换栈,restart)
    E-->F{启动进程}
  ```

## 五、实验过程与结果

### 1. 操作系统功能

- 操作系统内核功能

  **进入系统后，会在右下角显示“无敌风火轮”**

  | 输入命令 |   功能描述与参数解释   |
  | :------: | :--------------------: |
  |   name   |     显示程序的名字     |
  |    ls    |    显示用户程序信息    |
  |  clean   | 清屏，只留下开头的指引 |
  |   time   |     获取当前的时间     |
  
- 执行用户程序

  ​	用户程序功能为数字在屏幕反弹，第几个程序就是数字几在反弹，**可以“串行”执行也可以“并行”执行**

  |        输入命令         |                             解释                             |
  | :---------------------: | :----------------------------------------------------------: |
  |     run + 程序序号      | 可以执行单个程序，如`run 1`，也可以按顺序执行多个，如`run 2341` |
  | run_plus + 多个程序序号 |           同时执行多个用户程序，如`run_plus 1234`            |

- 中断服务程序

  | 输入命令 |               功能               |
  | :------: | :------------------------------: |
  | int 33h  | 在左上显示字符 “This is int 33h” |
  | int 34h  | 在右上显示字符 “This is int 34h” |
  | int 35h  | 在左下显示字符 “This is int 35h” |
  | int 36h  | 在右下显示字符 “This is int 36h” |
  
- 系统调用，`int 21h`，输入`int 21h+功能号`，如`int 21h 2`，可进行系统调用，各功能号对应的功能如下：
  
  | 功能号 |         功能         |
  | :----: | :------------------: |
  |   0    |     显示ouch字符     |
  |   1    | 将输入的字符串再输出 |
  |   2    |     小写转为大写     |
  |   3    |     大写转为小写     |
  |   4    |  二进制数转十进制数  |
  |   5    | 十六进制数转十进制数 |


### 2. 引导程序

- 引导程序的作用是加载操作系统内核，同时输出字符，因为和之前的一样，不再详细叙述
- 因为引导成功后直接进入内核，而内核会先清屏后输出字符，所以在实际过程中引导程序的字符并不会被看见，因为太快了，只有在程序出错导致无法正确引导的时候才能看见这串字符

### 3.内核与用户程序

> 我的文件结构如下：
>
> |   文件名   |                      功能                       |
> | :--------: | :---------------------------------------------: |
> | interr.asm | 所有的中断程序、风火轮、`save`与`restart`的实现 |
> |  lib.asm   |    一些C程序调用的库函数以及各中断的调用函数    |
> |  MyOS.asm  |                   主汇编文件                    |
> |  MyPro.h   |              进程控制块`PCB`的实现              |
> |   MyOS.c   |                     主C程序                     |
>
> **由于大量的代码和上个实验都是相同的，之前也有过详细的叙述，下面就只叙述这次实验改动、新加的部分**

- 改进了时钟中断处理程序，并保留风火轮显示，这一部分增加了调用进程调度过程

  ```assembly
  Timer:
      push ax
      push bx
      push cx
      push dx
      push bp
      push es
  
  	dec byte ptr es:[count]				 ; 递减计数变量
  	jnz End1						    	; >0：跳转
  	inc byte ptr es:[dir]                 ; dir表示风火轮方向
  	cmp byte ptr es:[dir],1              
  	jz dir1
  	cmp byte ptr es:[dir],2              
  	jz dir2
  	cmp byte ptr es:[dir],3              
  	jz dir3
  	jmp show
  ```

  跳转的`End1`如下，首先将寄存器`AL`置为`EOI`，再将`EOI`发送到主、从`8529A`，再恢复寄存器信息

  ```assembly
  End1:
  	mov al,20h					         ; AL = EOI
  	out 20h,al						     ; 发送EOI到主8529A
  	out 0A0h,al					         ; 发送EOI到从8529A
  
  	pop ax                                 ; 恢复寄存器信息
  	mov es,ax
  	pop bp
  	pop dx 
  	pop cx
  	pop bx
  	pop ax
  	iret		
  
  	str1 db '/ | \'
  	str2 db '| \ /'
  	str3 db '\ / |'
  	delayT equ 5				         ; 计时器延迟计数
  	count db delayT					     ; 计时器计数变量
  ```

- 关于进程控制块`PCB`

  - 新进程段基址

    ```c
    int current_Seg = 0x2000;
    ```

  - 枚举出进程的四种状态

    ```c
    typedef enum Status{NEW,READY,RUNNING,EXIT}Status;
    ```
    
  - 定义寄存器的结构体

    ```c
    typedef struct RegisterImage
    {
    	int SS;
    	int GS;
    	int FS;
    	int ES;
    	int DS;
    	int DI;
    	int SI;
    	int BP;
    	int SP;
    	int BX;
    	int DX;
    	int CX;
    	int AX;
    	int IP;
    	int CS;
    	int FLAG;
    } RegisterImage;
    ```

  - `PCB`结构体，将上面两个结构组合

    ```c++
    typedef struct PCB
    {
    	RegisterImage regImg;
    	Status ProcessStatus;
    }PCB;
    
    PCB PCB_Queue[MAX_SIZE];
    ```

  - 保存当前进程控制块

    ```c
    void SavePCB(int gs,int fs,int es,int ds,int di,int si,int bp,int sp,
    			 int dx,int cx,int bx,int ax,int ss,int ip,int cs,int flag)
    {
        PCB_Queue[CurPCBNum].regImg.AX = ax;
        PCB_Queue[CurPCBNum].regImg.BX = bx;
        PCB_Queue[CurPCBNum].regImg.CX = cx;
        PCB_Queue[CurPCBNum].regImg.DX = dx;
        PCB_Queue[CurPCBNum].regImg.SP = sp;
        PCB_Queue[CurPCBNum].regImg.BP = bp;
        PCB_Queue[CurPCBNum].regImg.SI = si;
        PCB_Queue[CurPCBNum].regImg.DI = di;
        PCB_Queue[CurPCBNum].regImg.DS = ds;
        PCB_Queue[CurPCBNum].regImg.ES = es;
        PCB_Queue[CurPCBNum].regImg.FS = fs;
        PCB_Queue[CurPCBNum].regImg.GS = gs;
        PCB_Queue[CurPCBNum].regImg.SS = ss;
        PCB_Queue[CurPCBNum].regImg.IP = ip;
        PCB_Queue[CurPCBNum].regImg.CS = cs;
        PCB_Queue[CurPCBNum].regImg.FLAG = flag;
    }
    ```

  - 进程调度，进行进程轮转

    ```c
    void Schedule()
    {
    	/* 当前进程转为就绪态 */
    	PCB_Queue[CurPCBNum].ProcessStatus = READY;
    	/* 切换下一个进程 */
    	CurPCBNum ++;
    	if( CurPCBNum > processNum )
    		CurPCBNum = 1;
    	/* 切换后进程转为运行态*/
    	if( PCB_Queue[CurPCBNum].ProcessStatus != NEW )
    		PCB_Queue[CurPCBNum].ProcessStatus = RUNNING;
    	return;
    }
    PCB* Current_Process()
    {
    	return &PCB_Queue[CurPCBNum];
    }
    ```

  - 初始化进程控制块

    ```c
    void PCBInit(PCB *p, int seg, int offset)
    {
    	p->ProcessStatus = NEW;
    	p->regImg.GS = 0xb800;
    	p->regImg.ES = seg;
    	p->regImg.DS = seg;
    	p->regImg.FS = seg;
    	p->regImg.SS = seg;
    	p->regImg.DI = 0;
    	p->regImg.SI = 0;
    	p->regImg.BP = 0;
    	p->regImg.SP = offset - 4;
    	p->regImg.BX = 0;
    	p->regImg.AX = 0;
    	p->regImg.CX = 0;
    	p->regImg.DX = 0;
    	p->regImg.IP = offset;
    	p->regImg.CS = seg;
    	p->regImg.FLAG = 512;
    }
    ```

  - 创建新进程

    ```c
    void createNewPCB()
    {
    	if(processNum > MAX_SIZE) 
            return;
    	PCBInit( &PCB_Queue[processNum] ,processNum, current_Seg);
    	processNum++;
    	current_Seg += 0x1000;
    }
    ```

- `save`

  利用进程控制块保存当前被中断进程的现场，就是将各寄存器的值压栈，并调用前面的`SavePCB`和`schedule`函数

  ```assembly
  Save:
  	inc word ptr[Runtime]
  	cmp word ptr[Runtime],512
  	jnz Save_continue 
      mov word ptr[_CurPCBNum],0
  	mov word ptr[Runtime],0
  	mov word ptr[_processNum],0
  	mov word ptr[_Segment],2000h
  	jmp Pre
  Save_continue:
      push ss
  	push ax
  	push bx
  	push cx
  	push dx
  	push sp
  	push bp
  	push si
  	push di
  	push ds
  	push es
  	.386
  	push fs
  	push gs
  	.8086
  
  	mov ax,cs
  	mov ds, ax
  	mov es, ax
  	call near ptr _SavePCB
  	call near ptr _Schedule 
  ```

- `restart`

  从进程控制块恢复下一个 进程的现场，将前面保存的各寄存器值存入寄存器再弹栈，都是`push`和`pop`就不贴代码了

- `21h`中断这次新加入了二进制转十进制和十六进制转十进制的功能

  - 二进制转十进制相对简单一些

    ```c
    int BIN2DEC(char* word)
    {
        int num = 0;
    	while( (*word) != '\0' )
    	{
    		num *= 2;
    		num += (*word) - '0';
    		word++;
    	}
    	return num;
    }
    ```

  - 十六进制转十进制稍麻烦，因为要判断字母

    ```c
    int HEX2DEC(char *phex)
    {
    	int dec = 0;
    	while(*phex != '\0')
    	{
    		int tem = 0;
    		dec = dec*16;
    		if(*phex >= '0' && *phex <= '9')
    			tem = *phex - '0';
    		else if(*phex >= 'A' && *phex <= 'F')
    			tem = *phex - 'A' + 10;
    		else if(*phex >= 'a' && *phex <= 'f')
    			tem = *phex - 'a' + 10;
    		else 
                tem = 0;
    		dec += tem;
    		phex++;
    	}
    	return dec;
    }
    ```

- 对于多用户程序同时运行，先判断程序号是否在范围内，再调用前面的函数

  ```c
  void process()
  {
  	for(j=9; j < strlen(input); j++)
  	{
          if(input[j] < '1' || input[j] > '4')
          {
              print("\n\rPlease input one number of 1,2,3,4!\n\n\r");
              return ;
          }
      }
  	for(j=9; j < strlen(input); j++)
  	{
  		if(input[j] == ' ') 
              continue;
  		else if(input[j]>'0'&&input[j]<='5')
  		{
  			k = input[j] - '0' + 2;
  			if( Segment > 0x6000 )
  			{
  				print("\n\rThere have been 5 Processes !\n\n\r");
  				break;
  			}
               PCBInit(&PCB_Queue[CurPCBNum],Segment,0x1400);
  			another_load(Segment,k);
  			Segment += 0x1000;
  			processNum++;
  		}
  	}
  }
  ```

**用户程序和之前的一样，就不再叙述了**

### 5.编译

- 首先在`DosBox`中使用`TCC`、`TASM`以及`TLINK`编译内核，并生成`.com`程序

  - 启动`DosBox`，将目录挂载到`DosBox`的D盘并进入

    <img src="http://www.hz-heze.com/wp-content/uploads/2020/05/5-1.png" alt="5" style="zoom:80%;" />

  - 使用`TCC`、`TASM`、`TLINK链接`

    <img src="https://www.hz-heze.com/wp-content/uploads/2020/07/1-2.png" alt="1" style="zoom:67%;" />

- 剩下的汇编我使用`NASM`编译，并在`Ubuntu`下使用`dd`命令写入软盘

  这里我使用`Make`自动完成创建空白软盘、`nasm`编译引导程序、将各个程序写入扇区的工作

  下面是我的`MakeFile`

  ```makefile
  BIN = boot.bin prog1.bin prog2.bin prog3.bin prog4.bin
  IMG = heze.img
  all: clear $(BIN) $(IMG)
  clear:
  	rm -f $(BIN) $(IMG)
  %.bin: %.asm
  	nasm -fbin $< -o $@
  %.img:
  	/sbin/mkfs.msdos -C $@ 1440
  	dd if=boot.bin of=$@ conv=notrunc
  	dd if=MYOS.COM of=$@ seek=1 conv=notrunc
  	dd if=prog1.bin of=$@ seek=20 conv=notrunc
  	dd if=prog2.bin of=$@ seek=21 conv=notrunc
  	dd if=prog3.bin of=$@ seek=22 conv=notrunc
  	dd if=prog4.bin of=$@ seek=23 conv=notrunc
  clean:
  	rm *.bin
  ```

  其中，先将以前生成的文件都删除，然后1.44MB软盘是用`/sbin/mkfs.msdos -C $@ 1440`这一句完成创建的，`nasm`命令将所有`.asm`文件汇编为`.bin`文件，然后将所有程序都写入软盘。

  编译：

  <img src="https://www.hz-heze.com/wp-content/uploads/2020/07/3-3.png" alt="3" style="zoom:50%;" />

  可见所有的命令都自动执行了。

### 6.运行

- 进入后首界面

  <img src="https://www.hz-heze.com/wp-content/uploads/2020/07/8-1.png" alt="8" style="zoom:67%;" />

- 显示文件信息和时间

  <img src="https://www.hz-heze.com/wp-content/uploads/2020/07/9-1.png" alt="9" style="zoom:67%;" />

- 软中断，这里以`34h`为例：

  <img src="https://www.hz-heze.com/wp-content/uploads/2020/07/4-5.png" alt="4" style="zoom:67%;" />

- 系统调用，输出输入字符、大小写转换、二进制转十进制

  <img src="https://www.hz-heze.com/wp-content/uploads/2020/07/2-3.png" alt="2" style="zoom:80%;" />

- 同时运行用户程序

​	    <img src="https://www.hz-heze.com/wp-content/uploads/2020/07/5-2.png" alt="5" style="zoom:67%;" />

​		<img src="https://www.hz-heze.com/wp-content/uploads/2020/07/7.png" alt="6" style="zoom:67%;" />



## 六、创新工作

1. 使用`Make`，各种命令自动执行

2. `21h`系统调用除了大小写转换还新加入了二进制、十六进制转十进制的功能


 

