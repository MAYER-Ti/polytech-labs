#include "mainwindow.h"
#include "./ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    // Инициализация камеры
    if (!cap.open(0)) {
        qCritical() << "Failed to open camera!";
        return;
    }
    // Таймер для обновления кадров
    timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &MainWindow::updateFrame);
    timer->start(15); // Обновление каждые 30 мс

    // Кнопка записи
    connect(ui->recordButton_3, &QPushButton::clicked, this, &MainWindow::toggleRecording);
}

MainWindow::~MainWindow()
{
    cap.release();
    if (writer.isOpened()) writer.release();
    delete ui;
}

void MainWindow::updateFrame()
{
    cv::Mat frame;
    cap >> frame;
    if (frame.empty()) return;

    // Яркость
    int brightness = ui->brightnessSlider_3->value();
    frame += cv::Scalar(brightness, brightness, brightness);
    int redKoef = ui->brightnessSlider_4->value();
    int blueKoef = ui->brightnessSlider_6->value();
    int greenKoef = ui->brightnessSlider_5->value();
    frame += cv::Scalar(blueKoef,greenKoef, redKoef);

    // Размытие
    if (ui->blurCheckbox_3->isChecked()) {
        cv::GaussianBlur(frame, frame, cv::Size(25, 25), 0);
    }

    // Преобразование кадра в QImage
    QImage qimg(frame.data, frame.cols, frame.rows, frame.step, QImage::Format_BGR888);
    ui->videoLabel_3->setPixmap(QPixmap::fromImage(qimg));

    // Запись видео
    if (isRecording && writer.isOpened()) {
        writer.write(frame);
    }
}

void MainWindow::toggleRecording()
{
    isRecording = !isRecording;
    if (isRecording) {
        QString filename = "output.avi";
        int fourcc = cv::VideoWriter::fourcc('M', 'J', 'P', 'G');
        double fps = 15;
        cv::Size size(
            static_cast<int>(cap.get(cv::CAP_PROP_FRAME_WIDTH)),
            static_cast<int>(cap.get(cv::CAP_PROP_FRAME_HEIGHT))
        );
        writer.open(filename.toStdString(), fourcc, fps, size);
        if (!writer.isOpened()) {
            qCritical() << "Failed to open video writer!";
            isRecording = false;
            return;
        }
        ui->recordButton_3->setText("Stop Recording");
        ui->statusBar->showMessage("Recording...");
    } else {
        writer.release();
        ui->recordButton_3->setText("Start Recording");
        ui->statusBar->showMessage("Recording stopped.");
    }
}
