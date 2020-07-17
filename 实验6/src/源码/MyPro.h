#define MAX_SIZE 6

int CurPCBNum=0,processNum=0;
int current_Seg = 0x2000;

typedef enum Status{NEW,READY,RUNNING,EXIT}Status;
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

typedef struct PCB
{
	RegisterImage regImg;
	Status ProcessStatus;
}PCB;

PCB PCB_Queue[MAX_SIZE];

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
void Schedule()
{
	PCB_Queue[CurPCBNum].ProcessStatus = READY;
	CurPCBNum ++;
	if( CurPCBNum > processNum )
		CurPCBNum = 1;
	if( PCB_Queue[CurPCBNum].ProcessStatus != NEW )
		PCB_Queue[CurPCBNum].ProcessStatus = RUNNING;
	
	return;
}
PCB* Current_Process()
{
	return &PCB_Queue[CurPCBNum];
}
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

void createNewPCB()
{
	if(processNum > MAX_SIZE) 
        return;

	PCBInit( &PCB_Queue[processNum] ,processNum, current_Seg);
	processNum++;
	current_Seg += 0x1000;
}


void special()
{
	if(PCB_Queue[CurPCBNum].ProcessStatus==NEW)
		PCB_Queue[CurPCBNum].ProcessStatus=RUNNING;
}