#include <iostream>
#include <fstream>
#include "haveEqualsChar.h"

/// Лютов А.В. 30022 Вариант 13
/// Задание:
///  Проверить, есть ли в двух заданных строках одинаковые символы. Функция должна
///  возвращать true, если есть одинаковые символы, false – в противном случае
/// Примечание:
///  В функциях разрешается использовать библиотечные функции из <cctype> и методы класса
///  string, но запрещается(!) пользоваться функциями из <cstring>.
///

int main()
{
    const int MAX_N_STRING = 256;
    char* pBuffer = nullptr;
    char* pBuffer2 = nullptr;

    try {
        pBuffer = new char[MAX_N_STRING];
        pBuffer2 = new char[MAX_N_STRING];
        bool isEvenRow = false;
        std::ifstream file("./input.txt");
        if(file.is_open()){
            while(file.getline((isEvenRow)?(pBuffer2):(pBuffer), MAX_N_STRING)){
                if(isEvenRow){
                    std::cout << "Строка 1: " << pBuffer << '\n' <<
                                 "Строка 2: " << pBuffer2 << '\n' <<
                                 "Есть ли одниковые символы char*: " << haveEqualsChar(pBuffer, pBuffer2) << '\n' <<
                                 "Есть ли одинаковые символы std::string: " << haveEqualsChar(std::string(pBuffer), std::string(pBuffer2)) << '\n';
                }
                isEvenRow = !isEvenRow;
            }
        }
        else {
            std::cout << "Ошибка!: файл не открыт";
        }
        file.close();
        delete[] pBuffer;
        delete[] pBuffer2;
    } catch (...) {
        delete[] pBuffer;
        delete[] pBuffer2;
        std::cout << "Ошибка выделения памяти!";
        return 1;
    }


    return 0;
}
