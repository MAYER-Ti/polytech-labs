/*             Лабораторная работа 15
		   Saund Blaster
		   FM синтез
Задание
1. Проиграйте гамму, вызовите спецэффекты
2. Сыграйте мелодию
*/
#include <stdio.h>
#include <dos.h>
#include <conio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define KEYON    0x20     // key-on bit in regs b0 - b8
#define FM       8        // SB (mono) ports (e.g. 228H and 229H)

unsigned IOport=544;        // Sound Blaster port address

void mydelay(unsigned long clocks)
//     time = clocks / 2386360
{
   unsigned long elapsed=0;
   unsigned int last,next,ncopy,diff;

   /* Read the counter value. */
   outp(0x43,0);                              /* want to read timer 0 */
   last=inp(0x40);                            /* low byte */
   last=~((inp(0x40)<< 8) + last);            /* high byte */

   do {
      /* Read the counter value. */
      outp(0x43,0);                           /* want to read timer 0 */
      next=inp(0x40);                         /* low byte */
      ncopy=next=~((inp(0x40)<< 8) + next);   /* high byte */

      next-=last;      /* this is now number of elapsed clock pulses since last read */

      elapsed += next; /* add to total elapsed clock pulses */
      last=ncopy;
   } while (elapsed<clocks);
}

void FMoutput(unsigned port, int reg, int val)
/* This outputs a value to a specified FM register at a specified FM port. */
{
   outp(port, reg);
   mydelay(8);          /* need to wait 3.3 microsec */
   outp(port+1, val);
   mydelay(55);         /* need to wait 23 microsec */
}



void fm(int reg, int val)
/* This function outputs a value to a specified FM register at the Sound
 * Blaster (mono) port address.
 */
{
   FMoutput(IOport+FM, reg, val);
}


void outdsp (unsigned char ch)
{
     while (inportb(0x022C)&0x80);
     outportb(0x022C,ch);
}

void midimain(void)
{
   int i,val1,val2;

   int block,b,m,f,fn;

   clrscr();

   printf("Program compiled for Sound Blaster 1.0 - 2.0 .\n");


   fm(1,0);        /* must initialize this to zero */

   fm(0xC0,1);     /* parallel connection */

   /***************************************
    * Set parameters for the carrier cell *
    ***************************************/

   fm(0x23,0x21);  /* no amplitude modulation (D7=0), no vibrato (D6=0),
		    * sustained envelope type (D5=1), KSR=0 (D4=0),
		    * frequency multiplier=1 (D4-D0=1)
		    */

   fm(0x43,0x0);   /* no volume decrease with pitch (D7-D6=0),
		    * no attenuation (D5-D0=0)
		    */

   fm(0x63,0xff);  /* fast attack (D7-D4=0xF) and decay (D3-D0=0xF) */
   fm(0x83,0x05);  /* high sustain level (D7-D4=0), slow release rate (D3-D0=5) */


   /*****************************************
    * Set parameters for the modulator cell *
    *****************************************/

   fm(0x20,0x20);  /* sustained envelope type, frequency multiplier=0    */
   fm(0x40,0x3f);  /* maximum attenuation, no volume decrease with pitch */

   /* Since the modulator signal is attenuated as much as possible, these
    * next two values shouldn't have any effect.
    */
   fm(0x60,0x44);  /* slow attack and decay */
   fm(0x80,0x05);  /* high sustain level, slow release rate */


   /*************************************************
    * Generate tone from values looked up in table. *
    *************************************************/

   printf("440 Hz tone, values looked up in table.\n");
   fm(0xa0,0x41);  /* 440 Hz */
   fm(0x20,0x40);

   fm(0xb0,0x32);  /* 440 Hz, block 0, key on */




   getche();

   fm(0xb0,0x12);  /* key off */


   /*********************************************************
    * Generate a range of octaves by changing block number. *
    *********************************************************/

   printf("Range of frequencies created by changing block number.\n");
   for (block=0; block<=7; block++) {
      printf("f=%5ld Hz (press Enter)\n",(long)440*(1 << block)/16);
      fm(0xB0,((fn >> 8) & 0x3) + (block << 2) | KEYON);
      getche();
   }


   /*****************************************************************
    * Generate a range of frequencies by changing frequency number. *
    *****************************************************************/

   printf("Range of frequencies created by changing frequency number.\n");
   block=4;
   for (fn=0; fn<1024; fn++) {
      fm(0xA0,(fn & 0xFF));
      fm(0xB0,((fn >> 8) & 0x3) + (block << 2) | KEYON);
      delay(1);
   }

   /*********************************
    * Attenuate the signal by 3 dB. *
    *********************************/

   getche();
   fm(0xB0,((fn >> 8) & 0x3) + (block << 2) | KEYON);
   printf("Attenuated by 3 dB.\n");
   fm(0x43,4);     /* attenuate by 3 dB */
   getche();

   fm(0xB0,((fn >> 8) & 0x3) + (block << 2));

   exit(0);
}


unsigned int x;
FILE *fp;
char buf,key;
unsigned long playtime,showtime;
unsigned char gstring[80];


int main ( int argc, char *argv[] )
{
//----------------
// Initialize DSP for Voice
//-------------
    outportb(0x0226,0x01);
    delay(3);
    outportb(0x0226,0x00);
    for(x=0;x<100;x++)
    {
	if(inportb(0x022E)&0x80)
	{
	    if(inportb(0x022A)==0xAA) break;
	}
    }
    if(x==100)
    {
	printf("Sound Blaster not found at 0220h\n");
	exit(1);
    }
//------------
// Menu
//-----------------
    clrscr();
    printf("1) Play original\n2) Play reduced\n3) FM Synth\n4) Exit\n");
    key=getch();
    if (key=='4') exit(0);
    if (key=='3') midimain();
//------------
// Read file & play
//-----------------
    clrscr();
    printf("Program compiled for Sound Blaster ver. 1.0 (8bit 44100Hz mono).\n\n");
    if (key=='1') printf("Normal play.\n");
    if (key=='2') printf("Reduced play.\n");
    printf("Playing .wav ...\n\n");
    if(argc==1)
    {
	printf(".WAV file not specified\n");
	exit(1);
    }
    strcpy(gstring,argv[1]);
    strcat(gstring,".WAV");
    if((fp=fopen(gstring,"rb"))==0)
    {
	strcpy(gstring,argv[1]);
	if((fp=fopen(gstring,"rb"))==0)
	{
	    printf("Error opening .WAV file [%s]\n",argv[1]);
	    exit(1);
	}
    }
    printf("FILE: [%s]\n",gstring);
    fseek(fp,36L,SEEK_SET);
    while (inportb(0x022C)&0x80);
    outdsp(0xD1);  //speaker on
    playtime=0;
    while (fread(&buf,1,1,fp)!=0)
    {
	if(key=='2') fread(&buf,1,1,fp);
	if(key=='2') mydelay(15);
	if(key=='2') playtime++;
	if(key=='2') showtime=playtime/100000;
	if(key=='2') if (showtime*100000== playtime) printf("Time: %u \r",showtime);
	outdsp(0x10);
	outdsp(buf);
	mydelay(15);
	playtime++;
	showtime=playtime/100000;
	if (showtime*100000== playtime) printf("Time: %u r",showtime);

    }
    outdsp(0xD3);  //speaker off
    fclose(fp);
    return 0;
};
