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

// CSS.as
// Paula Bonta, November 2011
//
// Styles for Scratch Editor based on the Upstatement design.

package {
	import flash.text.*;
	import assets.Resources;

public class CSS {

	public static function topBarColor():int { return Scratch.app.isExtensionDevMode ? topBarColor_default : topBarColor_default; }
	public static function backgroundColor():int { return Scratch.app.isExtensionDevMode ? backgroundColor_default : backgroundColor_default; }

	// ScratchX
	public static const topBarColor_ScratchX:int = 0x4c97ff//0x30485f;
	public static const backgroundColor_ScratchX:int = white//0x3f5975;

	// Colors
	public static const white:int = 0xFFFFFF;
	public static const backgroundColor_default:int = white;
	public static const topBarColor_default:int = 0x4c97ff;
	public static const tabColor:int = 0xf9f9f9;
	public static const panelColor:int = 0xf7fafc;
	public static const itemSelectedColor:int = 0xf9f9f9;
	public static const borderColor:int = 0xe0e0e0;
	public static const textColor:int = 0x575e74; // 0x6C6D6F
	public static const buttonLabelColor:int = 0x575e74;
	public static const buttonLabelOverColor:int = 0x55ddff;
	public static const offColor:int = 0x6A787A; // 0x9FA1A3
	public static const onColor:int = textColor; // 0x4C4D4F
	public static const overColor:int = 0x4c97ff;
	public static const arrowColor:int = 0x4c97ff;

	// Fonts
	public static const font:String = Resources.chooseFont(['Arial', 'Verdana', 'DejaVu Sans']);
	public static const menuFontSize:int = 12;
	public static const normalTextFormat:TextFormat = new TextFormat(font, 12, textColor);
	public static const topBarButtonFormat:TextFormat = new TextFormat(font, 12, white, true);
	public static const titleFormat:TextFormat = new TextFormat(font, 14, textColor);
	public static const thumbnailFormat:TextFormat = new TextFormat(font, 12, textColor);
	public static const thumbnailExtraInfoFormat:TextFormat = new TextFormat(font, 9, textColor);
	public static const projectTitleFormat:TextFormat = new TextFormat(font, 13, textColor);
	public static const projectInfoFormat:TextFormat = new TextFormat(font, 12, textColor);

	// Section title bars
	public static const titleBarColors:Array = [white];
	public static const titleBarH:int = 30;

}}
