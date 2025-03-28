/// Лютов А.В. 30022
/// Разработать программу, которая, используя только стандартные алгоритмы и функторы,
/// умножает каждый элемент списка чисел с плавающей  точкой на число PI
#define _USE_MATH_DEFINES
#include <iostream>
#include <algorithm>
#include <functional>
#include <cmath>
#include <list>

template<typename T>
void print(const T& val) {
    std::cout << val << " ";
}

int main()
{
    std::list<double> list { 15.0, 4.123, 6.79, 3.56, 9.98 };
    std::cout << "Sequence\n";
    std::for_each(list.begin(), list.end(), &print<double>);
    std::cout << std::endl;

    std::transform(list.begin(), list.end(), list.begin(), 
        std::bind(std::multiplies<double>(), std::placeholders::_1, M_PI));

    
    std::for_each(list.begin(), list.end(), &print<double>);
    std::cout << std::endl;

    return 0;
}
