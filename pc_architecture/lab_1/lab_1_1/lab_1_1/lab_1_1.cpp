#include <iostream>
#include <Windows.h>
#include <string>

int main()
{
    setlocale(LC_ALL, "rus"); // Установить русский язык для консоли

    std::wstring filePath;
    std::cout << "Введите путь до файла: "; 
    std::wcin >> filePath;

    // Открыть файл filePath.c_str()
    // GENERIC_READ - Файл открывается только для чтения
    // FILE_SHARE_READ - Разрешает другим процессам читать этот файл одновременно
    // OPEN_EXISTING - Открывает существующий файл
    HANDLE hInputFile = CreateFileW(filePath.c_str(), GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
    if (hInputFile == INVALID_HANDLE_VALUE) {
        std::cerr << "Ошибка открытия файла!\n";
        return 1;
    }
    
    BITMAPFILEHEADER bmpFileHeader; // Заголовок файла, хранит общую информацию о файле 
    BITMAPINFOHEADER bmpInfoHeader; // Заголовок растра, содержит информацию о размерах изображения и глубине цвета
    DWORD RW; // Количество прочитанных байтов

    ReadFile(hInputFile, &bmpFileHeader, sizeof(bmpFileHeader), &RW, NULL); // Прочитать заголовок файла
    ReadFile(hInputFile, &bmpInfoHeader, sizeof(bmpInfoHeader), &RW, NULL); // Прочитать инфу растра

    // Вывод размера и глубины палитры
    std::cout << "Ширина: " << bmpInfoHeader.biWidth << " пикселей\n" <<
                 "Высота: " << bmpInfoHeader.biHeight << " пикселей\n" << 
                 "Глубина цвета: " << bmpInfoHeader.biBitCount << " бит/пиксель\n";
    
    CloseHandle(hInputFile); // Закрыть дескриптор файла

    return 0;
}
