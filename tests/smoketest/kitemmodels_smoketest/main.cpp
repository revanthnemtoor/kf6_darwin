#include <QCoreApplication>
#include <QStringListModel>
#include <KNumberModel>
#include <kitemmodels_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);

    KNumberModel numModel;
    numModel.setMinimumValue(10);
    numModel.setMaximumValue(50);
    numModel.setStepSize(10);

    std::printf("KItemModels Smoke Test\n");
    std::printf("  Version  : %s\n", KITEMMODELS_VERSION_STRING);
    std::printf("  RowCount : %d\n", numModel.rowCount());

    if (numModel.rowCount() != 5) {
        std::fprintf(stderr, "FAIL: Expected 5 rows in KNumberModel, got %d\n", numModel.rowCount());
        return 1;
    }

    std::printf("PASS: KF6::ItemModels runtime test succeeded.\n");
    return 0;
}

