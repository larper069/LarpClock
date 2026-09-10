import QtQuick
import QtQuick.Effects
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {
    id: root

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    // ---------- APPEARANCE ----------
    property bool use24Hour: plasmoid.configuration.use24Hour
    property string fontFamily: plasmoid.configuration.fontFamily
    property real fontScale: plasmoid.configuration.fontScale / 100.0
    property int fontWeight: plasmoid.configuration.fontWeight
    property real letterSpacing: plasmoid.configuration.letterSpacing

    // ---------- EFFECTS ----------
    property bool enableMatrix: plasmoid.configuration.enableMatrix
    property bool enableChroma: plasmoid.configuration.enableChroma
    property bool enableSlices: plasmoid.configuration.enableSlices
    property bool enableBurst: plasmoid.configuration.enableBurst
    property bool enableScanlines: plasmoid.configuration.enableScanlines
    property bool enablePulse: plasmoid.configuration.enablePulse
    property bool enableGhost: plasmoid.configuration.enableGhost

    property int matrixSpeedMin: plasmoid.configuration.matrixSpeedMin
    property int matrixSpeedMax: plasmoid.configuration.matrixSpeedMax
    property int matrixColumns: plasmoid.configuration.matrixColumns
    property real matrixOpacity: plasmoid.configuration.matrixOpacity / 100.0

    property int glitchIntervalMin: plasmoid.configuration.glitchIntervalMin
    property int glitchIntervalMax: plasmoid.configuration.glitchIntervalMax
    property int glitchDuration: plasmoid.configuration.glitchDuration
    property int chromaDuration: plasmoid.configuration.chromaDuration
    property real glitchStrength: plasmoid.configuration.glitchStrength

    property int burstIntervalMin: plasmoid.configuration.burstIntervalMin
    property int burstIntervalMax: plasmoid.configuration.burstIntervalMax
    property int burstDuration: plasmoid.configuration.burstDuration

    property int scanlineSpeed: plasmoid.configuration.scanlineSpeed
    property real scanlineOpacity: plasmoid.configuration.scanlineOpacity / 100.0
    property int pulseDuration: plasmoid.configuration.pulseDuration
    property real pulseStrength: plasmoid.configuration.pulseStrength / 100.0
    property real ghostOpacity: plasmoid.configuration.ghostOpacity / 100.0
    property real ghostDistance: plasmoid.configuration.ghostDistance

    property color baseColor: plasmoid.configuration.baseColor
    property color matrixColor: plasmoid.configuration.matrixColor
    property color cyanColor: plasmoid.configuration.cyanColor
    property color magentaColor: plasmoid.configuration.magentaColor

    // ---------- STATE ----------
    property date now: new Date()
    property bool glitching: false
    property bool bursting: false
    property bool chromaActive: false
    property real burstJitterX: 0
    property real burstJitterY: 0
    property real burstScaleX: 1
    property real burstScaleY: 1
    property real pulsePhase: 0

    width: 430
    height: 180
    preferredRepresentation: fullRepresentation

    function pad2(v) { return v < 10 ? "0" + v : "" + v }

    function clockText() {
        var h = now.getHours()
        if (!use24Hour) {
            h = h % 12
            if (h === 0) h = 12
        }
        return pad2(h) + ":" + pad2(now.getMinutes())
    }

    function rand(min, max) { return min + Math.random() * (max - min) }
    function randomGlitchInterval() { return Math.round(rand(Math.min(glitchIntervalMin, glitchIntervalMax), Math.max(glitchIntervalMin, glitchIntervalMax))) }
    function randomBurstInterval() { return Math.round(rand(Math.min(burstIntervalMin, burstIntervalMax), Math.max(burstIntervalMin, burstIntervalMax))) }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.now = new Date()
    }

    Timer {
        id: glitchTimer
        interval: root.randomGlitchInterval()
        running: root.enableSlices || root.enableChroma
        repeat: false
        onTriggered: {
            root.glitching = root.enableSlices
            root.chromaActive = root.enableChroma
            if (root.enableSlices) glitchStop.restart()
            else {
                glitchTimer.interval = root.randomGlitchInterval()
                glitchTimer.restart()
            }
            if (root.enableChroma) chromaStop.restart()
        }
    }

    Timer {
        id: glitchStop
        interval: root.glitchDuration
        repeat: false
        onTriggered: {
            root.glitching = false
            glitchTimer.interval = root.randomGlitchInterval()
            if (root.enableSlices || root.enableChroma) glitchTimer.restart()
        }
    }

    Timer {
        id: chromaStop
        interval: root.chromaDuration
        repeat: false
        onTriggered: root.chromaActive = false
    }

    Timer {
        id: burstTimer
        interval: root.randomBurstInterval()
        running: root.enableBurst
        repeat: false
        onTriggered: {
            root.bursting = true
            burstStop.restart()
            burstJitter.restart()
        }
    }

    Timer {
        id: burstStop
        interval: root.burstDuration
        repeat: false
        onTriggered: {
            root.bursting = false
            root.burstJitterX = 0
            root.burstJitterY = 0
            root.burstScaleX = 1
            root.burstScaleY = 1
            burstJitter.stop()
            burstTimer.interval = root.randomBurstInterval()
            if (root.enableBurst) burstTimer.restart()
        }
    }

    Timer {
        id: burstJitter
        interval: 38
        repeat: true
        onTriggered: {
            root.burstJitterX = root.rand(-root.glitchStrength, root.glitchStrength)
            root.burstJitterY = root.rand(-2.0, 2.0)
            root.burstScaleX = root.rand(0.97, 1.035)
            root.burstScaleY = root.rand(0.98, 1.025)
        }
    }

    SequentialAnimation on pulsePhase {
        running: root.enablePulse
        loops: Animation.Infinite
        NumberAnimation { from: 0; to: 1; duration: Math.max(125, root.pulseDuration / 2); easing.type: Easing.InOutSine }
        NumberAnimation { from: 1; to: 0; duration: Math.max(125, root.pulseDuration / 2); easing.type: Easing.InOutSine }
    }

    fullRepresentation: Item {
        id: stage
        anchors.fill: parent

        Text {
            id: geometryText
            anchors.centerIn: parent
            text: root.clockText()
            color: root.baseColor
            font.family: root.fontFamily.length > 0 ? root.fontFamily : "Monospace"
            font.pixelSize: Math.max(10, Math.min(stage.height * 0.72, stage.width * 0.255) * root.fontScale)
            font.weight: root.fontWeight
            font.letterSpacing: root.letterSpacing
            renderType: Text.NativeRendering
            opacity: root.enableMatrix ? 0.20 : 1.0

            transform: [
                Scale {
                    origin.x: geometryText.width / 2
                    origin.y: geometryText.height / 2
                    xScale: root.burstScaleX
                    yScale: root.burstScaleY
                },
                Translate { x: root.burstJitterX; y: root.burstJitterY }
            ]
        }

        // Main neon bloom; the pulse changes only the bloom, not readability.
        MultiEffect {
            anchors.fill: geometryText
            source: geometryText
            blurEnabled: true
            blurMax: 28
            blur: 0.68
            colorization: 1.0
            colorizationColor: root.cyanColor
            opacity: 0.22 + (root.enablePulse ? root.pulsePhase * root.pulseStrength * 0.48 : 0.08)
            autoPaddingEnabled: true
        }

        // Slow ghost trail. Two copies drift in opposite directions.
        Text {
            anchors.centerIn: geometryText
            visible: root.enableGhost
            text: root.clockText()
            color: root.cyanColor
            opacity: root.ghostOpacity
            font.family: geometryText.font.family
            font.pixelSize: geometryText.font.pixelSize
            font.weight: geometryText.font.weight
            font.letterSpacing: geometryText.font.letterSpacing
            transform: Translate { id: cyanGhostShift; x: -root.ghostDistance }
            SequentialAnimation {
                running: root.enableGhost
                loops: Animation.Infinite
                NumberAnimation { target: cyanGhostShift; property: "x"; from: -root.ghostDistance; to: root.ghostDistance * 0.35; duration: 1300; easing.type: Easing.InOutSine }
                NumberAnimation { target: cyanGhostShift; property: "x"; from: root.ghostDistance * 0.35; to: -root.ghostDistance; duration: 1300; easing.type: Easing.InOutSine }
            }
        }

        Text {
            anchors.centerIn: geometryText
            visible: root.enableGhost
            text: root.clockText()
            color: root.magentaColor
            opacity: root.ghostOpacity * 0.85
            font.family: geometryText.font.family
            font.pixelSize: geometryText.font.pixelSize
            font.weight: geometryText.font.weight
            font.letterSpacing: geometryText.font.letterSpacing
            transform: Translate { id: magentaGhostShift; x: root.ghostDistance }
            SequentialAnimation {
                running: root.enableGhost
                loops: Animation.Infinite
                NumberAnimation { target: magentaGhostShift; property: "x"; from: root.ghostDistance; to: -root.ghostDistance * 0.35; duration: 1550; easing.type: Easing.InOutSine }
                NumberAnimation { target: magentaGhostShift; property: "x"; from: -root.ghostDistance * 0.35; to: root.ghostDistance; duration: 1550; easing.type: Easing.InOutSine }
            }
        }

        // Matrix texture source, rendered off-screen and then masked into the glyphs.
        // Each column contains TWO full-height streams. The whole stream pair moves
        // by exactly one glyph height, producing a seamless loop with no empty half.
        Item {
            id: rainSource
            width: geometryText.width
            height: geometryText.height
            visible: false
            clip: true
            layer.enabled: true
            layer.smooth: true

            Repeater {
                model: root.enableMatrix ? root.matrixColumns : 0

                Item {
                    id: rainColumn
                    required property int index
                    width: rainSource.width / Math.max(1, root.matrixColumns)
                    height: rainSource.height
                    x: index * width
                    clip: true

                    // Keep neighboring columns from moving in lockstep.
                    property int duration: Math.round(root.rand(root.matrixSpeedMin, root.matrixSpeedMax))
                    property real startOffset: -root.rand(0, Math.max(1, rainSource.height))

                    Item {
                        id: streamPair
                        width: parent.width
                        height: rainSource.height * 2
                        y: rainColumn.startOffset

                        Text {
                            id: streamA
                            x: 0
                            y: 0
                            width: parent.width
                            height: rainSource.height
                            text: "01\n10\n11\n00\n01\n//\n<>\n10\n01\n11\n00\n10\n01\n<>\n11\n00\n01\n10\n00\n11\n<>\n01\n10\n//\n11\n00\n01\n10\n<>\n11\n01\n00\n10\n11\n01\n<>\n00\n10\n01\n11"
                            color: root.matrixColor
                            opacity: root.matrixOpacity
                            font.family: "Monospace"
                            font.weight: Font.Bold
                            font.pixelSize: Math.max(7, rainColumn.width * 0.78)
                            lineHeight: 0.78
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Text {
                            x: 0
                            y: rainSource.height
                            width: parent.width
                            height: rainSource.height
                            text: streamA.text
                            color: root.matrixColor
                            opacity: root.matrixOpacity
                            font.family: streamA.font.family
                            font.weight: streamA.font.weight
                            font.pixelSize: streamA.font.pixelSize
                            lineHeight: streamA.lineHeight
                            horizontalAlignment: Text.AlignHCenter
                        }

                        NumberAnimation on y {
                            from: -rainSource.height
                            to: 0
                            duration: Math.max(100, rainColumn.duration)
                            loops: Animation.Infinite
                            running: root.enableMatrix
                            easing.type: Easing.Linear
                        }
                    }
                }
            }
        }

        // Alpha mask for the effects. Keep it at the exact same dimensions as
        // geometryText and cache it as a texture. It is hidden visually, but
        // MultiEffect can still sample its alpha from the layer texture.
        Text {
            id: glyphMask
            anchors.fill: geometryText
            text: root.clockText()
            color: "white"
            visible: false
            font.family: geometryText.font.family
            font.pixelSize: geometryText.font.pixelSize
            font.weight: geometryText.font.weight
            font.letterSpacing: geometryText.font.letterSpacing
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            layer.enabled: true
            layer.smooth: true
        }

        MultiEffect {
            anchors.fill: geometryText
            source: rainSource
            visible: root.enableMatrix
            maskEnabled: true
            maskSource: glyphMask
            maskThresholdMin: 0.02
            maskThresholdMax: 1.0
            maskSpreadAtMin: 0.02
            maskSpreadAtMax: 0.0
            brightness: 0.18
            contrast: 0.10
            saturation: 0.25
            opacity: 0.98
            transform: Translate { x: root.burstJitterX; y: root.burstJitterY }
        }

        // CRT sweep source. Like the Matrix layer, this is visible only inside the digits.
        Item {
            id: scanSource
            width: geometryText.width
            height: geometryText.height
            visible: false
            clip: true
            layer.enabled: true
            layer.smooth: true

            Repeater {
                model: 9
                Rectangle {
                    required property int index
                    width: scanSource.width
                    height: index % 3 === 0 ? 3 : 1
                    y: index * (scanSource.height / 8)
                    color: index % 2 === 0 ? root.cyanColor : root.baseColor
                    opacity: root.scanlineOpacity * (index % 3 === 0 ? 0.9 : 0.45)
                }
            }

            Rectangle {
                id: sweepLine
                width: scanSource.width
                height: Math.max(2, scanSource.height * 0.025)
                color: root.cyanColor
                opacity: Math.min(1.0, root.scanlineOpacity * 1.6)
                y: -height
                NumberAnimation on y {
                    from: -sweepLine.height
                    to: scanSource.height
                    duration: Math.max(150, root.scanlineSpeed)
                    loops: Animation.Infinite
                    running: root.enableScanlines
                    easing.type: Easing.Linear
                }
            }
        }

        MultiEffect {
            anchors.fill: geometryText
            source: scanSource
            visible: root.enableScanlines
            maskEnabled: true
            maskSource: glyphMask
            maskThresholdMin: 0.02
            maskThresholdMax: 1.0
            maskSpreadAtMin: 0.02
            maskSpreadAtMax: 0.0
            opacity: 0.9
        }

        Text {
            anchors.centerIn: geometryText
            text: root.clockText()
            color: "transparent"
            font.family: geometryText.font.family
            font.pixelSize: geometryText.font.pixelSize
            font.weight: geometryText.font.weight
            font.letterSpacing: geometryText.font.letterSpacing
            style: Text.Outline
            styleColor: Qt.rgba(0.45, 1.0, 0.92, 0.50)
            opacity: 0.65
            transform: Translate { x: root.burstJitterX; y: root.burstJitterY }
        }

        // Short-lived chromatic registration split.
        Text {
            anchors.centerIn: geometryText
            text: root.clockText()
            color: root.cyanColor
            opacity: root.enableChroma && (root.chromaActive || root.bursting) ? 0.78 : 0.0
            font.family: geometryText.font.family
            font.pixelSize: geometryText.font.pixelSize
            font.weight: geometryText.font.weight
            font.letterSpacing: geometryText.font.letterSpacing
            transform: Translate { x: -(root.bursting ? 7 : 4); y: root.bursting ? 2 : 0 }
            Behavior on opacity { NumberAnimation { duration: 45 } }
        }

        Text {
            anchors.centerIn: geometryText
            text: root.clockText()
            color: root.magentaColor
            opacity: root.enableChroma && (root.chromaActive || root.bursting) ? 0.70 : 0.0
            font.family: geometryText.font.family
            font.pixelSize: geometryText.font.pixelSize
            font.weight: geometryText.font.weight
            font.letterSpacing: geometryText.font.letterSpacing
            transform: Translate { x: root.bursting ? 8 : 4; y: -(root.bursting ? 2 : 0) }
            Behavior on opacity { NumberAnimation { duration: 45 } }
        }

        // Horizontal displaced slices.
        Item {
            anchors.fill: geometryText
            visible: root.enableSlices && (root.glitching || root.bursting)

            Repeater {
                model: 9
                Item {
                    required property int index
                    width: geometryText.width
                    height: geometryText.height / 9
                    x: root.rand(-root.glitchStrength, root.glitchStrength)
                    y: index * height
                    clip: true

                    Text {
                        width: geometryText.width
                        height: geometryText.height
                        x: root.rand(-root.glitchStrength * 1.3, root.glitchStrength * 1.3)
                        y: -parent.y
                        text: root.clockText()
                        color: index % 3 === 0 ? root.magentaColor : index % 3 === 1 ? root.cyanColor : root.baseColor
                        opacity: index % 2 === 0 ? 0.85 : 0.55
                        font.family: geometryText.font.family
                        font.pixelSize: geometryText.font.pixelSize
                        font.weight: geometryText.font.weight
                        font.letterSpacing: geometryText.font.letterSpacing
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        // Tiny corruption streaks during the heavy burst.
        Repeater {
            model: 3
            Rectangle {
                required property int index
                visible: root.enableBurst && root.bursting
                width: geometryText.width * root.rand(0.20, 0.58)
                height: index === 1 ? 2 : 1
                x: geometryText.x + root.rand(0, Math.max(1, geometryText.width - width))
                y: geometryText.y + root.rand(0, Math.max(1, geometryText.height - height))
                color: index === 1 ? root.magentaColor : root.cyanColor
                opacity: 0.75
            }
        }
    }
}
