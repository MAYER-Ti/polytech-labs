
#include <windows.h>
#include <iostream>
#include <string>
#include <vector>



void main()
{
    std::wstring sFileName; // Хранит имя файла, которое пользователь введет с клавиатуры (широкая строка для поддержки Unicode).
    BITMAPFILEHEADER bmpFileHeader; // Структура, описывающая заголовок BMP-файла (содержит информацию о размере файла, смещении до данных растра и т.д.).
    BITMAPINFOHEADER bmpInfoHeader; // Структура, описывающая информацию о растровых данных (ширину, высоту, глубину цвета и т.д.).
    int Width, Height; // Ширина и высота изображения в пикселях
    RGBQUAD Palette[256]; // Массив из 256 элементов, каждый из которых представляет цвет в палитре(используется для создания черно - белой палитры).
    RGBTRIPLE* inBuf; //  Указатель на массив структур RGBTRIPLE, который используется для чтения пикселей исходного изображения.
    BYTE* outBuf; // : Указатель на массив байтов, который используется для записи оттенков серого в выходной файл.
    HANDLE hInputFile, hOutFile; // Дескрипторы файлов: hInputFile — входной файл, hOutFile — выходной файл.
    DWORD RW; // Переменная для хранения количества прочитанных или записанных байтов.

    std::cout << "Enter the full name, please: ";
    std::wcin >> sFileName;
    // Файла с путем sFileName.c_str() 
    // GENERIC_READ - только для чтения, 
    // FILE_SHARE_READ - другие процессы могут читать этот файл
    // OPEN_EXISTING - Открывает существующий файл
    hInputFile = CreateFileW(sFileName.c_str(), GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
    if (hInputFile == INVALID_HANDLE_VALUE)
        return;
    // Файл с путем L"Result.bmp"
    // GENERIC_WRITE - Только для записи
    // CREATE_NEW - Создать новый
    hOutFile = CreateFileW(L"Result.bmp", GENERIC_WRITE, 0, NULL, CREATE_NEW, 0, NULL);
    if (hOutFile == INVALID_HANDLE_VALUE)
    {
        CloseHandle(hInputFile);
        return;
    }

    // Считываем инфу
    // Считывается заголовок BMP (BITMAPFILEHEADER) в bmpFileHeader
    ReadFile(hInputFile, &bmpFileHeader, sizeof(bmpFileHeader), &RW, NULL);
    // Считывается информация о растровых данных (BITMAPINFOHEADER) в переменную bmpInfoHeader
    ReadFile(hInputFile, &bmpInfoHeader, sizeof(bmpInfoHeader), &RW, NULL);

    // Установим указатель на начало растра
    // bmpFileHeader.bfOffBits - Смещение до начала растровых данных
    SetFilePointer(hInputFile, bmpFileHeader.bfOffBits, NULL, FILE_BEGIN);
    // Ширина изображения в пикселях
    Width = bmpInfoHeader.biWidth;
    // Высота изображения в пикселях
    Height = bmpInfoHeader.biHeight;

    // Выделим память
    // Выделяется память для хранения строки пикселей исходного изображения
    inBuf = new RGBTRIPLE[Width];
    // Выделяется память для хранения строки пикселей выходного изображения (в градациях серого)
    outBuf = new BYTE[Width];

    // Заполним заголовки
    // Новое смещение до начала растровых данных (учитывает палитру)
    bmpFileHeader.bfOffBits = sizeof(bmpFileHeader) + sizeof(bmpInfoHeader) + 1024;
    // Глубина цвета установлена в 8 бит (256 цветов)
    bmpInfoHeader.biBitCount = 8;
    // Общий размер выходного файла
    bmpFileHeader.bfSize = bmpFileHeader.bfOffBits + Width * Height + Height * (3 * Width % 4);

    // Запишем заголовки
    WriteFile(hOutFile, &bmpFileHeader, sizeof(bmpFileHeader), &RW, NULL);
    WriteFile(hOutFile, &bmpInfoHeader, sizeof(bmpInfoHeader), &RW, NULL);
    // Палитра черно-белая
    // Создается палитра из 256 цветов, где каждый цвет представляет оттенок серого.
    // Палитра записывается в выходной файл.
    for (int i = 0; i < 256; i++)
    {
        Palette[i].rgbBlue = i;
        Palette[i].rgbGreen = i;
        Palette[i].rgbRed = i;
    }
    WriteFile(hOutFile, Palette, 256 * sizeof(RGBQUAD), &RW, NULL);

    // Начнем преобразовывать
    for (int i = 0; i < Height; i++)
    {
        // Читаем строку пикселей из входного файла
        ReadFile(hInputFile, inBuf, sizeof(RGBTRIPLE) * Width, &RW, NULL);
        // Каждый пиксель преобразуется в градацию серого с использованием формулы
        for (int j = 0; j < Width; j++)
            outBuf[j] = 0.3 * inBuf[j].rgbtRed + 0.59 * inBuf[j].rgbtGreen + 0.11 * inBuf[j].rgbtBlue;
        // Записать измененную строку в выходной файл
        WriteFile(hOutFile, outBuf, sizeof(BYTE) * Width, &RW, NULL);

        // Пишем мусор для выравнивания
        // Дополнительные байты для выравнивания строки по 4 байта
        WriteFile(hOutFile, Palette, (3 * Width) % 4, &RW, NULL);
        SetFilePointer(hInputFile, Width % 4, NULL, FILE_CURRENT);
    }

    delete[] inBuf;
    delete[] outBuf;
    CloseHandle(hInputFile);
    CloseHandle(hOutFile);

    std::cout << "Updating has come to the end successfully!" << std::endl;
    std::cout << "Result in file result.bmp" << std::endl;
    system("pause");
}