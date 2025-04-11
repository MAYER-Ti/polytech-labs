#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QPushButton>
#include <QLabel>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QSlider>
#include <QFileDialog>
#include "fmod.hpp"


class MainWindow : public QMainWindow {
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void onOpenFileClicked();
    void onPlayClicked();
    void onStopClicked();
    void updateSoundPosition();

private:
    QPushButton *m_openFileButton;
    QPushButton *m_playButton;
    QPushButton *m_stopButton;
    QLabel *m_fileLabel;
    QSlider *m_xSlider;
    QSlider *m_ySlider;
    QSlider *m_zSlider;

    FMOD::System *m_system = nullptr;
    FMOD::Sound *m_sound = nullptr;
    FMOD::Channel *m_channel = nullptr;
    QString m_currentFile;

    FMOD_RESULT initFMOD();
    void cleanupFMOD();
};

#endif
