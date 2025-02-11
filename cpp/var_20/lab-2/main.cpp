#include <iostream>
#include <fstream>
#include <cctype>
#include <map>
#include <cstring>

/// Сусликов В.А. 30022 Вариант 20
/// Задание:
///  Сформировать новую строку, содержащую все латинские буквы, присутствующие в двух
///  заданных строках. Заглавные и строчные буквы не различаются. В итоговой строке буквы
///  должны встречаться по одному разу и следовать в порядке возрастания их кодов ASCII.
/// Примечание:
///  В функциях разрешается использовать библиотечные функции из <cctype> и методы класса
///  string, но запрещается(!) пользоваться функциями из <cstring>.
///

void getSortedInAsciiEqualChars(const char* str1, const char* str2, char* sortedEqualChars){
    static const int MAX_CODE_ASCII = 128;
    int iEqualChars = 0;
    std::map<char, int> alphas;

    while(*str1){
        if((32 < static_cast<int>(*str1)) && (static_cast<int>(*str1) < MAX_CODE_ASCII)){
            alphas[(*str1)]++;
        }
        str1++;
    }
    while(*str2){
        if((32 < static_cast<int>(*str2)) && (static_cast<int>(*str2) < MAX_CODE_ASCII)){
            alphas[(*str2)]++;
        }
        str2++;
    }
    std::cout << "size " << alphas.size() << "\n";
    // 0й символ ASCII это конец строки
    for(int iC = 32; iC < MAX_CODE_ASCII; ++iC){
        auto itC = alphas.find(iC);
        if(itC != alphas.end()){
            std::cout << static_cast<char>(itC->first) << "\n";
            if(itC->second > 1){
                sortedEqualChars[iEqualChars] = itC->first;
                iEqualChars++;
            }
        }
    }
    sortedEqualChars[iEqualChars] = '\0';
}

int main()
{
    const int   MAX_N_STRING = 256;
    char*       pBuffer      = new char[MAX_N_STRING];
    char*       pBuffer2     = new char[MAX_N_STRING];
    char*       pBufferOut   = new char[MAX_N_STRING];

    //Чтение исходных данных
    std::ifstream file("input.txt");
    if(file.is_open()){
        file.getline(pBuffer, MAX_N_STRING);
        file.getline(pBuffer2, MAX_N_STRING);
    }
    else {
        std::cout << "Ошибка!: файл не открыт";
    }
    file.close();

    //Обработка данных
    getSortedInAsciiEqualChars(pBuffer, pBuffer2, pBufferOut);

    //Вывод обработанных данных
    std::cout << "Строка 1: " << pBuffer << '\n' <<
                 "Строка 2: " << pBuffer2 << '\n' <<
                 "Одинаковые отсортированные буквы ASCII: " << pBufferOut << '\n';

    delete[] pBuffer;
    delete[] pBuffer2;
    delete[] pBufferOut;
    return 0;
}
