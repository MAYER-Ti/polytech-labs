//      "����� IBM PC � ��������ன"
//             Labv10

#include <iostream.h>
#include <stdio.h>
#include <conio.h>
#include <dos.h>
#include <bios.h>
#define Port8042 0x60

long far * pTime=(long far*)0x46C;   // �����⥫� �� ���稪 ⨪��

// ��।���� 㪠��⥫� ��砫� � ���� ����

int far * pHeadPtr=(int far  *)0x41A;   // �����⥫� �� 㪠��⥫� ������ ���.��.
int far * pTailPtr=(int far  *)0x41C;   // �����⥫� �� 㪠��⥫� 墮�� ���.��.
unsigned char far * pBuf;

void main()
{
// 3������ N1.
  clrscr();

  cout << "\n 3������ N1:\n";
  cout << "\n �������� ������ ��� ����祭�� �����!";
  cout << "\n �஡�� - ���� �����.\n";
  char cScan,cAsci;
  int iAdres;
  do
  {
   // ����㧨�� ���� ॣ���஢, ���ਬ�� ds:si ���祭��� 0x40:0x1A
	asm{
		push ds 	//
		push si         //  ���࠭��� ॣ�����
		push di         //
		mov ax,0x40     //
		mov ds,ax       //   ����㧨�� ᥣ����
		mov si,0x1A     // � 㪠��⥫� �� ������
		mov di,0x1C     // � �� 墮��
		}
	wait_kbd:
	asm{
	   mov ax,[si]     //   �ࠢ������ 㪠��⥫� -
	   cmp ax,[di]     // �.�. ���� ������
	   je wait_kbd
	// ����㧨�� ॣ���� di ���祭��� 0x1C
	// �ࠢ���� 㪠��⥫�
	// ������ 㪠��⥫�
	   mov si,[si]
	   }
	iAdres=_SI;
	// ������ ���祭�� �� ����
	asm mov ax,[si]
	// ������ _AL � _AH ᮤ�ঠ� ᪠�-��� � ASCII-���
	asm pop di
	asm pop si
	asm pop ds
	cScan=_AH;
	cAsci=_AL;
	printf("���� = %x   ���� = %d      ASCII = %d \n",iAdres,cScan,cAsci);
  } while(getch() != 32);
  cout << "\n ����� ��ࢮ�� �������. Press any key...\n";
  getch();

       delay(1000);
	 asm in al,0x60
	 cScan=0; // ??????
	 printf(" ���� = %x \n",cScan);
//	 goto met;
//
}
// �������
// 1 ������� �।�⠢������ �ணࠬ��
//  ��।���� �⫨稥 ASCII �����: �᭮���� � �㦥���� ������
// 2 ������ ���� �ணࠬ�� 横���᪮�� �⥭�� ᪠� ����� �� ���� 60
//  ��।���� �⫨稥 ᪠� �����: ������ � ���᪠��� ������
