#include <iostream>
#include <Windows.h>
#include <string>
#include <vector>

int main()
{
	setlocale(LC_ALL, "rus"); // Установить русский язык для консоли

	std::wstring filePath;
	std::cout << "Введите полный путь до файла: ";
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
	
	HANDLE hOutputFile = CreateFileW(L"output.bmp", GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, 0, NULL);
	if (hOutputFile == INVALID_HANDLE_VALUE) {
		std::cerr << "Ошибка создания выходного файла!\n";
		return 1;
	}

	BITMAPFILEHEADER bmpFileHeader; // Заголовок файла, хранит общую информацию о файле 
	BITMAPINFOHEADER bmpInfoHeader; // Заголовок растра, содержит информацию о размерах изображения и глубине цвета
	DWORD RW; // Количество прочитанных байтов

	ReadFile(hInputFile, &bmpFileHeader, sizeof(bmpFileHeader), &RW, NULL); // Прочитать заголовок файла
	ReadFile(hInputFile, &bmpInfoHeader, sizeof(bmpInfoHeader), &RW, NULL); // Прочитать инфу растра

    // Проверяем, что исходный файл имеет глубину цвета 8 бит
    if (bmpInfoHeader.biBitCount != 8) {
        std::cout << "Формат файла " << bmpInfoHeader.biBitCount << std::endl;
        std::cerr << "Входной файл должен быть в формате 8 бит." << std::endl;
        CloseHandle(hInputFile);
        CloseHandle(hOutputFile);
        return 1;
    }

    int width = bmpInfoHeader.biWidth;
    int height = bmpInfoHeader.biHeight;

    // Читаем палитру
    RGBQUAD palette[256];
    ReadFile(hInputFile, palette, 256 * sizeof(RGBQUAD), &RW, NULL);

    // Устанавливаем указатель на начало растровых данных
    // bmpFileHeader.bfOffBits - Смещение до начала растровых данных.
    SetFilePointer(hInputFile, bmpFileHeader.bfOffBits, NULL, FILE_BEGIN);

    // Вычисляем размер растровых данных
    int rowPadding = (4 - (width % 4)) % 4; // Выравнивание строк по 4 байта
    int inputRowSize = (width + rowPadding); // Размер строки в байтах для 8-битного формата
    int outputRowSize = width * 3; // Размер строки в байтах для 24-битного формата

    // Выделяем память для растровых данных
    std::vector<BYTE> inputRow(inputRowSize);
    std::vector<RGBTRIPLE> outputRow(width);

    // Преобразуем каждую строку
    std::vector<RGBTRIPLE> outputPixels;
    outputPixels.reserve(width * height);

    for (int y = 0; y < height; ++y) {
        // Читаем строку из входного файла
        ReadFile(hInputFile, inputRow.data(), inputRowSize, &RW, NULL);

        // Преобразуем индексы пикселей в RGB
        for (int x = 0; x < width; ++x) {
            BYTE index = inputRow[x];
            outputRow[x].rgbtRed = palette[index].rgbRed;
            outputRow[x].rgbtGreen = palette[index].rgbGreen;
            outputRow[x].rgbtBlue = palette[index].rgbBlue;
        }

        // Добавляем строку в выходные данные
        outputPixels.insert(outputPixels.end(), outputRow.begin(), outputRow.end());
    }

    // Обновляем заголовки для 24-битного формата
    bmpFileHeader.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + outputPixels.size() * 3;
    bmpFileHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);

    bmpInfoHeader.biBitCount = 24; // Глубина цвета: 24 бита
    bmpInfoHeader.biClrUsed = 0;   // Нет палитры
    bmpInfoHeader.biCompression = BI_RGB; // Без сжатия
    bmpInfoHeader.biSizeImage = outputPixels.size() * 3; // Размер растровых данных

    // Записываем заголовки в выходной файл
    WriteFile(hOutputFile, &bmpFileHeader, sizeof(bmpFileHeader), &RW, NULL);
    WriteFile(hOutputFile, &bmpInfoHeader, sizeof(bmpInfoHeader), &RW, NULL);

    // Записываем растровые данные
    WriteFile(hOutputFile, outputPixels.data(), outputPixels.size() * 3, &RW, NULL);

    // Закрываем файлы
    CloseHandle(hInputFile);
    CloseHandle(hOutputFile);

    std::cout << "Преобразование в 24 бита завершено!" << std::endl;
    return 0;

}
