#include <iostream>
#include <opencv2/core.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>
#include <filesystem>

using namespace std;
using namespace cv;

bool isRecording = false;
VideoWriter out;

void onTrackbarSlide(int pos, void*) {
    if (pos == 1 && !isRecording) {
        cout << "Start recording" << endl;
        isRecording = true;
    } else if (pos == 0 && isRecording) {
        cout << "Stop recording" << endl;
        isRecording = false;
        out.release();
    }
}

int main() {
    int record = 0, blur = 0, black = 0, invers = 0, light = 0;

    namedWindow("Video", WINDOW_AUTOSIZE);
    namedWindow("Configuration", WINDOW_AUTOSIZE);

    createTrackbar("Rec", "Configuration", &record, 1, onTrackbarSlide);
    createTrackbar("Blur", "Configuration", &blur, 2);
    createTrackbar("Invers", "Configuration", &invers, 1);
    createTrackbar("Black", "Configuration", &black, 1);
    createTrackbar("Light", "Configuration", &light, 5);

    VideoCapture video(0);
    if (!video.isOpened()) {
        cerr << "Error: Failed to open the camera!" << endl;
        return -1;
    }

    Size fsize(static_cast<int>(video.get(CAP_PROP_FRAME_WIDTH)), static_cast<int>(video.get(CAP_PROP_FRAME_HEIGHT)));
    double fps = video.get(CAP_PROP_FPS);
    string filename = "video.avi";
    int fourcc = VideoWriter::fourcc('M', 'J', 'P', 'G');

    Mat original;
    while (true) {
        video >> original;
        if (original.empty()) {
            break;
        }

        // Яркость
        if (light > 0) {
            Mat brightened;
            double lightFactor = 1.0 + light * 0.5; // Коэффициент яркости
            addWeighted(original, lightFactor, original, 0, 0, brightened);
            original = brightened;
        }

        // Размытие
        if (blur > 0) {
            Size kernelSize = Size((blur * 25) | 1, (blur * 25) | 1);
            GaussianBlur(original, original, kernelSize, 0);
        }

        // Черно-белый фильтр
        if (black) {
            cvtColor(original, original, COLOR_BGR2GRAY);
            cvtColor(original, original, COLOR_GRAY2BGR);
        }

        // Инверсия цветов
        if (invers) {
            original = Scalar::all(255) - original;
        }

        imshow("Video", original);

        // Запись видео
        if (isRecording) {
            if (!out.isOpened()) {
                if (std::filesystem::exists(filename)) {
                    std::filesystem::remove(filename);
                }
                out.open(filename, fourcc, fps, fsize);
            }
            if (out.isOpened()) {
                out.write(original);
            }
        }

        char key = waitKey(1);
        if (key == 27) { // ESC для выхода
            break;
        }
    }

    video.release();
    out.release();
    destroyAllWindows();

    return 0;
}
