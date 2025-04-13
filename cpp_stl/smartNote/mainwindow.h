#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QPlainTextEdit>
#include <QListWidget>
#include <QTreeWidget>
#include <QAction>
#include <memory>
#include "notemanager.h"
#include <QCompleter>
#include <QStringListModel>

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

protected:
    void closeEvent(QCloseEvent *event) override;

public slots:
    void onTextChanged();
    void updateHashtagsTree();
    void onHashtagsClicked(QTreeWidgetItem* item, int column);
    void showNotesContextMenu(const QPoint &pos);
    void createNewNote();
    void deleteSelectedNote();
    void renameSelectedNote();
    void updateNotesTree();
    void onNoteSelected(QTreeWidgetItem* item, int column);

protected:
    bool eventFilter(QObject* obj, QEvent* event) override;

private slots:
    void showPreviousNote();
    void showNextNote();
    void filterNotesByHashtag();

private:
    void initializeGui();
    void loadNotes();
    bool confirmDelete();
    void selectNoteInTree(const std::shared_ptr<Note>& note);
    void showNotesWithHashtag(const std::string& hashtag);
    void updateHashtagCompleter();
    void showHashtagCompleter();
    QString getCurrentHashtagPrefix() const;


private:
    NoteManager m_noteManager;
    QStringList m_allHashtags;
    std::unique_ptr<QPlainTextEdit> m_editor;
    std::unique_ptr<QTreeWidget> m_hashtagsTree;
    std::unique_ptr<QTreeWidget> m_filesTree;

    std::shared_ptr<Note> m_currentNote;

    std::unique_ptr<QAction> m_ActionCreateNote;
    std::unique_ptr<QAction> m_ActionDeleteNote;
    std::unique_ptr<QAction> m_ActionRenameNote;

    std::unique_ptr<QToolBar> m_navigationToolBar;
    std::unique_ptr<QAction> m_ActionPrevNote;
    std::unique_ptr<QAction> m_ActionNextNote;
    std::unique_ptr<QLineEdit> m_hashtagFilter;
    std::unique_ptr<QCompleter> m_hashtagCompleter;
    std::unique_ptr<QStringListModel> m_completerModel;

    QString m_currentCompletion;
};

#endif // MAINWINDOW_H
