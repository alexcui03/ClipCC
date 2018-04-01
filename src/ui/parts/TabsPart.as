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

// TabsPart.as
// John Maloney, November 2011
//
// This part holds the tab buttons to view scripts, costumes/scenes, or sounds.

package ui.parts {
	import flash.display.*;
	import flash.text.*;
	import translation.Translator;
	import uiwidgets.IconButton;
	
	public class TabsPart extends UIPart {
		
		private var scriptsTab:IconButton;
		private var imagesTab:IconButton;
		private var soundsTab:IconButton;
		private var codeTab:IconButton;
		private var classTab:IconButton;
		
		public function TabsPart(app:Scratch) {
			function selectScripts(b:IconButton):void { app.setTab('scripts') }
			function selectImages(b:IconButton):void { app.setTab('images') }
			function selectSounds(b:IconButton):void { app.setTab('sounds') }
			function selectCode(b:IconButton):void { app.setTab('code') }
			function selectClass(b:IconButton):void { app.setTab('class') }
			
			this.app = app;
			scriptsTab = makeTab('Scripts', selectScripts);
			imagesTab = makeTab('Images', selectImages); // changed to 'Costumes' or 'Scenes' by refresh()
			soundsTab = makeTab('Sounds', selectSounds);
			codeTab = makeTab('Code', selectCode);
			classTab = makeTab('Class', selectClass);
			addChild(scriptsTab);
			addChild(imagesTab);
			addChild(soundsTab);
			addChild(codeTab);
			addChild(classTab);
			scriptsTab.turnOn();
		}
		
		public static function strings():Array {
			return ['Scripts', 'Costumes', 'Backdrops', 'Sounds', 'Code', 'Class'];
		}
		
		public function refresh():void {
			var label:String = ((app.viewedObj() != null) && app.viewedObj().isStage) ? 'Backdrops' : 'Costumes';
			imagesTab.setImage(makeTabImg(label, true), makeTabImg(label, false));
			fixLayout();
		}
		
		public function selectTab(tabName:String):void {
			scriptsTab.turnOff();
			imagesTab.turnOff();
			soundsTab.turnOff();
			codeTab.turnOff();
			classTab.turnOff();
			if (tabName == 'scripts') scriptsTab.turnOn();
			if (tabName == 'images') imagesTab.turnOn();
			if (tabName == 'sounds') soundsTab.turnOn();
			if (tabName == 'code') codeTab.turnOn();
			if (tabName == 'class') classTab.turnOn();
		}
		
		public function fixLayout():void {
			scriptsTab.x = 0;
			scriptsTab.y = 0;
			imagesTab.x = scriptsTab.x + scriptsTab.width + 1;
			imagesTab.y = 0;
			soundsTab.x = imagesTab.x + imagesTab.width + 1;
			soundsTab.y = 0;
			codeTab.x = soundsTab.x + soundsTab.width + 1;
			codeTab.y = 0;
			classTab.x = codeTab.x + codeTab.width + 1;
			classTab.y = 0;
			this.w = classTab.x + classTab.width;
			this.h = scriptsTab.height;
		}
		
		public function updateTranslation():void {
			scriptsTab.setImage(makeTabImg('Scripts', true), makeTabImg('Scripts', false));
			soundsTab.setImage(makeTabImg('Sounds', true), makeTabImg('Sounds', false));
			codeTab.setImage(makeTabImg('Code', true), makeTabImg('Code', false));
			classTab.setImage(makeTabImg('Class', true), makeTabImg('Class', false));
			refresh(); // updates imagesTabs
		}
		
		private function makeTab(label:String, action:Function):IconButton {
			return new IconButton(action, makeTabImg(label, true), makeTabImg(label, false), true);
		}
		
		private function makeTabImg(label:String, isSelected:Boolean):Sprite {
			var img:Sprite = new Sprite();
			var tf:TextField = new TextField();
			tf.defaultTextFormat = new TextFormat(CSS.font, 12, isSelected ? CSS.onColor : CSS.offColor, false);
			tf.text = Translator.map(label);
			tf.width = tf.textWidth + 5;
			tf.height = tf.textHeight + 5;
			tf.x = 10;
			tf.y = 4;
			img.addChild(tf);
			
			var g:Graphics = img.graphics;
			var w:int = tf.width + 20;
			var h:int = 28;
			var r:int = 9;
			if (isSelected) drawTopBar(g, CSS.titleBarColors, getTopBarPath(w, h), w, h);
			else drawSelected(g, /*[0xf2f2f2, 0xd1d2d3]*/[0xf7fafc,0xf7fafc], getTopBarPath(w, h), w, h);
			return img;
		}
		
	}
}

