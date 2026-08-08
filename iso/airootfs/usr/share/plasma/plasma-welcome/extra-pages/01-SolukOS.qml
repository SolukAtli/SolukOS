/*
 * SPDX-FileCopyrightText: 2026 SolukOS
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.15 as Kirigami

import org.kde.welcome 1.0
import org.kde.plasma.welcome 1.0

GenericPage {
    heading: i18nc("@info:window", "SolukOS")
    description: i18nc("@info:usagetip", "Hafif, moduler ve siber guvenlik odakli bir Linux ortami. Bu logo, tum SolukOS markalamasinda (kurulum ekrani, boot splash, duvar kagidi) kullandigimiz ayni at logosu.")

    Kirigami.Icon {
        id: image
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -Kirigami.Units.gridUnit * 4
        width: Kirigami.Units.gridUnit * 10
        height: Kirigami.Units.gridUnit * 10
        source: "solukos"
    }
}
