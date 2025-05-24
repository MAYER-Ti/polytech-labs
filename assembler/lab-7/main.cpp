#include <iostream> 
using namespace std; 
 
int main() 
{ 
    float a = 10.3; 
    float b = 7.1; 
    float c = 9.1; 
    float out = 0; 
 
    // 1. Инициализация FPU и суммирование трех чисел 
    __asm 
    { 
        finit 
        fld a 
        fld b 
        fld c 
        fadd 
        fadd 
        fstp out 
    } 
    cout << "1) " << out << endl; 
 
    // 2. Получение NaN  
    __asm 
    { 
        finit 
        fstp out 
    } 
    cout << "2) " << out << endl; 
 
    // 3. Обработка деления на ноль 
    int ctrl = 0b111111111111111111; 
    a = 5; 
    b = 0; 
    __asm 
    { 
        finit 
        fldcw ctrl 
        fld a 
        fld b 
        fdiv 
        fstp out 
    } 
    cout << "3) " << out << endl; 
 
    return 0; 
}
