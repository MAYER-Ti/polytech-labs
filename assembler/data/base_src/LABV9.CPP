/* Lab:  Ass, BIOS  and  Ci functions
  ������ �ணࠬ�� ��� ࠡ��� � �������⥬��   Labv9
  ����᪨� ०���
   */
#include <graphics.h>
#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

#include <time.h>;

union REGS r;

void main()
{
// ��⠭ ����� �����०���
 int j,i,ii,color=0;
   r.h.ah=0x0;
   r.h.al=0x13;
//_asm int 0x10;
     int86(0x10,&r,&r);
 // �뢮� 梥⭮�� �����
   for( j =1 ; j <319  ; j ++)
     { color=color+1;
	 _AH=0x0c;
	 _AL=color;
	   if(color==256) color=0;
	 _BH=0;
	 _DX=50;
	 _CX=j;
    geninterrupt(0x10);
     }
   getch();

//��९ணࠬ��஢���� ⠡���� �������
  ii=clock();
   for( i = 0 ; i < 255 ; i++)
  { _AH=0x10;
    _AL=0x10;
    _BX=i; // ����� ॣ����
    _CH=i; /* G */
    _CL=i; /* B */
    _DH=i; /* R */
    geninterrupt(0x10);
  }		/*  */
   color=256;
    i=clock()-ii;

// �뢮� ����⮭����� �����
    for( j =1 ; j <319  ; j ++)  /*  */
  { color=color-1;
  _AH=0x0c;
  _AL=color;
  if(color==0) color=256;
  _BH=0;
  _DX=100; // ��ப� �뢮��
  _CX=j;
    geninterrupt(0x10);
  }
//     printf("�६� ��९ணࠬ��஢���� ⠡� ������ : %d",i);
     getch();

// �������
// 1  �������� ����⮭���� ���� ���� 梥⮬
// 2  �뢥��� ���� � ०��� ��אַ� ࠡ��� � ����� �������
// (������ ��� �ணࠬ�� �뢮�� �������� ����, ��稭�� � a0000)
// 3  ������� �६� �뢮�� � ��९ணࠬ��� ⠡� ������� �ᯮ���� i=clock()
// 4  �ਤ㬠�� ����ࠪ��� �������, �뢥�� ��᪮�쪮
//    梥⮢�� ����쥢 � 横���᪨ ��९ணࠬ����� ⠡� �������
  return;
}