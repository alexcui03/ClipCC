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

// ClassPart.as
// Alex Cui, March 2018
//
// This part holds the sounds list for the current sprite (or stage),
// as well as the sound recorder, editor, and import button.

package ui.parts {
	import flash.display.*;
	import flash.events.KeyboardEvent;
	import flash.geom.*;
	import flash.text.*;
	import assets.Resources;
	import scratch.*;
	import sound.WAVFile;
	import soundedit.SoundEditor;
	import translation.Translator;
	import ui.media.*;
	import uiwidgets.*;
	
	public class ClassPart extends UIPart {
		public var currentIndex:int;

		private const columnWidth:int = 106;

		private var shape:Shape;
		
		private var listFrame:ScrollFrame;

		public function ClassPart(app:Scratch) {
			this.app = app;
			addChild(shape = new Shape());
			
			
		}

		public static function strings():Array {
			return ['Class Designer'];
		}

		public function updateTranslation():void {
			fixlayout();
		}

		public function refresh(refreshListContents:Boolean = true):void {
			
		}

		public function setWidthHeight(w:int, h:int):void {
			this.w = w;
			this.h = h;
			var g:Graphics = shape.graphics;
			g.clear();

			g.lineStyle(0.5, CSS.borderColor, 1, true);
			g.beginFill(CSS.tabColor);
			g.drawRect(0, 0, w, h);
			g.endFill();

			g.beginFill(0x000000);
			g.moveTo(columnWidth + 1, 0);
			g.lineTo(columnWidth + 1, h);
			g.endFill();
			
			g.lineStyle(0.5, CSS.borderColor, 1, true);
			g.beginFill(CSS.panelColor);
			g.drawRect(columnWidth * 2 + 1, 5, w - columnWidth - 6, h - 10);
			g.endFill();

			fixlayout();
		}

		private function fixlayout():void {
			var contentsX:int = columnWidth + 13;
			var contentsW:int = w - contentsX - 15;
		}
	}
}