extern void cls();
extern void printchar();
extern void getchar();
extern void gettime();
extern void run();
extern void run33();
extern void run34();
extern void run35();
extern void run36();
extern void showOUCH();
extern void upper();
extern void lower();
extern void int21h_call33h();
extern void int21h_call34h();
extern void int21h_call35h();
extern void int21h_call36h();
extern void int21h_run4prog();
extern void int21h_showdata();

char in;
char num;
char hour,min,sec;
char input[100],output[100],buf[100];
int i,j,tmp;

typedef struct{
	char name[20];
	char size[20];
	char index[5];
}table;

table t[5]={
	{"program1","2618Bytes ","24"},
	{"program2","2625Bytes ","25"},
	{"program3","2623Bytes ","26"},
	{"program4","2628Bytes ","27"},
	{"myos    ","1090Bytes ","2-10"}
};

void print(char *str)
{
	while(*str != '\0'){
		printchar(*str);
		str++;
	}
}

int getline(char str[],int len)
{
	if(!len)
		return 0;
	i=0;
	getchar();
	while(in!='\n'&&in!='\r') {
		int k=in;
		if(k==8){
			i--;
			getchar();
			continue;
		}
		printchar(in);
		str[i++]=in;
		if(i==len){
			str[i]='\0';
			printchar('\n');
			return 0;
		}
		getchar();
	}
	str[i]='\0';
	print("\n\r");
    return 1;
}

int strcmp(char* str1,char* str2)
{
	while(*str1!='\0'&&*str2!='\0'){
		if(*str1!=*str2)
			return 0;
		str1++;
		str2++;
	}
	if(*str1=='\0'&&*str2=='\0')
		return 1;
	return 0;
}

void strcpy(char src[],char dest[])
{
	i=0;
	while(src[i]!='\0'){
		dest[i]=src[i];
		i++;
	}
	dest[i]='\0';
}


int substr(char src[],char dest[],int begin,int len)
{
	for(i=begin; i<begin+len; i++)
		dest[i-begin] = src[i];
	dest[begin+len]='\0';
}

int strlen(char str[])
{
	i=0;
	while(str[i]!='\0')
		i++;
	return i;
}

void printInt(int n)
{
	i=0;
	while(n){
		tmp=n%10;
		output[i++]='0'+tmp;
		n/=10;
	}
	for(j=0; j<i; j++)
		buf[j]=output[i-j-1];
	for(j=0; j<i; j++)
		output[j]=buf[j];
	output[i]='\0';
	print(output);
}

void time()
{
	gettime();
	tmp=hour/16*10+hour%16;
	if(tmp==0)
		print("00");
	else if(tmp>0 && tmp<10)
		printchar('0');
	printInt(tmp);
	printchar(':');
	tmp=min/16*10+min%16;
	if(tmp==0)
		print("00");
	else if(tmp>0 && tmp<10)
		printchar('0');
	printInt(tmp);
	printchar(':');
	tmp=sec/16*10+sec%16;
	if(tmp==0)
		print("00");
	else if(tmp>0 && tmp<10)
		printchar('0');
	printInt(tmp);
	print("\r\n\n");
}

void ChooseToRun()
{
	for(j=4; j<strlen(input); j++){
		if(input[j]<'1' || input[j]>'4'){
            print("Sorry! There is no such program!\n\n");
			return;
		}
	}
	for(j = 4; j<strlen(input); j++){
		if(input[j]==' ')
			continue;
		else if(input[j]>='1' && input[j]<='4'){
			num=input[j]-'0'+7;
			run();
		}
	}
}

to_upper(char *p)
{
	while(*p!='\0'){
		if(*p>='a' && *p<='z')
			*p=*p-32;
		p++;
	}
}

to_lower(char *p)
{
	while(*p!='\0'){
		if(*p>='A' && *p<='Z')
			*p=*p+32;
		p++;
	}
}

void to_run_myprogram()
{
	for(j = 1; j<=4; j++){
		num=j+7;
		run();
	}
}

void help_21h()
{
	cls();
	print("@This is INT 21h\n\r");
	print("@Please select the function number\n\n\r");
	print("    #0 : show OUCH!\n\r");
	print("    #1 : lower to upper                   #2 : upper to lower\n\r");
	print("    #3 : call INT 33h                     #4 : call INT 34h\n\r");
	print("    #5 : call INT 35h                     #6 : call INT 36h\n\r");
	print("    #7 : run my program 1-4               #8 : show my information\n\r");
	print("    #9 : quit INT 21h\r\n\r\n");
}

void call21h()
{
	help_21h();
	while(1)
	{
		print(">>>");
		getline(input,20);
	    if(strcmp(input,"0")){
			showOUCH();
			help_21h();
		}
	    else if(strcmp(input,"1"))
		{
			print("Please enter a sentence:");
			getline(input,30);
			upper(input);
			print(input);
			print("\r\n\n");
		}
	    else if(strcmp(input,"2"))
		{
			print("Please enter a sentence:");
			getline(input,30);
			lower(input);
			print(input);
			print("\r\n\n");
		}
	    else if(strcmp(input,"3")){
			int21h_call33h();
			help_21h();
		}
	    else if(strcmp(input,"4")){
			int21h_call34h();
			help_21h();
		}
	    else if(strcmp(input,"5")){
			int21h_call35h();
			help_21h();
		}
	    else if(strcmp(input,"6")){
			int21h_call36h();
			help_21h();
		}
		else if(strcmp(input,"7")){
			int21h_run4prog();
			help_21h();
		}
		else if(strcmp(input,"8")){
			int21h_showdata();
			help_21h();
		}
	    else if(strcmp(input,"9"))
			break;
	}
}



void help()
{
    cls();
    print("Welcome to HeZe's operating system.\n\r");
    print("Just input the name of the instructions.\n\r\n");
    print("name: Show the files's name    size: Show the files's size and name\r\n");
    print("clean: Clear the screen       time: Get the time\r\n");
    print("author: Show the author of this operating system\r\n");
    print("run: Run any number of program  e.g: run 2 or run 2431\n\r");
    print("Quick CMD: a.cmd: Execute program 1-4 sequentially.\n\r");
    print("           b.cmd: Execute a.cmd then get the time\n\r");
    print("           c.cmd: Show the file name & size & disk\n\r");
    print("Others: int 21h , int 33h , int 34h , int 35h , int 36h\n\n\r");
}

void myos(){
	help();
	while(1)
	{
        print("Please enter your instruction:");
	    getline(input,30);
	    if(strcmp(input, "name")){
	    	print("[NAME]\r\n");
	    	for(i=0;i<5;i++){
	    		print(t[i].name); print("\r\n");
			}
	    	print("\n");
		}
		else if(strcmp(input, "size")){
	    	print("[NAME]    [SIZE]\r\n");
	    	for(i=0;i<5;i++){
	    		print(t[i].name); print("  ");
	    		print(t[i].size); print("\r\n");
	    	}
	    	print("\n");
		}
		else if(strcmp(input, "author"))
            print("18340052 HeZe\r\n\n");
	    else if(strcmp(input,"time"))
			time();
		else if(strcmp(input,"clean"))
			help();
		else if(strcmp(input,"a.cmd")){
			for(i=1;i<=4;i++){
				num=i+14;
				run();
			}
			help();
		}
		else if(strcmp(input,"b.cmd")){
			for(i=1;i<=4;i++){
				num=i+14;
				run();
			}
			help();
			time();
		}
		else if(strcmp(input,"c.cmd")){
	    	print("[NAME]    [SIZE]        [DISK]\r\n");
	    	for(i=0;i<5;i++){
	    		print(t[i].name); print("  ");
	    		print(t[i].size); print("    ");
	    		print(t[i].index); print("\r\n");
			}
			print("\n");
		}
		else if(substr(input,buf,0,3) && strcmp(buf,"run")){
			ChooseToRun();
			help();
		}
		else if(strcmp(input,"int 21h")){
			call21h();
			help();
		}
		else if(strcmp(input,"int 33h")){
			run33();
			help();
		}
		else if(strcmp(input,"int 34h")){
			run34();
			help();
		}
		else if(strcmp(input,"int 35h")){
			run35();
			help();
		}
		else if(strcmp(input,"int 36h")){
			run36();
			help();
		}
	    else
			print("Can't find the function, please try again.\r\n\n");
	}
}
