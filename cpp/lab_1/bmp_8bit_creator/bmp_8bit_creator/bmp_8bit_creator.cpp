#include <windows.h>
#include <iostream>
#include <vector>

// Создание палитры из 256 цветов (градиент от черного к белому)
void createPalette(RGBQUAD* palette) {
    for (int i = 0; i < 256; ++i) {
        palette[i].rgbRed = static_cast<BYTE>(i);    // Красный канал
        palette[i].rgbGreen = static_cast<BYTE>(i); // Зеленый канал
        palette[i].rgbBlue = static_cast<BYTE>(i);  // Синий канал
        palette[i].rgbReserved = 0;                // Резервное поле
    }
}

int main() {
    setlocale(LC_ALL, "rus");
    // Параметры изображения
    const int width = 256;  // Ширина
    const int height = 256; // Высота

    // Создаем выходной файл
    HANDLE hOutputFile = CreateFileW(L"test_8bit.bmp", GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, NULL);
    if (hOutputFile == INVALID_HANDLE_VALUE) {
        std::cerr << "Не удалось создать файл." << std::endl;
        return 1;
    }

    // Заполняем заголовки
    BITMAPFILEHEADER bmpFileHeader = { 0 };
    BITMAPINFOHEADER bmpInfoHeader = { 0 };

    bmpFileHeader.bfType = 0x4D42; // 'BM'
    bmpFileHeader.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + 256 * sizeof(RGBQUAD) + width * height;
    bmpFileHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + 256 * sizeof(RGBQUAD);

    bmpInfoHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmpInfoHeader.biWidth = width;
    bmpInfoHeader.biHeight = height;
    bmpInfoHeader.biPlanes = 1;
    bmpInfoHeader.biBitCount = 8; // Глубина цвета: 8 бит
    bmpInfoHeader.biCompression = BI_RGB; // Без сжатия
    bmpInfoHeader.biClrUsed = 256;        // Размер палитры
    bmpInfoHeader.biClrImportant = 256;   // Все цвета важны

    // Создаем палитру
    RGBQUAD palette[256];
    createPalette(palette);

    // Создаем данные растра (индексы палитры)
    std::vector<BYTE> rasterData(width * height);
    for (int y = 0; y < height; ++y) {
        for (int x = 0; x < width; ++x) {
            rasterData[y * width + x] = static_cast<BYTE>(x); // Градиент по горизонтали
        }
    }

    // Записываем данные в файл
    DWORD bytesWritten;
    WriteFile(hOutputFile, &bmpFileHeader, sizeof(bmpFileHeader), &bytesWritten, NULL);
    WriteFile(hOutputFile, &bmpInfoHeader, sizeof(bmpInfoHeader), &bytesWritten, NULL);
    WriteFile(hOutputFile, palette, 256 * sizeof(RGBQUAD), &bytesWritten, NULL);
    WriteFile(hOutputFile, rasterData.data(), rasterData.size(), &bytesWritten, NULL);

    // Закрываем файл
    CloseHandle(hOutputFile);

    std::cout << "Тестовая картинка успешно создана!" << std::endl;
    return 0;
}