/*  Labv8:  Ass,   and  Ci functions
  ������ �ணࠬ�� ��� ࠡ��� � �������⥬��
  ����⮢� ०��
*/

#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>


#include <iostream.h>

void page(char a) // ��⠭���� ����� ��⨢��� ��ᯫ����� ���.
{
  asm {
    mov ah,0x05
    mov  al,a
    int 0x10
       }

}

void main()
{
// ��⠭���� �����०���
asm{
    mov al,02h
    mov ah,00h
    int 10h
    }   page(0);
	clrscr();
// �뢮� ⥪�� �।�⢠�� ��
 for(char n = 1; n <= 100; n++)
//   -- ����� ᠬ �뢮� -

// �뮤 ⥪�� � ०��� �����।�� ࠡ��� � ������������
	page(0);
	asm mov cx,1000 //  ������ ������⢮ ᨬ�����
	asm mov di,0    //  ����塞 ������
e1:     asm { add di, 2
	   mov ax, 0xb800  // ��।��塞 ��砫�� ����
	   mov es, ax
	   mov al, cl
	   mov es: [di],al   // ����뫠�� ��� ���� ����  � �����������
	   mov al, 4
	   mov es: [di+1],al // ����뫠�� ����� ��ன ����
	 };
	asm loop e1

   getch();


// �������
// 1 �뢥��� ⥪�� � �ᯮ�� ��.
// ������ ��� ������ 梥⮬ � �ᯮ�짮������ ���.
// ��।���� �६� �뢮�� � ����� �����
// 2 �������� ࠧ��� ⥪�⮢�� ��ᯫ����� ��࠭���.(������
// �ணࠬ�� �� ��� �뢮�� ᨬ����� � ��砫� � � ���� ��ᯫ����� ��࠭���)
// 3 �뢥��� ⥪�� �� ����� ��� ��࠭���
// 4 �࣠����� ��४��祭�� ��࠭��
/* while (bioskey(1) == 0)
{
 page(0); delay(1000);

}  */
return;
}
