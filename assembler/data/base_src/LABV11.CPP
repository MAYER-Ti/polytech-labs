/*              ������ୠ� ࠡ�� 11
	 �����������, ����᪨� ०��� sVGA
*/
#include <dos.h>
#include <mem.h>
#include <conio.h>

void set_mode(int mode)
{
 asm{
  mov ax,0x4f02;
  mov bx,mode ;
  int 0x10;
 }
}

void main(void)
{
set_mode(0x0112);
unsigned char c=0;
for (int i=2; i<640*4;i+=4)
{
asm {
    mov ax,0xa000;
    mov es,ax;
    mov si,i
    mov bh,c
    mov bl,c
    mov es:[si],bl

    }

    c++;
}
getch();
set_mode(0x3);
}
// �������
//��।���� � ����� ���浪� ���������� 梥� � 111 � 112 ०����
//������ �ணࠬ�� �뢮�� ����⮭����� ����� �� ���
