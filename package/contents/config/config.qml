import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Appearance")
        icon: "preferences-desktop-font"
        source: "configAppearance.qml"
    }
    ConfigCategory {
        name: i18n("Effects")
        icon: "preferences-desktop-effects"
        source: "configEffects.qml"
    }
}
