/*                       LAB6
		������ୠ� ࠡ�� �� ⥬�
		  "�ணࠬ��� ���뢠���"


�� �맮�� �㭪樨 - ���뢠��� �� ��, �ᯮ������ INT.
� �裡 � �⨬ �⥪ ���������� ��᪮�쪮 ����.
� �⥪� ��࠭����� ���祭�� IP, �S (ᥣ���� ����),�� �㤠 ��뢠����
���뢠���, � 䫠��.
��室 �� INT �����⢫���� � ������� IRet,����� �뭨���� �� �⥪�
�� ���� ॣ���஢ CS, IP � 䫠���.
��� �� �� �맮�� ���뢠���,䫠��� ���뢠��� i � t
��⠭���������� � 0, �� ����頥� �맮� ���� ��㣨� ���뢠���,
� ⠪�� ����頥� ����஢��.
*/
#include<stdio.h>
#include<dos.h>
#include<iostream.h>
#include <conio.h>

void interrupt (*old)(...);     // ����� �㤥� ��࠭��� ���� �����
void interrupt outProc(...)     // � �� ��� ��ࠡ��稪
{
  cout<<"Call procedure from interrupt";
  getch();

}
void interrupt func_div_zero(...){
  cout<<"Error div zero\n";
  cout<<"Skip\n";
  asm{
    mov ax, [bp+18]
    add ax, 2 // ��९ਣ����� �� ᫥������ ��������

    mov [bp+18], ax
  }
  cout<<"Skipped instruction\n";
}

void main(void)
{
  clrscr();
  //call interrupt for display message
  // �맮� ���뢠��� � ������� geninterrupt;
  // ��� ᢮������� ���뢠��� 0xf0
  old=getvect(0xf0);
  disable();
  setvect(0xf0,outProc);
  enable();

  geninterrupt(0xf0);

  setvect(0xf0,old);



  // �맮� ���뢠��� ������� �� 0
  // ��� ���뢠��� ������� �� 0 �� 0x00
  old=getvect(0x00);
  disable();

  setvect(0x00,func_div_zero);
  enable();

  int a = 1;
  a=a/0;

  setvect(0x00,old);
  getch();
  cout<<"a = "<<a<<"\n";
  return;
  }
