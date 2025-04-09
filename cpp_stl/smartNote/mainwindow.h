#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QTextEdit>
#include <QListWidget>
#include <QTreeWidget>
#include "notemanager.h"

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();
public slots:
    //!
    //! \brief Изменение текста в редакторе
    //! Обновляет хэштеги в текущей записи и обновляет хэшеги в дереве хэштегов
    void onTextChanged();
    //!
    //! \brief Обновление дерева хэштегов
    //!
    void updateHashtagsTree();
    void onHashtagsClicked(QTreeWidgetItem* item, int column);


private:
    void initializeGui();

private:
    QTextEdit* m_editor = nullptr;
    QTreeWidget* m_hashtagsTree = nullptr;
    NoteManager m_noteManager;
    std::shared_ptr<Note> m_currentNote;
};
#endif // MAINWINDOW_H
