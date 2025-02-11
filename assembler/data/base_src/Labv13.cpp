/*               Лабораторная работа 13
		Видеоадаптер, графические режимы sVGA, VESA
*/
#include <dos.h>
#include <bios.h>
#include <conio.h>
#include <stdio.h>
#define LOWORD(l)	((int)(1))
#define HIWORD(l)	((int)((l) >> 16))
#define MYMODE1	     113h         //800x600x32k
#define MYMODE2	     101h         //640x480x256
#define MYMODE3	     105h //1024x768x256

  int   pattern_ust=1;
  int  current_b=0;

/*  struct Vesainfo {
	 int attr_m;
	 char attr_a;
	 char  attr_b;
	 int h_ust;
	 int size;
	 unsigned segm_a;
	 unsigned segm_b;
	 void far (*fun)();
	 int byte_str;
	 int resx;
	 int resy;
	 char  xchsize;
	 char  ychsize;
	 char  kolvo;
	 char  bit_pix;
	 char  kolvobank;
	 char  memmod;
	 char  size_bank;
	 char  pages;
	 char  reserved;
	 char  red_mask_s;
	 char  red_mask_p;
	 char  green_mask_s;
	 char  green_mask_p;
	 char  blue_mask_s;
	 char  blue_mask_p;
	 char  reserved_mask_s;
	 char  reserved_mask_p;
	 char  colour_info;
	 char  reserved2[216];
  }mine;  */


struct SvgaModeInfo
{
	unsigned  state;
	char      a_window_state;
	char      b_window_state;
	unsigned  window_multiplicity;
	unsigned  window_size;
	unsigned  a_window_segment;
	unsigned  b_window_segment;
	void far  (*fun)();
	unsigned  string_width;
	unsigned  width;
	unsigned  height;
	char      symbol_height;
	char      symbol_width;
	char      switches_count;
	char      bits_per_pixel;
	char      banks_count;
	char      memory_model;
	char      bank_size;
	char      pages_count;
	char      reserved1;
	char      red_mask;
	char      red_bit;
	char      green_mask;
	char      green_bit;
	char      blue_mask;
	char      blue_bit;
	char      reserved_mask;
	char      reserved_bit;
	char      palette_state;
	char      lfb[10];
	char      resrved2[206];
}mine;

void Bank_ust(int begin)
{
  if (begin==current_b)
   return;
  current_b=begin;
  begin *= pattern_ust;
  asm{
    mov ax,4F05h
    mov bx,0
    mov dx,begin
    push dx
    int 10h
    pop dx
	mov bx,1
    int 10h
  };
}

inline int RGBcolour(int red,int green,int blue)
{
 return ((red >> 3)<<10) | ((green >> 3)<<5) | (blue >> 3);
}
void set_text_mode()
{
	asm mov ax,0x0003
	asm int 0x10
}
void draw(int x,int y,int colour)
{
  long ttt;
  asm{
	mov dx,y   				//bank number
	shr dx,6
	mov bx,0
  };
  mine.fun();
  ttt = (y*1024%65536)+x;
  _SI = (unsigned int)ttt;
  asm{
	mov ax,colour
	mov bx,0xA000
	mov es,bx
	mov es:[si],al
  };
}

void paint(int begx,int begy,int endx,int endy,int colour)
{
  int x,y;
  for(y=begy;y<=endy;y++)
	for(x=begx;x<=endx;x++)
	  draw(x,y,colour);

}
void main()
{
  int colour,x,y;
  asm{
				   //information
	mov cx,MYMODE3
	lea di,mine
	mov ax,ds
	mov es,ax

	mov ax,0x4F01

	int 10h
  };
  asm{                           //setting of this mode
	mov ax,4F02h
	mov bx,MYMODE3
	int 10h
  };
  x=0;
  y=0;
  for(colour=1;colour<255;colour++){
   if(x>1024){
	x=0;
	y=y+48;
   }
   paint(x,y,x+64,y+48,colour);
   x=x+64;
  }
  getch();
  set_text_mode();
}
// Задание
// 1. Выведите полутоновой клин во 2 банке памяти.
// 2. Определите как располагаются банки памяти на экране.
//