/**
 * HTML Clock Plasmoid
 *
 * Configurable HTML styled clock plasmoid.
 *
 * @author    Marcin Orlowski <mail (#) marcinOrlowski (.) com>
 * @copyright 2020-2021 Marcin Orlowski
 * @license   http://www.opensource.org/licenses/mit-license.php MIT
 * @link      https://github.com/MarcinOrlowski/html-clock-plasmoid
 */

import QtQuick 2.1
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import "../js/DateTimeFormatter.js" as DTF
import "../js/layouts.js" as Layouts

ColumnLayout {
	id: mainContainer

	// ------------------------------------------------------------------------------------------------------------------------

	property string layoutKey: plasmoid.configuration.layoutKey
	property bool useUserLayout: plasmoid.configuration.useUserLayout

	// ------------------------------------------------------------------------------------------------------------------------

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		onClicked: {
			if (plasmoid.configuration.calendarViewEnabled) {
				plasmoid.expanded = !plasmoid.expanded
			}
		}
	}

	// ------------------------------------------------------------------------------------------------------------------------

	PlasmaComponents.Label {
		id: clock
		Layout.alignment: Qt.AlignHCenter
		textFormat: Text.RichText
		font.pixelSize: useUserLayout 
							? plasmoid.configuration.fontPixelSize
							: Layouts.layouts[layoutKey]['fontPixelSize']
	}

	PlasmaCore.DataSource {
		engine: "time"
		connectedSources: ["Local"]
		interval: 1000
		intervalAlignment: PlasmaCore.Types.NoAlignment
		onDataChanged: updateClock()
	}

	readonly property string layout: plasmoid.configuration.layout
	onLayoutChanged: updateClock()

	function updateClock() {
		var layoutHtml = useUserLayout 
				? plasmoid.configuration.layout
				: Layouts.layouts[layoutKey]['html']

		var localeToUse = plasmoid.configuration.useSpecificLocaleEnabled
				? plasmoid.configuration.useSpecificLocaleLocaleName 
				: ''
		var text = DTF.format(layoutHtml, localeToUse)

		var now = new Date()
		var blinkAlpha = (now.getSeconds() % 2) ? '00' : 'FF'
		clock.text = text.replace(new RegExp('{blink}', 'g'), blinkAlpha)
	}

	// ------------------------------------------------------------------------------------------------------------------------

} // mainContainer
