//              ������ୠ� ����� Lab 4
//            ������. ����७�� �६���. ����
//


#include<iostream.h>
#include<conio.h>
#include<stdio.h>

void main()
{
 long int cl2,cl1,c1,c2;
 unsigned long int t1,t2,t3;

// ��������� ����⠭�� ���稪�
/* asm{
     mov ax,00110110B  // 00 11 011 0
     out 43h,ax
     mov ax,0000000000000000B
     out 40h,al
     mov al,ah
     out 40h,al
    }
 */

 // ����७�� �६��� �믮������ ��⮢�� �ணࠬ�� 1
//  � ⨪�� (� ���뢠���� �� 0-�� ������ ⠩���)
// ���稪 ⨪�� �祩�� 46� - ����訩 ���� ����
 asm{
  mov ax,0x46
  mov es,ax
  mov bx,0xC
  mov ax,[es:bx]
  mov cx,[es:(bx+2)]
 }
// �������� ��砫쭮�  ���祭�� ����襥 � ���襥 ???
// cl2=  ; cl1=  ;
 c1=cl2+cl1*0x10000;

 //���⮢�� �ணࠬ�� 1
  asm mov cx,1000
  met1: asm {
	     push cx
	     mov cx,1000
	     }
  met2: asm {
	     loop met2
	     pop cx
	     loop met1
	     }

//
 asm{
  mov ax,0x46
  mov es,ax
  mov bx,0xC
  mov ax,[es:bx]
  mov cx,[es:(bx+2)]
 }
// �������� ����筮� ���祭��  ???
// cl2=_AX; cl1=   ;
// ������� 楫�� -
c2=cl2+cl1*0x10000;

// clrscr();
// printf("\n��ࢮ� - %d\n",c1);
// printf("��஥ - %d\n",c2);
 cout<<"\n�६� �믮������ ��⮢�� �ணࠬ�� 1\n";
 cout<<"COUNTs: "<<c2-c1<<"\n";
  printf("\n   ����쪮 �����ᥪ㭤 ??");
  getch();

// ����७�� �६��� �믮������ ��⮢�� �ணࠬ��
//  �� ᮤ�ন���� ॣ���� ⠩���
//   ���� 43h - ���� �ࠢ����� ⠩��஬
//   ���� 40h - ���� ⠩���

 asm{
  mov ax,00000110B    // 00 00 011 0
  out 43h,ax  // ��⠥� ����訩, ��⮬ ���訩
  in al,40h
//  mov bl,al
  in al,40h
//  mov ah,al
//  mov al,bl
 }
 t1=_AX;


 //���⮢�� �ணࠬ�� 2
  asm mov cx,1
  met11: asm {
	     push cx
	     mov cx,1000
	     }
  met22: asm {
	     loop met22
	     pop cx
	     loop met11
	     }

  asm{
  mov ax,00000110B    // 00 00 011 0
  out 43h,ax  // ��⠥� ����訩, ��⮬ ���訩
  in al,40h
//  mov bl,al
  in al,40h
//  mov ah,al
//  mov al,bl
 }
 t2=_AX;
 t3=t1;     // ????

 clrscr();
    printf("\n��ࢮ� - %d \n",t1);
    printf("��஥ - %d\n",t2);
 cout<<"\n�६� �믮������ ��⮢�� �ணࠬ�� 2\n";
 printf("%x\n",t3);
 cout<<"CLOCKs: "<<t3<<"\n";
   printf("\n   ����쪮 ����ᥪ㭤 ??");
   getch();

// �������
// 1 ��।���� �६��� ࠡ��� ��⮢�� �ணࠬ� 1 � 2
// 2 ��९ணࠬ����� ⠩��� � ������� �६� ࠡ �ண1 ����� �筮
// 3 ��।���� �६� ����� ���� �����ﬨ �� ������ ��� (��� ����������)

//�� ��楤�� ���뢠�� ��������� ����� ��� � �ਧ��� ������
//�� �������.  ���⠩� ���ᠭ�� �ࠩ��� ��� � �ணࠬ�� Asmous.cpp.

void ReadMouse ()
{
  asm mov ax, 0x3
  asm int 0x33
  asm mov MouseB, bx
  asm mov MouseX, cx
  asm mov MouseY, dx
}


}