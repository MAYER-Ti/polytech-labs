#include "haveEqualsChar.h"
#include <iostream>

bool haveEqualsChar(const char *str1, const char *str2)
{
    while(*str1){
        const char* ptmp = str2;
        while(*ptmp) {
            if(*str1 == *ptmp){
                return true;
            }
            ptmp++;
        }
        str1++;
    }
    return false;
}

bool haveEqualsChar(const std::string& str1, const std::string& str2)
{
    int len = str1.length();
    for (int i = 0; i < len; i++) {
        if (str2.find(str1[i]) != std::string::npos) {
            return true;
        }
    }

    return false;
}
