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
import org.kde.plasma.plasmoid 2.0
import "../js/DateTimeFormatter.js" as DTF
import "../js/layouts.js" as Layouts

ColumnLayout {
	id: mainContainer

	Layout.fillWidth: true

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
		Layout.fillWidth: true
		Layout.alignment: Qt.AlignHCenter
		textFormat: Text.RichText
		font.pixelSize: 20  //Qt.application.font.pixelSize * 0.8
	}

	Timer {
		interval: 1000
		repeat: true
		running: true
		triggeredOnStart: true
		onTriggered: updateClock()
	}

	readonly property string layout: plasmoid.configuration.layout
	onLayoutChanged: updateClock()

	function updateClock() {
		var htmlString = layout
		if (htmlString == '') htmlString = Layouts.layouts[Layouts.defaultLayout]['html']

		// https://doc.qt.io/qt-5/qml-qtquick-text.html#textFormat-prop
		// https://doc.qt.io/qt-5/richtext-html-subset.html
		clock.text = DTF.format(htmlString)
	}

	// ------------------------------------------------------------------------------------------------------------------------

} // mainContainer
