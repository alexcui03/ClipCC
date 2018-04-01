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

// TopBarPart.as
// John Maloney, November 2011
//
// This part holds the Scratch Logo, cursor tools, screen mode buttons, and more.

package ui.parts
{
	import assets.Resources;
	import extensions.ExtensionDevManager;
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import translation.Translator;
	import uiwidgets.Button;
	import uiwidgets.CursorTool;
	import uiwidgets.IconButton;
	import uiwidgets.Menu;
	import uiwidgets.SimpleTooltips;
	
	public class TopBarPart extends UIPart
	{
		
		
		private var shape:Shape;
		
		protected var logoButton:IconButton;
		
		protected var languageButton:IconButton;
		
		protected var fileMenu:IconButton;
		
		protected var editMenu:IconButton;
		
		protected var myMenu:IconButton;//my Button
		
		private var copyTool:IconButton;
		
		private var cutTool:IconButton;
		
		private var growTool:IconButton;
		
		private var shrinkTool:IconButton;
		
		private var helpTool:IconButton;
		
		private var toolButtons:Array;
		
		private var toolOnMouseDown:String;
		
		private var offlineNotice:TextField;
		
		private const offlineNoticeFormat:TextFormat = new TextFormat(CSS.font,13,CSS.white,true);
		
		protected var loadExperimentalButton:Button;
		
		protected var exportButton:Button;
		
		protected var extensionLabel:TextField;
		
		protected const buttonSpace:int = 12;
		
		public function TopBarPart(param1:Scratch)
		{
			this.toolButtons = [];
			super();
			this.app = param1;
			this.addButtons();
			this.refresh();
		}
		
		public static function strings() : Array
		{
			if(Scratch.app)
			{
				Scratch.app.showFileMenu(Menu.dummyButton());
				Scratch.app.showEditMenu(Menu.dummyButton());
				Scratch.app.showmyMenu(Menu.dummyButton());
			}
			return ["File","Edit","Tips","Duplicate","Delete","Grow","Shrink","Block help","Offline Editor"];
		}
		
		protected function addButtons() : void
		{
			var desiredButtonHeight:Number = NaN;
			var scale:Number = NaN;
			var extensionDevManager:ExtensionDevManager = null;
			addChild(this.shape = new Shape());
			addChild(this.languageButton = new IconButton(app.setLanguagePressed,"languageButton"));
			this.languageButton.isMomentary = true;
			this.addTextButtons();
			this.addToolButtons();
			
				addChild(this.logoButton = new IconButton(app.logoButtonPressed,Resources.createBmp("scratchxlogo")));
				desiredButtonHeight = 20;
				this.logoButton.scaleX = this.logoButton.scaleY = 1;
				scale = desiredButtonHeight / this.logoButton.height;
				this.logoButton.scaleX = this.logoButton.scaleY = scale;
				addChild(this.exportButton = new Button("保存",function():void
				{
					app.exportProjectToFile();
				}));
				addChild(this.extensionLabel = makeLabel("My Extension",this.offlineNoticeFormat,2,2));
				extensionDevManager = Scratch.app.extensionManager as ExtensionDevManager;
				if(extensionDevManager)
				{
					//addChild(this.loadExperimentalButton = extensionDevManager.makeLoadExperimentalExtensionButton());
				}
		}
		
		protected function removeTextButtons() : void
		{
			if(this.fileMenu.parent)
			{
				removeChild(this.fileMenu);
				removeChild(this.editMenu);
				removeChild(this.myMenu);
			}
		}
		
		public function updateTranslation() : void
		{
			this.removeTextButtons();
			this.addTextButtons();
			if(this.offlineNotice)
			{
				this.offlineNotice.text = Translator.map("Offline Editor");
			}
			this.refresh();
		}
		
		public function setWidthHeight(param1:int, param2:int) : void
		{
			this.w = param1;
			this.h = param2;
			var _loc3_:Graphics = this.shape.graphics;
			_loc3_.clear();
			_loc3_.beginFill(CSS.topBarColor());
			_loc3_.drawRect(0,0,param1,param2);
			_loc3_.endFill();
			this.fixLayout();
		}
		
		protected function fixLogoLayout() : int
		{
			var _loc1_:int = 9;
			if(this.logoButton)
			{
				this.logoButton.x = _loc1_;
				this.logoButton.y = 5;
				_loc1_ = _loc1_ + (this.logoButton.width + this.buttonSpace);
			}
			return _loc1_;
		}
		
		protected function fixLayout() : void
		{
			var _loc2_:int = 0;
			var _loc1_:int = 5;
			_loc2_ = this.fixLogoLayout();
			this.languageButton.x = _loc2_;
			this.languageButton.y = _loc1_ - 1;
			_loc2_ = _loc2_ + (this.languageButton.width + this.buttonSpace);
			this.fileMenu.x = _loc2_;
			this.fileMenu.y = _loc1_;
			_loc2_ = _loc2_ + (this.fileMenu.width + this.buttonSpace);
			this.editMenu.x = _loc2_;
			this.editMenu.y = _loc1_;
			_loc2_ = _loc2_ + (this.editMenu.width + this.buttonSpace);
			this.myMenu.x = _loc2_;//zi ding yi
			this.myMenu.y = _loc1_;//zi ding yi
			_loc2_ = _loc2_ + (this.myMenu.width + this.buttonSpace);
			var _loc3_:int = 3;
			this.copyTool.x = !!app.isOffline?Number(493):Number(427);
			this.cutTool.x = this.copyTool.right() + _loc3_;
			this.growTool.x = this.cutTool.right() + _loc3_;
			this.shrinkTool.x = this.growTool.right() + _loc3_;
			this.helpTool.x = this.shrinkTool.right() + 99999999999;
			this.copyTool.y = this.cutTool.y = this.shrinkTool.y = this.growTool.y = this.helpTool.y = _loc1_ - 3;
			if(this.offlineNotice)
			{
				this.offlineNotice.x = w - this.offlineNotice.width - 5;
				this.offlineNotice.y = 5;
			}
			_loc2_ = w - 5;
			if(this.loadExperimentalButton)
			{
				this.loadExperimentalButton.x = _loc2_ - this.loadExperimentalButton.width;
				this.loadExperimentalButton.y = h + 5;
			}
			if(this.exportButton)
			{
				this.exportButton.x = _loc2_ - this.exportButton.width;
				this.exportButton.y = h + 5;
				_loc2_ = this.exportButton.x - 5;
			}
			if(this.extensionLabel)
			{
				this.extensionLabel.x = _loc2_ - this.extensionLabel.width;
				this.extensionLabel.y = h + 5;
				_loc2_ = this.extensionLabel.x - 5;
			}
		}
		
		public function refresh() : void
		{
			var _loc1_:Boolean = false;
			var _loc2_:ExtensionDevManager = null;
			if(app.isOffline)
			{
				this.helpTool.visible = app.isOffline;
			}
			if(Scratch.app.isExtensionDevMode)
			{
				_loc1_ = app.extensionManager.hasExperimentalExtensions();
				this.exportButton.visible = _loc1_;
				this.extensionLabel.visible = _loc1_;
				this.loadExperimentalButton.visible = !_loc1_;
				_loc2_ = app.extensionManager as ExtensionDevManager;
				if(_loc2_)
				{
					this.extensionLabel.text = _loc2_.getExperimentalExtensionNames().join(", ");
				}
			}
			this.fixLayout();
		}
		
		protected function addTextButtons() : void
		{
			addChild(this.fileMenu = makeMenuButton("File",app.showFileMenu,true));
			addChild(this.editMenu = makeMenuButton("Edit",app.showEditMenu,true));
			addChild(this.myMenu = makeMenuButton("Tools",app.showmyMenu,true));
		}
		
		private function addToolButtons() : void
		{
			var selectTool:Function = null;
			var b:IconButton = null;
			selectTool = function(param1:IconButton):void
			{
				var _loc2_:String = "";
				if(param1 == copyTool)
				{
					_loc2_ = "copy";
				}
				if(param1 == cutTool)
				{
					_loc2_ = "cut";
				}
				if(param1 == growTool)
				{
					_loc2_ = "grow";
				}
				if(param1 == shrinkTool)
				{
					_loc2_ = "shrink";
				}
				//if(param1 == helpTool)
				//{
				//	_loc2_ = "help";
				//}
				if(_loc2_ == toolOnMouseDown)
				{
					clearToolButtons();
					CursorTool.setTool(null);
				}
				else
				{
					clearToolButtonsExcept(param1);
					CursorTool.setTool(_loc2_);
				}
			};
			this.toolButtons.push(this.copyTool = this.makeToolButton("copyTool",selectTool));
			this.toolButtons.push(this.cutTool = this.makeToolButton("cutTool",selectTool));
			this.toolButtons.push(this.growTool = this.makeToolButton("growTool",selectTool));
			this.toolButtons.push(this.shrinkTool = this.makeToolButton("shrinkTool",selectTool));
			this.toolButtons.push(this.helpTool = this.makeToolButton("helpTool",selectTool));
			if(!app.isMicroworld)
			{
				for each(b in this.toolButtons)
				{
					addChild(b);
				}
			}
			SimpleTooltips.add(this.copyTool,{
				"text":"Duplicate",
				"direction":"bottom"
			});
			SimpleTooltips.add(this.cutTool,{
				"text":"Delete",
				"direction":"bottom"
			});
			SimpleTooltips.add(this.growTool,{
				"text":"Grow",
				"direction":"bottom"
			});
			SimpleTooltips.add(this.shrinkTool,{
				"text":"Shrink",
				"direction":"bottom"
			});
		//	SimpleTooltips.add(this.helpTool,{
		//		"text":"Block help",
		//		"direction":"bottom"
		//	});
		}
		
		public function clearToolButtons() : void
		{
			this.clearToolButtonsExcept(null);
		}
		
		private function clearToolButtonsExcept(param1:IconButton) : void
		{
			var _loc2_:IconButton = null;
			for each(_loc2_ in this.toolButtons)
			{
				if(_loc2_ != param1)
				{
					_loc2_.turnOff();
				}
			}
		}
		
		private function makeToolButton(param1:String, param2:Function) : IconButton
		{
			var mouseDown:Function = null;
			var iconName:String = param1;
			var fcn:Function = param2;
			mouseDown = function(param1:MouseEvent):void
			{
				toolOnMouseDown = CursorTool.tool;
			};
			var onImage:Sprite = this.toolButtonImage(iconName,CSS.overColor,1);
			var offImage:Sprite = this.toolButtonImage(iconName,0,0);
			var b:IconButton = new IconButton(fcn,onImage,offImage);
			b.actOnMouseUp();
			b.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
			return b;
		}
		
		private function toolButtonImage(param1:String, param2:int, param3:Number) : Sprite
		{
			var _loc6_:Bitmap = null;
			var _loc4_:int = 23;
			var _loc5_:int = 24;
			var _loc7_:Sprite = new Sprite();
			var _loc8_:Graphics = _loc7_.graphics;
			_loc8_.clear();
			_loc8_.beginFill(param2,param3);
			_loc8_.drawRoundRect(0,0,_loc4_,_loc5_,8,8);
			_loc8_.endFill();
			_loc7_.addChild(_loc6_ = Resources.createBmp(param1));
			_loc6_.x = Math.floor((_loc4_ - _loc6_.width) / 2);
			_loc6_.y = Math.floor((_loc5_ - _loc6_.height) / 2);
			return _loc7_;
		}
		
		protected function makeButtonImg(param1:String, param2:int, param3:Boolean) : Sprite
		{
			var _loc4_:Sprite = new Sprite();
			var _loc5_:TextField = makeLabel(Translator.map(param1),CSS.topBarButtonFormat,2,2);
			_loc5_.textColor = CSS.white;
			_loc5_.x = 6;
			_loc4_.addChild(_loc5_);
			var _loc6_:int = _loc5_.textWidth + 16;
			var _loc7_:int = 22;
			var _loc8_:Graphics = _loc4_.graphics;
			_loc8_.clear();
			_loc8_.beginFill(param2);
			_loc8_.drawRoundRect(0,0,_loc6_,_loc7_,8,8);
			_loc8_.endFill();
			return _loc4_;
		}
	}
}
