import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: page

    implicitWidth: 620
    implicitHeight: 520

    property alias cfg_use24Hour: use24Hour.checked
    property string cfg_fontFamily: "Monospace"
    property alias cfg_fontScale: fontScale.value
    property alias cfg_fontWeight: fontWeight.value
    property alias cfg_letterSpacing: letterSpacing.value

    onCfg_fontFamilyChanged: {
        const idx = fontPicker.find(cfg_fontFamily)
        if (idx >= 0 && fontPicker.currentIndex !== idx)
            fontPicker.currentIndex = idx
    }

    QQC2.ScrollView {
        id: scrollView
        anchors.fill: parent
        clip: true
        contentWidth: availableWidth
        QQC2.ScrollBar.horizontal.policy: QQC2.ScrollBar.AlwaysOff
        QQC2.ScrollBar.vertical.policy: QQC2.ScrollBar.AsNeeded

        Kirigami.FormLayout {
            id: form
            width: scrollView.availableWidth
            Layout.fillWidth: true

            QQC2.CheckBox {
                id: use24Hour
                Kirigami.FormData.label: i18n("Clock:")
                text: i18n("Use 24-hour time")
            }
        
            Kirigami.Separator { Kirigami.FormData.isSection: true }
        
            QQC2.ComboBox {
                id: fontPicker
                Kirigami.FormData.label: i18n("Font:")
                Layout.fillWidth: true
                model: Qt.fontFamilies()
                editable: true
        
                Component.onCompleted: {
                    const idx = find(page.cfg_fontFamily)
                    if (idx >= 0) currentIndex = idx
                }
                onActivated: page.cfg_fontFamily = currentText
                onAccepted: page.cfg_fontFamily = editText
            }
        
            QQC2.Label {
                Kirigami.FormData.label: i18n("Preview:")
                text: "09:45"
                font.family: page.cfg_fontFamily
                font.pixelSize: 46
                font.weight: fontWeight.value
                font.letterSpacing: letterSpacing.value
            }
        
            QQC2.SpinBox {
                id: fontScale
                from: 55; to: 150; stepSize: 5
                Kirigami.FormData.label: i18n("Font size (%):")
            }
        
            QQC2.SpinBox {
                id: fontWeight
                from: 100; to: 900; stepSize: 100
                Kirigami.FormData.label: i18n("Font weight:")
            }
        
            QQC2.SpinBox {
                id: letterSpacing
                from: -12; to: 30; stepSize: 1
                Kirigami.FormData.label: i18n("Letter spacing:")
            }
        
            QQC2.Label {
                Kirigami.FormData.isSection: true
                text: i18n("Tip: condensed and display fonts make the glitch slices look especially sharp.")
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                opacity: 0.75
            }
        }
    }
}
