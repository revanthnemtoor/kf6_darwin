#include <QCoreApplication>
#include <KCrash>
#include <iostream>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);
    KCrash::setDrKonqiEnabled(false);
    if (KCrash::isDrKonqiEnabled()) return 1;
    std::cout << "KF6::Crash smoke test passed" << std::endl;
    return 0;
}

