#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <opencv2/opencv.hpp>

#include <QTimer>
#include <QDebug>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    void updateFrame();
    void toggleRecording();

private:
    Ui::MainWindow *ui;
    cv::VideoCapture cap;
    cv::VideoWriter writer;
    QTimer *timer;
    bool isRecording = false;
};
#endif // MAINWINDOW_H
