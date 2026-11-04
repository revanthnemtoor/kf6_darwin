#include <QCoreApplication>
#include <QBuffer>
#include <KZip>
#include <KTar>
#include <KCompressionDevice>
#include <karchive_version.h>
#include <cstdio>

int main(int argc, char **argv) {
    QCoreApplication app(argc, argv);

    QByteArray zipBytes;
    {
        QBuffer buf(&zipBytes);
        KZip zip(&buf);
        if (!zip.open(QIODevice::WriteOnly)) {
            std::fprintf(stderr, "FAIL: Could not open KZip for writing\n");
            return 1;
        }
        zip.writeFile(QStringLiteral("hello.txt"), QByteArrayLiteral("Hello from KF6Archive on Darwin!"));
        zip.close();
    }

    QBuffer readBuf(&zipBytes);
    KZip readZip(&readBuf);
    if (!readZip.open(QIODevice::ReadOnly)) {
        std::fprintf(stderr, "FAIL: Could not open KZip for reading\n");
        return 1;
    }
    const KArchiveEntry *entry = readZip.directory()->entry(QStringLiteral("hello.txt"));
    if (!entry || !entry->isFile()) {
        std::fprintf(stderr, "FAIL: hello.txt missing from KZip\n");
        return 1;
    }
    const QByteArray data = static_cast<const KArchiveFile *>(entry)->data();
    readZip.close();

    std::printf("KArchive Smoke Test\n");
    std::printf("  Version : %s\n", KARCHIVE_VERSION_STRING);
    std::printf("  Payload : %s\n", data.constData());

    if (data != QByteArrayLiteral("Hello from KF6Archive on Darwin!")) {
        std::fprintf(stderr, "FAIL: KZip payload mismatch\n");
        return 1;
    }

    std::printf("PASS: KF6::Archive runtime test succeeded.\n");
    return 0;
}

