#include "mainwindow.h"
#include <QMessageBox>
#include <QHBoxLayout>
#include <QLabel>

#include "fmod_errors.h"

MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent) {
    setWindowTitle("3D Audio Player (FMOD + Qt)");
    resize(500, 300);

    // Создание виджетов
    m_openFileButton = new QPushButton("Open Audio File", this);
    m_playButton = new QPushButton("Play", this);
    m_stopButton = new QPushButton("Stop", this);
    m_fileLabel = new QLabel("No file selected", this);

    // Слайдеры для позиции звука
    m_xSlider = new QSlider(Qt::Horizontal);
    m_ySlider = new QSlider(Qt::Horizontal);
    m_zSlider = new QSlider(Qt::Horizontal);

    m_xSlider->setRange(-10, 10);
    m_ySlider->setRange(-10, 10);
    m_zSlider->setRange(-10, 10);

    m_xSlider->setValue(5);  // По умолчанию звук справа (x=5)
    m_ySlider->setValue(0);
    m_zSlider->setValue(0);

    // Разметка
    QVBoxLayout *mainLayout = new QVBoxLayout();
    mainLayout->addWidget(m_openFileButton);
    mainLayout->addWidget(m_fileLabel);

    QHBoxLayout *sliderLayoutX = new QHBoxLayout();
    sliderLayoutX->addWidget(new QLabel("X (Left/Right):"));
    sliderLayoutX->addWidget(m_xSlider);
    mainLayout->addLayout(sliderLayoutX);

    QHBoxLayout *sliderLayoutY = new QHBoxLayout();
    sliderLayoutY->addWidget(new QLabel("Y (Up/Down):"));
    sliderLayoutY->addWidget(m_ySlider);
    mainLayout->addLayout(sliderLayoutY);

    QHBoxLayout *sliderLayoutZ = new QHBoxLayout();
    sliderLayoutZ->addWidget(new QLabel("Z (Front/Back):"));
    sliderLayoutZ->addWidget(m_zSlider);
    mainLayout->addLayout(sliderLayoutZ);

    QHBoxLayout *buttonLayout = new QHBoxLayout();
    buttonLayout->addWidget(m_playButton);
    buttonLayout->addWidget(m_stopButton);
    mainLayout->addLayout(buttonLayout);

    QWidget *centralWidget = new QWidget(this);
    centralWidget->setLayout(mainLayout);
    setCentralWidget(centralWidget);

    // Подключение сигналов
    connect(m_openFileButton, &QPushButton::clicked, this, &MainWindow::onOpenFileClicked);
    connect(m_playButton, &QPushButton::clicked, this, &MainWindow::onPlayClicked);
    connect(m_stopButton, &QPushButton::clicked, this, &MainWindow::onStopClicked);
    connect(m_xSlider, &QSlider::valueChanged, this, &MainWindow::updateSoundPosition);
    connect(m_ySlider, &QSlider::valueChanged, this, &MainWindow::updateSoundPosition);
    connect(m_zSlider, &QSlider::valueChanged, this, &MainWindow::updateSoundPosition);

    // Инициализация FMOD
    FMOD_RESULT result = initFMOD();
    if (result != FMOD_OK) {
        QMessageBox::critical(this, "Error", QString("FMOD init failed: %1").arg(FMOD_ErrorString(result)));
        close();
    }
}

MainWindow::~MainWindow() {
    cleanupFMOD();
}

FMOD_RESULT MainWindow::initFMOD() {
    FMOD_RESULT result;
    result = FMOD::System_Create(&m_system);
    if (result != FMOD_OK) return result;

    result = m_system->init(512, FMOD_INIT_3D_RIGHTHANDED, nullptr);
    return result;
}

void MainWindow::cleanupFMOD() {
    if (m_sound) m_sound->release();
    if (m_system) {
        m_system->close();
        m_system->release();
    }
}

void MainWindow::onOpenFileClicked() {
    QString filePath = QFileDialog::getOpenFileName(
        this,
        "Open Audio File",
        QDir::homePath(),
        "Audio Files (*.wav *.ogg *.mp3)"
        );

    if (filePath.isEmpty()) return;

    m_currentFile = filePath;
    m_fileLabel->setText(QFileInfo(filePath).fileName());

    if (m_sound) m_sound->release();

    FMOD_RESULT result = m_system->createSound(
        filePath.toUtf8().constData(),
        FMOD_3D,
        nullptr,
        &m_sound
        );

    if (result != FMOD_OK) {
        QMessageBox::warning(this, "Error", "Failed to load audio file!");
    }
}

void MainWindow::onPlayClicked() {
    if (!m_sound) {
        QMessageBox::warning(this, "Error", "No audio file loaded!");
        return;
    }

    // Установка позиции слушателя (в центре)
    FMOD_VECTOR listenerPos = { 0.0f, 0.0f, 0.0f };
    m_system->set3DListenerAttributes(0, &listenerPos, nullptr, nullptr, nullptr);

    // Воспроизведение звука
    m_system->playSound(m_sound, nullptr, false, &m_channel);
    updateSoundPosition();  // Применяем текущие значения слайдеров
}

void MainWindow::onStopClicked() {
    if (m_channel) m_channel->stop();
}

void MainWindow::updateSoundPosition() {
    if (!m_channel) return;

    // Получаем значения слайдеров
    float x = m_xSlider->value() * 100;
    float y = m_ySlider->value() * 100;
    float z = m_zSlider->value() * 100;

    // Обновляем позицию звука
    FMOD_VECTOR soundPos = { x, y, z };
    m_channel->set3DAttributes(&soundPos, nullptr);
}
