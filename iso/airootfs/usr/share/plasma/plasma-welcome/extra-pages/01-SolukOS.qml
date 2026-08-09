/*
 * SPDX-FileCopyrightText: 2026 SolukOS
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

import org.kde.welcome
import org.kde.plasma.welcome

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
