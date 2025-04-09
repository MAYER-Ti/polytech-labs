#include "mainwindow.h"
#include <QHBoxLayout>
#include <QVBoxLayout>
#include <QDebug>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    initializeGui();

    // Создаем первую заметку
    m_currentNote = m_noteManager.generateNote();

    // Сигналы
    connect(m_editor, &QTextEdit::textChanged, this, &MainWindow::onTextChanged);
    connect(m_hashtagsTree, &QTreeWidget::itemClicked, this, &MainWindow::onHashtagsClicked);
}

MainWindow::~MainWindow() {}

void MainWindow::onTextChanged()
{
    m_currentNote->text = m_editor->toPlainText().toStdString();

    m_currentNote->updateHashtags();
    updateHashtagsTree();
}

void MainWindow::updateHashtagsTree()
{
    m_hashtagsTree->clear();
    std::set<std::string> allHashtags = m_noteManager.allHashtags();
    std::for_each(allHashtags.begin(), allHashtags.end(), [this](const std::string& hashtag) {
        QTreeWidgetItem* item = new QTreeWidgetItem(m_hashtagsTree);
        item->setText(0, QString(hashtag.data()));
        //m_hashtagsTree->addTopLevelItem(item);
    });

}

void MainWindow::onHashtagsClicked(QTreeWidgetItem *item, int column)
{
    std::string hashtag = item->text(column).mid(1).toStdString();
    std::list<Note> filteredNotes = m_noteManager.notesByHashtag(hashtag);
    if (!filteredNotes.empty()) {
        m_editor->setPlainText(filteredNotes.front().text.data()); // Взять первую запись по хэштегу
    }
}

void MainWindow::initializeGui()
{
    QWidget* centralWidget = new QWidget(this);
    QHBoxLayout* layout = new QHBoxLayout(centralWidget);

    m_editor = new QTextEdit();
    m_hashtagsTree = new QTreeWidget();
    m_hashtagsTree->setHeaderLabel("Хэштеги");

    layout->addWidget(m_hashtagsTree, 1);
    layout->addWidget(m_editor, 3);

    setCentralWidget(centralWidget);
}
