#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include "singleton.h"

int main(int argc, char* argv[])
{
    QGuiApplication app(argc, argv);
    app.setApplicationName("ShoppingList");
    app.setOrganizationName("xavi-b");

    QQuickStyle::setStyle("Material");

    QQmlApplicationEngine engine;

    Singleton s;
    s.loadSettings();
    qmlRegisterSingletonInstance("Singleton", 1, 0, "Singleton", &s);

    const QUrl url("qrc:/shoppinglist/main.qml");
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject* obj, const QUrl& objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    QObject::connect(&app, &QGuiApplication::aboutToQuit, &s, &Singleton::saveSettings);

    engine.load(url);

    return app.exec();
}
