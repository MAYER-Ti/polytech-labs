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
    timer->start(30); // Обновление каждые 30 мс

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
        double fps = cap.get(cv::CAP_PROP_FPS);
        cv::Size size(cap.get(cv::CAP_PROP_FRAME_WIDTH), cap.get(cv::CAP_PROP_FRAME_HEIGHT));
        writer.open(filename.toStdString(), fourcc, fps, size);
        ui->recordButton_3->setText("Stop Recording");
        ui->statusBar->showMessage("Recording...");
    } else {
        writer.release();
        ui->recordButton_3->setText("Start Recording");
        ui->statusBar->showMessage("Recording stopped.");
    }
}
