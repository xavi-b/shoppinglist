#ifndef MODEL_H
#define MODEL_H

#include <QAbstractListModel>

class Item : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ getTitle WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(bool checked READ isChecked WRITE setChecked NOTIFY checkedChanged)

public:
    Item(QObject* parent = nullptr);
    Item(QString title, QObject* parent = nullptr);

    static Item* fromVariantMap(QVariantMap const& map);
    QVariantMap  toVariantMap() const;

    QString getTitle() const;
    void    setTitle(QString const& text);
    bool    isChecked() const;
    void    setChecked(bool b);

signals:
    void titleChanged();
    void checkedChanged();

private:
    QString title;
    bool    checked = false;
};

class Model : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit Model(QObject* parent = nullptr);

    void sortByChecked();
    void add(Item* item);
    void remove(int index);
    int  count() const;

    Item* at(int index) const;

protected:
    int                    rowCount(const QModelIndex& parent = QModelIndex()) const;
    QVariant               data(const QModelIndex& index, int role = Qt::DisplayRole) const;
    bool                   setData(const QModelIndex& index, const QVariant& value, int role = Qt::EditRole);
    QHash<int, QByteArray> roleNames() const;

private:
    QList<Item*> items;
};

#endif // MODEL_H
