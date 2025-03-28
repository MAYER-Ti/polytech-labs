// Лютов А.В. 30022

// 1.	Написать программу, которая выполняет следующие действия:
// a.	Читает содержимое текстового файла
// b.	Выделяет слова, словом считаются последовательность символов разделенных пробелами и/или знаками табуляции и/или символами новой строки
// c.	Вывести список слов присутствующий в тексте без повторений (имеется в виду, что одно и то же слово может присутствовать в списке только один раз)


#include <iostream>
#include <fstream>
#include <string>
#include <set>
#include <algorithm>
#include <cctype>

// Функция для приведения слова к нижнему регистру
std::string to_lower(const std::string& str) {
    std::string lower_str = str;
    std::transform(lower_str.begin(), lower_str.end(), lower_str.begin(), ::tolower);
    return lower_str;
}

int main() {
    std::ifstream file("..\\input.txt"); //C:\polytech-labs\cpp_stl\lab_6\lab_6_1\main.cpp //"..\\input.txt"
    if (!file.is_open()) {
        std::cerr << "Error open file!" << std::endl;
        return 1;
    }

    std::set<std::string> unique_words;
    std::string word;

    while (file >> word) {
        // ::inspunct - проверка на знак препинания
        // Удаляем знаки препинания и приводим слово к нижнему регистру
        word.erase(std::remove_if(word.begin(), word.end(), ::ispunct), word.end());
        unique_words.insert(to_lower(word));
    }

    file.close();

    // Выводим уникальные слова
    for (const auto& w : unique_words) {
        std::cout << w << std::endl;
    }

    return 0;
}