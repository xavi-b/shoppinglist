#ifndef SINGLETON_H
#define SINGLETON_H

#include <QObject>
#include <QVariantList>
#include <QSettings>

#include "model.h"

class Singleton : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Model* model MEMBER model NOTIFY modelChanged)

public:
    explicit Singleton(QObject* parent = nullptr);

    Q_INVOKABLE
    void remove(int index);
    Q_INVOKABLE
    void add(QString const& title);
    void add(Item* item);
    Q_INVOKABLE
    void sortByChecked();
    Q_INVOKABLE
    void uncheckAll();

    bool loadSettings();

    Q_INVOKABLE
    bool saveSettings();

signals:
    void modelChanged();

private:
    Model*    model;
    QSettings settings;
};

#endif // SINGLETON_H
