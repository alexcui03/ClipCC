/*
 * Scratch Project Editor and Player
 * Copyright (C) 2014 Massachusetts Institute of Technology
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

package uiwidgets {
	import flash.display.Sprite;

public class ZoomWidget extends Sprite {

	private var scriptsPane:ScriptsPane;
	private var zoom:int;

	private var smaller:IconButton;
	private var normal:IconButton;
	private var bigger:IconButton;

	public function ZoomWidget(scriptsPane:ScriptsPane) {
		this.scriptsPane = scriptsPane;
		addChild(smaller = new IconButton(zoomOut, 'zoomOut'));
		addChild(normal = new IconButton(noZoom, 'noZoom'));
		addChild(bigger = new IconButton(zoomIn, 'zoomIn'));
		var space:int = 0 ;
		if(Settings.zoomLine) {
			smaller.x = 0;//竖起来改成y
			normal.x = smaller.width+space;//24;
			bigger.x = normal.width+smaller.width+space*2;//48;
		}
		else {
			smaller.y = 0;//竖起来改成y
			normal.y = smaller.width+space;//24;
			bigger.y = normal.width + smaller.width + space * 2;//48;
		}
		smaller.isMomentary = true;
		normal.isMomentary = true;
		bigger.isMomentary = true;
	}

	private function zoomOut(b:IconButton):void { changeZoomBy(-1) }
	private function noZoom(b:IconButton):void { zoom = 0; changeZoomBy(0) }
	private function zoomIn(b:IconButton):void { changeZoomBy(1) }

	private function changeZoomBy(delta:int):void {
		const scaleFactors:Array = [25, 50, 75, 100, 125, 150, 200];
		zoom += delta;
		zoom = Math.max(-3, Math.min(zoom, 3));
		smaller.setDisabled(zoom < -2, 0.5);
		bigger.setDisabled(zoom > 2, 0.5);
		scriptsPane.setScale(scaleFactors[3 + zoom] / 100);
	}

}}
