#include "singleton.h"

Singleton::Singleton(QObject* parent)
    : QObject{parent}
{
    model = new Model(this);
}

void Singleton::remove(int index)
{
    model->remove(index);
    emit modelChanged();
}

void Singleton::add(const QString& title)
{
    Item* item = new Item(title);
    add(item);
}

void Singleton::add(Item* item)
{
    model->add(item);
    emit modelChanged();
}

void Singleton::sortByChecked()
{
    model->sortByChecked();
    emit modelChanged();
}

bool Singleton::loadSettings()
{
    int size = settings.beginReadArray("items");
    for (int i = 0; i < size; ++i)
    {
        settings.setArrayIndex(i);
        Item* item = Item::fromVariantMap(settings.value("item").toMap());
        add(item);
    }
    settings.endArray();
    return true;
}

bool Singleton::saveSettings()
{
    settings.beginWriteArray("items");
    for (int i = 0; i < model->count(); ++i)
    {
        settings.setArrayIndex(i);
        settings.setValue("item", model->at(i)->toVariantMap());
    }
    settings.endArray();
    settings.sync();
    return settings.status() == QSettings::NoError;
}
