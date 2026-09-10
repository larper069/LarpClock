import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Item {
    id: page

    implicitWidth: 620
    implicitHeight: 520

    property string cfg_effectPreset: "Cyberpunk"
    property bool cfg_enableMatrix: true
    property bool cfg_enableChroma: true
    property bool cfg_enableSlices: true
    property bool cfg_enableBurst: true
    property bool cfg_enableScanlines: true
    property bool cfg_enablePulse: true
    property bool cfg_enableGhost: false

    property int cfg_matrixSpeedMin: 900
    property int cfg_matrixSpeedMax: 2200
    property int cfg_matrixColumns: 28
    property int cfg_matrixOpacity: 95
    property int cfg_glitchIntervalMin: 2200
    property int cfg_glitchIntervalMax: 6500
    property int cfg_glitchDuration: 170
    property int cfg_chromaDuration: 140
    property int cfg_glitchStrength: 9
    property int cfg_burstIntervalMin: 9000
    property int cfg_burstIntervalMax: 18000
    property int cfg_burstDuration: 430
    property int cfg_scanlineSpeed: 1400
    property int cfg_scanlineOpacity: 34
    property int cfg_pulseDuration: 1800
    property int cfg_pulseStrength: 35
    property int cfg_ghostOpacity: 24
    property int cfg_ghostDistance: 7
    property color cfg_baseColor: "#d7fff8"
    property color cfg_matrixColor: "#67ffe4"
    property color cfg_cyanColor: "#00f6ff"
    property color cfg_magentaColor: "#ff2bd6"

    property string activeColorTarget: "base"

    function setActiveColor(c) {
        if (activeColorTarget === "base") cfg_baseColor = c
        else if (activeColorTarget === "matrix") cfg_matrixColor = c
        else if (activeColorTarget === "cyan") cfg_cyanColor = c
        else if (activeColorTarget === "magenta") cfg_magentaColor = c
        cfg_effectPreset = "Custom"
    }

    function applyPreset(name) {
        cfg_effectPreset = name
        if (name === "Clean") {
            cfg_enableMatrix = false; cfg_enableChroma = false; cfg_enableSlices = false
            cfg_enableBurst = false; cfg_enableScanlines = false; cfg_enablePulse = false; cfg_enableGhost = false
        } else if (name === "Matrix") {
            cfg_enableMatrix = true; cfg_enableChroma = false; cfg_enableSlices = false
            cfg_enableBurst = false; cfg_enableScanlines = true; cfg_enablePulse = true; cfg_enableGhost = false
            cfg_matrixColumns = 32; cfg_matrixOpacity = 100; cfg_matrixSpeedMin = 700; cfg_matrixSpeedMax = 1900
            cfg_pulseStrength = 22
        } else if (name === "Comic Glitch") {
            cfg_enableMatrix = false; cfg_enableChroma = true; cfg_enableSlices = true
            cfg_enableBurst = true; cfg_enableScanlines = false; cfg_enablePulse = false; cfg_enableGhost = true
            cfg_glitchStrength = 12; cfg_glitchDuration = 140; cfg_chromaDuration = 170
            cfg_glitchIntervalMin = 1500; cfg_glitchIntervalMax = 4500; cfg_ghostOpacity = 30; cfg_ghostDistance = 9
        } else if (name === "Cyberpunk") {
            cfg_enableMatrix = true; cfg_enableChroma = true; cfg_enableSlices = true
            cfg_enableBurst = true; cfg_enableScanlines = true; cfg_enablePulse = true; cfg_enableGhost = false
            cfg_glitchStrength = 9; cfg_matrixOpacity = 90; cfg_scanlineOpacity = 34; cfg_pulseStrength = 35
        } else if (name === "Neon Pulse") {
            cfg_enableMatrix = false; cfg_enableChroma = true; cfg_enableSlices = false
            cfg_enableBurst = false; cfg_enableScanlines = false; cfg_enablePulse = true; cfg_enableGhost = true
            cfg_pulseDuration = 1200; cfg_pulseStrength = 65; cfg_ghostOpacity = 18; cfg_ghostDistance = 4
        } else if (name === "Data Corruption") {
            cfg_enableMatrix = false; cfg_enableChroma = true; cfg_enableSlices = true
            cfg_enableBurst = true; cfg_enableScanlines = true; cfg_enablePulse = false; cfg_enableGhost = true
            cfg_glitchStrength = 18; cfg_glitchIntervalMin = 700; cfg_glitchIntervalMax = 2600
            cfg_burstIntervalMin = 5000; cfg_burstIntervalMax = 10000; cfg_scanlineSpeed = 650
        } else if (name === "Chaos") {
            cfg_enableMatrix = true; cfg_enableChroma = true; cfg_enableSlices = true
            cfg_enableBurst = true; cfg_enableScanlines = true; cfg_enablePulse = true; cfg_enableGhost = true
            cfg_glitchStrength = 24; cfg_glitchIntervalMin = 450; cfg_glitchIntervalMax = 1500
            cfg_burstIntervalMin = 2500; cfg_burstIntervalMax = 6500; cfg_matrixSpeedMin = 380; cfg_matrixSpeedMax = 1200
            cfg_scanlineSpeed = 420; cfg_pulseDuration = 700; cfg_pulseStrength = 75; cfg_ghostOpacity = 38; cfg_ghostDistance = 12
        }
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

            QQC2.ComboBox {
                id: preset
                Kirigami.FormData.label: i18n("Preset:")
                Layout.fillWidth: true
                model: ["Clean", "Matrix", "Comic Glitch", "Cyberpunk", "Neon Pulse", "Data Corruption", "Chaos", "Custom"]
                Component.onCompleted: {
                    const idx = find(page.cfg_effectPreset)
                    if (idx >= 0) currentIndex = idx
                }
                onActivated: page.applyPreset(currentText)
            }
        
            Kirigami.Separator { Kirigami.FormData.isSection: true }
        
            QQC2.CheckBox { id: matrix; Kirigami.FormData.label: i18n("Effects:"); text: i18n("Matrix rain inside digits"); checked: page.cfg_enableMatrix; onToggled: { page.cfg_enableMatrix = checked; page.cfg_effectPreset = "Custom" } }
            QQC2.CheckBox { text: i18n("Chromatic cyan/magenta split"); checked: page.cfg_enableChroma; onToggled: { page.cfg_enableChroma = checked; page.cfg_effectPreset = "Custom" } }
            QQC2.CheckBox { text: i18n("Horizontal glitch slices"); checked: page.cfg_enableSlices; onToggled: { page.cfg_enableSlices = checked; page.cfg_effectPreset = "Custom" } }
            QQC2.CheckBox { text: i18n("Heavy distortion bursts"); checked: page.cfg_enableBurst; onToggled: { page.cfg_enableBurst = checked; page.cfg_effectPreset = "Custom" } }
            QQC2.CheckBox { text: i18n("CRT scanlines inside digits"); checked: page.cfg_enableScanlines; onToggled: { page.cfg_enableScanlines = checked; page.cfg_effectPreset = "Custom" } }
            QQC2.CheckBox { text: i18n("Breathing neon pulse"); checked: page.cfg_enablePulse; onToggled: { page.cfg_enablePulse = checked; page.cfg_effectPreset = "Custom" } }
            QQC2.CheckBox { text: i18n("RGB ghost trail"); checked: page.cfg_enableGhost; onToggled: { page.cfg_enableGhost = checked; page.cfg_effectPreset = "Custom" } }
        
            Kirigami.Separator { Kirigami.FormData.isSection: true }
        
            QQC2.SpinBox { from: 8; to: 60; value: page.cfg_matrixColumns; onValueModified: page.cfg_matrixColumns = value; Kirigami.FormData.label: i18n("Matrix columns:") }
            QQC2.SpinBox { from: 10; to: 100; value: page.cfg_matrixOpacity; onValueModified: page.cfg_matrixOpacity = value; Kirigami.FormData.label: i18n("Matrix opacity (%):") }
            QQC2.SpinBox { from: 100; to: 10000; stepSize: 100; value: page.cfg_matrixSpeedMin; onValueModified: page.cfg_matrixSpeedMin = value; Kirigami.FormData.label: i18n("Matrix fastest fall (ms):") }
            QQC2.SpinBox { from: 100; to: 15000; stepSize: 100; value: page.cfg_matrixSpeedMax; onValueModified: page.cfg_matrixSpeedMax = value; Kirigami.FormData.label: i18n("Matrix slowest fall (ms):") }
        
            Kirigami.Separator { Kirigami.FormData.isSection: true }
        
            QQC2.SpinBox { from: 100; to: 60000; stepSize: 100; value: page.cfg_glitchIntervalMin; onValueModified: page.cfg_glitchIntervalMin = value; Kirigami.FormData.label: i18n("Glitch min interval (ms):") }
            QQC2.SpinBox { from: 100; to: 60000; stepSize: 100; value: page.cfg_glitchIntervalMax; onValueModified: page.cfg_glitchIntervalMax = value; Kirigami.FormData.label: i18n("Glitch max interval (ms):") }
            QQC2.SpinBox { from: 20; to: 5000; stepSize: 10; value: page.cfg_glitchDuration; onValueModified: page.cfg_glitchDuration = value; Kirigami.FormData.label: i18n("Slice duration (ms):") }
            QQC2.SpinBox { from: 20; to: 5000; stepSize: 10; value: page.cfg_chromaDuration; onValueModified: page.cfg_chromaDuration = value; Kirigami.FormData.label: i18n("Chromatic duration (ms):") }
            QQC2.SpinBox { from: 1; to: 40; value: page.cfg_glitchStrength; onValueModified: page.cfg_glitchStrength = value; Kirigami.FormData.label: i18n("Glitch strength:") }
        
            Kirigami.Separator { Kirigami.FormData.isSection: true }
        
            QQC2.SpinBox { from: 500; to: 120000; stepSize: 500; value: page.cfg_burstIntervalMin; onValueModified: page.cfg_burstIntervalMin = value; Kirigami.FormData.label: i18n("Burst min interval (ms):") }
            QQC2.SpinBox { from: 500; to: 120000; stepSize: 500; value: page.cfg_burstIntervalMax; onValueModified: page.cfg_burstIntervalMax = value; Kirigami.FormData.label: i18n("Burst max interval (ms):") }
            QQC2.SpinBox { from: 50; to: 5000; stepSize: 10; value: page.cfg_burstDuration; onValueModified: page.cfg_burstDuration = value; Kirigami.FormData.label: i18n("Burst duration (ms):") }
        
            Kirigami.Separator { Kirigami.FormData.isSection: true }
        
            QQC2.SpinBox { from: 150; to: 10000; stepSize: 50; value: page.cfg_scanlineSpeed; onValueModified: page.cfg_scanlineSpeed = value; Kirigami.FormData.label: i18n("Scanline speed (ms):") }
            QQC2.SpinBox { from: 5; to: 100; value: page.cfg_scanlineOpacity; onValueModified: page.cfg_scanlineOpacity = value; Kirigami.FormData.label: i18n("Scanline opacity (%):") }
            QQC2.SpinBox { from: 250; to: 10000; stepSize: 50; value: page.cfg_pulseDuration; onValueModified: page.cfg_pulseDuration = value; Kirigami.FormData.label: i18n("Pulse duration (ms):") }
            QQC2.SpinBox { from: 0; to: 100; value: page.cfg_pulseStrength; onValueModified: page.cfg_pulseStrength = value; Kirigami.FormData.label: i18n("Pulse strength (%):") }
            QQC2.SpinBox { from: 0; to: 100; value: page.cfg_ghostOpacity; onValueModified: page.cfg_ghostOpacity = value; Kirigami.FormData.label: i18n("Ghost opacity (%):") }
            QQC2.SpinBox { from: 1; to: 30; value: page.cfg_ghostDistance; onValueModified: page.cfg_ghostDistance = value; Kirigami.FormData.label: i18n("Ghost distance:") }
        
            Kirigami.Separator { Kirigami.FormData.isSection: true }
        
            ColorDialog {
                id: colorDialog
                title: i18n("Choose color")
                onAccepted: page.setActiveColor(selectedColor)
            }
        
            RowLayout {
                Kirigami.FormData.label: i18n("Base color:")
                spacing: Kirigami.Units.smallSpacing
                Rectangle { width: 34; height: 22; radius: 4; color: page.cfg_baseColor; border.color: Kirigami.Theme.textColor }
                QQC2.Button {
                    text: page.cfg_baseColor.toString()
                    onClicked: { page.activeColorTarget = "base"; colorDialog.selectedColor = page.cfg_baseColor; colorDialog.open() }
                }
            }
            RowLayout {
                Kirigami.FormData.label: i18n("Matrix color:")
                spacing: Kirigami.Units.smallSpacing
                Rectangle { width: 34; height: 22; radius: 4; color: page.cfg_matrixColor; border.color: Kirigami.Theme.textColor }
                QQC2.Button {
                    text: page.cfg_matrixColor.toString()
                    onClicked: { page.activeColorTarget = "matrix"; colorDialog.selectedColor = page.cfg_matrixColor; colorDialog.open() }
                }
            }
            RowLayout {
                Kirigami.FormData.label: i18n("Cyan glitch color:")
                spacing: Kirigami.Units.smallSpacing
                Rectangle { width: 34; height: 22; radius: 4; color: page.cfg_cyanColor; border.color: Kirigami.Theme.textColor }
                QQC2.Button {
                    text: page.cfg_cyanColor.toString()
                    onClicked: { page.activeColorTarget = "cyan"; colorDialog.selectedColor = page.cfg_cyanColor; colorDialog.open() }
                }
            }
            RowLayout {
                Kirigami.FormData.label: i18n("Magenta glitch color:")
                spacing: Kirigami.Units.smallSpacing
                Rectangle { width: 34; height: 22; radius: 4; color: page.cfg_magentaColor; border.color: Kirigami.Theme.textColor }
                QQC2.Button {
                    text: page.cfg_magentaColor.toString()
                    onClicked: { page.activeColorTarget = "magenta"; colorDialog.selectedColor = page.cfg_magentaColor; colorDialog.open() }
                }
            }
        }
    }
}
