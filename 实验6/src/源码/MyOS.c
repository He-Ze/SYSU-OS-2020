#include "MyPro.h"

extern void printChar();
extern void getchar(); 
extern void cls();
extern void getdate(); 
extern void gettime();
extern void run();
extern void readAt();   
extern void readFile();
extern void int33h();
extern void int34h();
extern void int35h();
extern void int36h();
extern void int21h_0();
extern void int21h_1();
extern void int21h_2();
extern void int21h_3();
extern int  int21h_4();
extern int  int21h_5();

char in,ch1,ch2,ch3,ch4,p,fileSeg=7,insNum;
char input[100],output[100],tem_str[100];
char ini[100];
int pFile=0;
int i,j,k,yy,mm,dd,hh,mmm,ss,t;
int Segment = 0x2000;

void print(char *p)
{
    while(*p != '\0')
    {
        printChar(*p);
        p++;
    }
}

int getline(char arr[],int maxLen)
{
    if(maxLen == 0)
        return 0;

    i = 0;
    getchar();
    while(in != '\n'&& in != '\r') 
    {
        int k = in;
        if(k == 8)
        {
            i--;
            getchar();
            continue;
        }
        printChar(in);
        arr[i++] = in;
        if(i == maxLen)
        {
            arr[i] = '\0';
            printChar('\n');
            return 0;
        }
        getchar();
    }
    arr[i] = '\0';
    print("\n\r");
    return 1;
}

int strcmp(char* str1,char* str2)
{
    while(*str1 != '\0' && *str2 != '\0')
    {
        if(*str1 != *str2) 
            return 0;
        str1++;
        str2++;
    }
    if(*str1 == '\0' && *str2 == '\0') 
        return 1;
    return 0;
}

void strcpy(char str1[],char str2[])
{
    i = 0;
    while(str2[i] != '\0')
    {
        str1[i] = str2[i];
        i++;
    }
    str1[i] = '\0';
}

int strlen(char str[])
{
    i = 0;
    while(str[i] != '\0')
        i++;
    return i;
}

void reverse(char str[],int len)
{
    for(i = 0;i < len;++i)
        tem_str[i] = str[len-i-1];

    for(i = 0;i < len;++i)
        str[i] = tem_str[i];
}

int substr(char str1[],char str2[],int st,int len)
{
    for(i = st;i < st+len;++i)
        str2[i-st] = str1[i];

    str2[st+len] = '\0';
}

void printInt(int ans)
{
    i = 0;
    while(ans)
    {
        int t = ans%10;
        output[i++] = '0'+t;
        ans/=10;
    }
    reverse(output,i);
    output[i] = '\0';
    print(output);
}

void init()
{
    cls();
    processNum=0;
    print("Welcome to HeZe's operating system.\n\r");
    print("Just input the name of the instructions.\n\r\n");
    print("ls: Show the files's size and name\r\n");
    print("clean: Clear the screen       time: Get the time\r\n");
    print("author: Show the author of this operating system\r\n");
    print("run: Run any number of program  e.g: run 2 or run 2431\n\r");
    print("run_plus: Run programs at the same time e.g: run_plus 1234\n\r");
    print("int 33h    int 34h    int 35h    int 36h\n\r");
    print("int 21h+function_number e.g: int 21h 1\n\r");

}

int BCD2DEC(int x)
{
    return x/16*10 + x%16;
}

void time()
{
    print("The time is: ");
    getdate();
    yy = BCD2DEC(ch1)*100 + BCD2DEC(ch2);
    if(yy == 0) 
        print("0000");
    else if(yy >0 && yy < 10) 
        print("000");
    else if(yy > 10 && yy < 100) 
        print("00");
    else if(yy > 100 && yy < 1000) 
        print("0");
    printInt(yy);
    printChar('/');
    mm = BCD2DEC(ch3);
    if(mm == 0) 
        print("00");
    else if(mm > 0 && mm < 10) 
        printChar('0');
    printInt(mm);
    printChar('/');
    dd = BCD2DEC(ch4);
    if(dd == 0) 
        print("00");
    else if(dd > 0 && dd < 10) 
        printChar('0');
    printInt(dd);
    print(" ");
    
    gettime();
    hh = BCD2DEC(ch1);
    if(hh == 0) 
        print("00");
    else if(hh >0 && hh < 10) 
        printChar('0');
    printInt(hh);
    printChar(':');
    mmm = BCD2DEC(ch2);
    if(mmm == 0) 
        print("00");
    else if(mmm > 0 && mmm < 10) 
        printChar('0');
    printInt(mmm);
    printChar(':');
    ss = BCD2DEC(ch3);
    if(ss == 0) 
        print("00");
    else if(ss > 0 && ss < 10) 
        printChar('0');
    printInt(ss);
    print("\n\n");
}
void fdetail()
{
    print("\n---------------------------------------\n\r");
    print("\n|     name     |   segNum   |    size  |\n\r");
    print("\n|     prog1    |     20     |   4058B  |\n\r");
    print("\n|     prog2    |     21     |   4069B  |\n\r");
    print("\n|     prog3    |     22     |   4076B  |\n\r");
    print("\n|     prog4    |     23     |   4063B  |\n\r");
    print("\n---------------------------------------\n\n\r");
}
void fread()
{
    readFile();
    i=0;
    while(i<insNum)
    {
        for(j = 0; j < 32; j++)
        {
            readAt(pFile);
            tem_str[j]=p;
            pFile++;
        }
        tem_str[j]='\0';
        i++;
    }
    pFile=0;
}

void runPro()
{
    for(j = 4;j < strlen(input);++j)
    {
        if(input[j] < '1' || input[j] > '4')
        {
            print("Can't find program! Please input one number of 1,2,3,4!\n\n");
            return ;
        }
    }

    for(j = 4;j < strlen(input);++j)
    {
        if(input[j] == ' ') 
            continue;
        else if(input[j] >= '1' && input[j] <= '4')
        {
            p = input[j] - '0' + 2;
            run();
        }
    }
    return;
}
void batch()
{
    int j;
    for(j = 4;j < strlen(tem_str);++j)
    {
        if(tem_str[j] == ' ') 
            continue;
        else if(tem_str[j] >= '1' && tem_str[j] <= '4')
        {
            p = tem_str[j] - '0' + 2;
            run();
        }
    }
}
void help()
{
    print("\r\n        You can uses these instructions:\n\n\r");
    print("ls: Show the files's size and name\r\n");
    print("clean: Clear the screen       time: Get the time\r\n");
    print("run: Run any number of program  e.g: run 2 or run 2431\n\r");
    print("run_plus: Run programs at the same time e.g: run_plus 1234\n\r");
    print("int 33h    int 34h    int 35h    int 36h\n\r");
    print("int 21h+function_number e.g: int 21h 1\n\r");
}
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
void upper(char *word)
{
	while(*word != '\0')
	{
		if(*word >= 'a' && *word <= 'z')
			*word = (*word)-32;
		word++;
	}
}

void lower(char *word)
{
	while(*word != '\0')
	{
		if(*word >= 'A' && *word <= 'Z')
			*word = (*word)+32;
		word++;
	}
}

void test21h(char op)
{
    switch (op)
    {
    case '0':
        int21h_0();
        init();
        break;
    case '1':
        print("\n\rinput your string:\n\r");
        getline(input,50);
        print("\n\r21h_1 print:\n\r");
        int21h_1(input);
        print("\n\r");
        break;
    case '2':
        print("\r\nPlease input a sentence:\n\r");
		getline(input,50);
        int21h_2(input);
        print(input);
        print("\r\n");
        break;
    case '3':
        print("\r\nPlease input a sentence:\n\r");
		getline(input,50);
        int21h_3(input);
        print(input);
        print("\r\n");
        break;
    case '4':
        print("\r\nplease input your bin number:\n\n\r");
        getline(input,10);
        print("\r\n");
        pFile=int21h_4(input);
        printInt(pFile);
        print("\r\n");
        break;
    case '5':
        print("\r\nplease input your hex number:\n\n\r");
        getline(input,4);
        print("\r\n");
        pFile=int21h_5(input);
        printInt(pFile);
        print("\r\n");
        break;
    default:
        break;
    }
}
void Delay()
{
	int i = 0;
	int j = 0;
	for( i=0;i<10000;i++ )
		for( j=0;j<10000;j++ )
		{
			j++;
			j--;
		}
}
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
		else if(input[j]>'0'&&input[j]<='9')
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
void BIOSCall()
{
    p = 8;
    run();
}
void init_Pro()
{
	PCBInit(&PCB_Queue[0],0x1000,0x1400);
	PCBInit(&PCB_Queue[1],0x2000,0x1400);
	PCBInit(&PCB_Queue[2],0x3000,0x1400);
	PCBInit(&PCB_Queue[3],0x4000,0x1400);
	PCBInit(&PCB_Queue[4],0x5000,0x1400);
	PCBInit(&PCB_Queue[5],0x6000,0x1400);
}
cmain()
{
    init();
    setClock();
    while(1)
    {
        print("\rheze-os#");
        getline(input,20);
        init_Pro();
        if(strcmp(input,"time")) 
        {
            time();
        }
        else if(strcmp(input,"clean"))
        {
            init();
        }
        else if(substr(input,tem_str,0,8) && strcmp(tem_str,"run_plus"))
        {
            process();
            Delay();
			init();
        }
        else if(substr(input,tem_str,0,3) && strcmp(tem_str,"run"))
        {
            runPro();
            init();
        }
        else if(strcmp(input,"help"))
        {
            help();
        }
        else if (strcmp(input,"ls")) 
        {
            fdetail();
        }
        else if(strcmp(input,"int 33h"))
        {
            int33h();
            init();
        }
        else if(strcmp(input,"int 34h"))
        {
            int34h();
            init();
        }
        else if(strcmp(input,"int 35h"))
        {
            int35h();
            init();
        }
        else if(strcmp(input,"int 36h"))
        {
            int36h();
            init();
        }
        else if(substr(input,tem_str,0,7) && strcmp(tem_str,"int 21h"))
        {
            test21h(input[8]);
        }
        else
        {
            print("Cat't find the Command: ");
            print(input);
            print("\n\n");
        }
    }
}

