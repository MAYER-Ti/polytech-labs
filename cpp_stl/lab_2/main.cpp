// Лютов А.В. 30022
// Задание
//1. Прочитать содержимое текстового файла. Файл может содержать:
//    a. Слова – состоят из латинских строчных и заглавных букв, а также цифр, длинна слова должна быть не более 20 символов
//    b. Знаки препинания – «.», «,» «!» «?» «:» «;»
//    c. Пробельные символы – пробел, табуляция, символ новой строки.

//2. Отформатировать текст следующим образом:
//    a. Не должно быть  пробельных символов отличных от пробела
//    b. Не должно идти подряд более одного пробела
//    c. Между словом и знаком препинания не должно быть пробела
//    d. После знака препинания всегда должен идти пробел
//    e. Слова длиной более 10 символов заменяются на слово «Vau!!!»

//3. Преобразовать полученный текст в набор строка, каждая из которых содержит целое количество строк (слово должно целиком находиться в строке) и ее длинна не превышает 40 символов.

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <cctype>

// Функция для проверки, является ли символ знаком препинания
bool isPunctuation(char c) {
    return c == '.' || c == ',' || c == '!' || c == '?' || c == ':' || c == ';';
}

// Функция для форматирования текста
std::string formatText(const std::string& input) {
    std::string result = input;

    // Заменяем другие пробельные символы (оставляем только пробелы)
    size_t pos = 0;
    while ((pos = result.find_first_of("\t\n\r")) != std::string::npos) {
        result.replace(pos, 1, " ");
    }

    // Убираем дублирующиеся пробелы
    pos = 0;
    while ((pos = result.find("  ", pos)) != std::string::npos) {
        result.erase(pos, 1);
    }

    // Убираем пробелы перед знаками препинания
    for (char punct : {'.', ',', '!', '?', ':', ';'}) {
        while ((pos = result.find(" " + std::string(1, punct))) != std::string::npos) {
            result.erase(pos, 1);
        }
    }

    // Добавляем пробелы после знаков препинания
    for (char punct : {'.', ',', '!', '?', ':', ';'}) {
        std::string punctStr(1, punct);
        while ((pos = result.find(punctStr + " ")) == std::string::npos &&
               (pos = result.find(punctStr)) != std::string::npos) {
            result.insert(pos + 1, " ");
        }
    }

    return result;
}

// Функция для замены длинных слов на "Vau!!!"
std::string replaceLongWords(const std::string& input) {
    std::string result = input;
    size_t start = 0;

    while (start < result.size()) {
        size_t end = result.find_first_of(" .,!?;:\n", start);

        if (end == std::string::npos) {
            end = result.size();
        }

        std::string wordToReplace("Vau!!!");
        size_t max_len = 10;

        std::string word = result.substr(start, end - start);
        if (word.length() > max_len) {
            result.replace(start, word.length(), wordToReplace);
            end = start + wordToReplace.size();
        }

        start = end + 1;
    }

    return result;
}

// Функция для разбиения текста на строки длиной до 40 символов
std::vector<std::string> splitIntoLines(const std::string& input, size_t maxLineLength) {
    std::vector<std::string> lines;
    std::string currentLine;

    size_t start = 0;
    while (start < input.size()) {
        size_t spacePos = input.find_last_of(' ', start + maxLineLength);

        if (spacePos == std::string::npos || spacePos < start) {
            spacePos = input.find_first_of(' ', start);
        }

        if (spacePos == std::string::npos) {
            spacePos = input.size();
        }

        lines.push_back(input.substr(start, spacePos - start));
        start = spacePos + 1;
    }

    return lines;
}

int main() {
    // Открываем файл для чтения
    std::ifstream file("../lab_2/main.cpp"); //
    if (!file.is_open()) {
        std::cerr << "Ошибка открытия файла data.txt" << std::endl;
        return 1;
    }

    // Читаем весь файл в одну строку
    std::string text((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
    file.close();

    std::cout << "\n\nИсходный текст:\n\n" << text << std::endl;

    // Форматируем текст
    std::string formattedText = formatText(text);


    std::cout << "\n\nОтформатированный текст:\n\n" << formattedText << std::endl;

    std::cout << "\n\nТекст с заменой длинных слов:\n\n" << replaceLongWords(formattedText);

    // Разбиваем текст на строки длиной до 40 символов
    std::vector<std::string> lines = splitIntoLines(formattedText, 40);

    std::cout << "\n\nФорматированный текст, разбитый на строки длинной 40 символов:\n\n";
    // Выводим результат
    for (const auto& line : lines) {
        std::cout << line << std::endl;
    }

    return 0;
}
