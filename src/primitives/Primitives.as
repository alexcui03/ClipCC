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

// Primitives.as
// John Maloney, April 2010
//
// Miscellaneous primitives. Registers other primitive modules.
// Note: A few control structure primitives are implemented directly in Interpreter.as.

package primitives {
	import flash.display.BitmapData;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import blocks.Block;
	import blocks.BlockArg;
	
	import interpreter.Interpreter;
	
	import scratch.ScratchObj;
	import scratch.ScratchSprite;
	import scratch.ScratchStage;
	
	import translation.Translator;
	
	import uiwidgets.DialogBox;
	
	import watchers.ListWatcher;
	
	import flash.desktop.Clipboard; 
	import flash.desktop.ClipboardFormats; 
	import flash.desktop.ClipboardTransferMode; 


	


public class Primitives {

	private const MaxCloneCount:int = 16384;

	protected var app:Scratch;
	protected var interp:Interpreter;
	private var counter:int;

	public function Primitives(app:Scratch, interpreter:Interpreter) {
		this.app = app;
		this.interp = interpreter;
	}
	
	
	public function addPrimsTo(primTable:Dictionary):void {
		// operators
		primTable["+"]				= function(b:*):* { return interp.numarg(b, 0) + interp.numarg(b, 1) };
		primTable["-"]				= function(b:*):* { return interp.numarg(b, 0) - interp.numarg(b, 1) };
		primTable["*"]				= function(b:*):* { return interp.numarg(b, 0) * interp.numarg(b, 1) };
		primTable["/"]				= function(b:*):* { return interp.numarg(b, 0) / interp.numarg(b, 1) };
		primTable["randomFrom:to:"]	= primRandom;
		primTable["<"]				= function(b:*):* { return compare(interp.arg(b, 0), interp.arg(b, 1)) < 0 };
		primTable["="]				= function(b:*):* { return compare(interp.arg(b, 0), interp.arg(b, 1)) == 0 };
		primTable[">"]				= function(b:*):* { return compare(interp.arg(b, 0), interp.arg(b, 1)) > 0 };
		primTable["&"]				= function(b:*):* { return interp.arg(b, 0) && interp.arg(b, 1) };
		primTable["|"]				= function(b:*):* { return interp.arg(b, 0) || interp.arg(b, 1) };
		primTable["not"]			= function(b:*):* { return !interp.arg(b, 0) };
		primTable["abs"]			= function(b:*):* { return Math.abs(interp.numarg(b, 0)) };
		primTable["sqrt"]			= function(b:*):* { return Math.sqrt(interp.numarg(b, 0)) };
		primTable["≠"]= notEqualTo;
		primTable["≥"]= greaterOrEqualTo;
		primTable["≤"]= lessOrEqualTo;


		primTable["concatenate:with:"]	= function(b:*):* { return ("" + interp.arg(b, 0) + interp.arg(b, 1)).substr(0, 10240); };
		primTable["letter:of:"]			= primLetterOf;
		primTable["stringLength:"]		= function(b:*):* { return String(interp.arg(b, 0)).length };

		primTable["%"]					= primModulo;
		primTable["rounded"]			= function(b:*):* { return Math.round(interp.numarg(b, 0)) };
		primTable["computeFunction:of:"] = primMathFunction;

		// clone
		primTable["createCloneOf"]		= primCreateCloneOf;
		primTable["deleteClone"]		= primDeleteClone;
		primTable["whenCloned"]			= interp.primNoop;

		// testing (for development)
		primTable["NOOP"]				= interp.primNoop;
		primTable["COUNT"]				= function(b:*):* { return counter };
		primTable["INCR_COUNT"]			= function(b:*):* { counter++ };
		primTable["CLR_COUNT"]			= function(b:*):* { counter = 0 };

		//club
		
	    //primTable["setDragTrue"]= setDragTrue;	
		//primTable["setDragFalse"]= setDragFalse;
		primTable["dFrom:to:"]			= d;
		
		primTable["Donothing"]=function(b:*):* { return '你并没有在容器里启动编辑器所以此功能不可用' };
		primTable["showtip"]=function(b:*):* { 
			if (interp.arg(b, 2)=='false')DialogBox.notifybuttontext(interp.arg(b, 0),interp.arg(b, 1),null,false,null,null,null,interp.arg(b, 3));
			else DialogBox.notifybuttontext(interp.arg(b, 0),interp.arg(b, 1),null,true,null,null,null,interp.arg(b, 3));
		};
		//primTable["showReturnValueTip"]=function(b:*):* { 
		//	if (interp.arg(b, 2)=='false')DialogBox.notifyReturnValuebuttontext(interp.arg(b, 0),interp.arg(b, 1),null,false,null,null,null,interp.arg(b, 3));
		//	else DialogBox.notifyReturnValuebuttontext(interp.arg(b, 0),interp.arg(b, 1),null,true,null,null,null,interp.arg(b, 3));
		//};
		primTable["goto	Web"]=function(b:*):* { 
			navigateToURL (new URLRequest(" http://www.baidu.com/"), "_blank");
		};
		primTable["closeWeb"]=function(b:*):* { 
			var url:URLRequest = new URLRequest("javascript:window.close()");
			navigateToURL(url,"_top");
		};
		//primTable["≠"]= notEqualTo;
		//primTable["≥"]= greaterOrEqualTo;
		//primTable["≤"]= lessOrEqualTo;
		primTable["createVar"]			= function(b:*):* {	app.viewedObj().lookupOrCreateVar(interp.arg(b, 0)) };
		primTable["deleteVar"]			= function(b:*):* { app.viewedObj().deleteVar(interp.arg(b, 0)) };
		primTable["lookup"]				= function(b:*):* {if (String(app.viewedObj().lookupVar(interp.arg(b, 0)))=='null')return false;else return true;};
		primTable["getVariableValue"]	= function(b:*):* { return app.viewedObj().lookupVar(interp.arg(b, 0)).value };
		primTable["getunicode"]=function(b:*):* {var s;s=interp.arg(b, 0);return s.charCodeAt();};
		primTable["unicodegetchar"]=function(b:*):* {var s=String.fromCharCode(interp.arg(b, 0));return s;};
		primTable["getascll"]=function(b:*):* {var s;s=interp.arg(b, 0);if (s.charCodeAt()>256)return "";return s.charCodeAt();};
		primTable["ascllgetchar"]=function(b:*):* {if (interp.arg(b,0)>256) return ""; var s=String.fromCharCode(interp.arg(b, 0));return s;};
		primTable["setAttr:of:no:to:"]= setAttr;
		
		primTable["turbo"]= turbo;
		primTable["turboOn"]= turboOn;
		primTable["turboOff"]= turboOff;
		primTable["isClone"]= isClone;
		primTable["cloneIndex"]= cloneIndex;
		primTable["countSprites"]= countSprites;
		primTable["countSpritesNamed:"]= countSpritesNamed;
		primTable["clone:no:exists"]= doesExist;
		primTable["printTxt"]= printTxt;
		primTable["hideTxt"]= hideTxt;
		primTable["showTxt"]= showTxt;
		
		
		primTable["thisName"]= thisName;
		primTable["setName"]= setName;
		
		primTable["dFromX1:Y1:toX2:Y2:"]= dPoints;
		primTable["uxFrom:to:"]			= ux;
		primTable["uyFrom:to:"]			= uy;
		primTable["uxFromX1:Y1:toX2:Y2:"]= uxPoints;
		primTable["uyFromX1:Y1:toX2:Y2:"]= uyPoints;
		primTable["xCompOf:at:"]= xComp;
		primTable["yCompOf:at:"]= yComp;
		primTable["dirFromX1:Y1:toX2:Y2:"]= dirPoints;
		primTable["dirForX:Y:"]= dirForXY;
		primTable["dirFrom:to:"]		= dir;
		primTable["addTag:"]= addTag;
		primTable["deleteTag:"]= deleteTag;
		primTable["addTag:to:no:"]= addTagTo;
		primTable["deleteTag:from:no:"]= deleteTagFrom;
		primTable["getTagNo:"]= getTagNumber;
		primTable["countTags"]= countTags;
		primTable["getTagNo:of:clone:"]= getTagNumberOfClone;
		primTable["hasTag:"]= hasTag;
		primTable["clone:no:hasTag:"]= cloneHasTag;
		
		primTable["touching:no:"]= touchingClone;
		
		primTable["layer"]= layer;
		primTable["show:costumeName"]= cosName;
		primTable["effect"]= effect;
		
		primTable["root"] = function(b:*):* { return Math.pow(interp.numarg(b, 0),1/interp.numarg(b, 1));};
		
		primTable["Greatestcommondivisor"]	= function(b:*):* { 
			var a,b,r;
			a=interp.numarg(b, 0);
			b=interp.numarg(b, 1);
			while (b!=0)
			{
				r=a%b;  
				a=b;  
				b=r;  
			}  
			return a};
		
		primTable["Leastcommonmultiple"]	= function(b:*):* { 
			var a,b,r,c,d;
			a=interp.numarg(b, 0);
			b=interp.numarg(b, 1);
			c=a;
			d=b;
			while (b!=0)
			{
				r=a%b;  
				a=b;  
				b=r;  
			}  
			return c*d/a};
		primTable["tobin"]= function(b:*):* {
			var a:Array=new Array();
			var i,j,p;
			j=0;
			i=interp.numarg(b, 0);
			//	if (i.indexOf(".")!=0) return "NaN";
			if (i<0) i=0-i;
			//			if (i!==int(i)) return "NaN";
			if (Math.round(i)!=i) return "NaN";
			while (i!=0)
			{
				a[j]=i%2;
				if (i%2!=0) i=(i-1)/2;
				else i=i/2;
				j++;
			}
			p=0;
			for (i=j-1;i>=0;i--)
				p=p*10+a[i];
			if (interp.numarg(b, 0)<0)
				p=0-p;
			return p};		
		
		primTable["todec"]= function(b:*):* {
			
			
			var i,n,p,a;
			n=String(interp.numarg(b, 0));
			p=0;
			a=0;
			if (n.charAt(1)=='-') a=1;
			for (i=1;i<=n.length;i++)
			{
				if (n.charAt(n.length-i)=='1')
					p=p+Math.round(10*Math.pow(2,i-1))/10;
				
			}
			if (a==1) p=0-p;
			return p};
		

		
		
		new LooksPrims(app, interp).addPrimsTo(primTable);
		new MotionAndPenPrims(app, interp).addPrimsTo(primTable);
		new SoundPrims(app, interp).addPrimsTo(primTable);
		new VideoMotionPrims(app, interp).addPrimsTo(primTable);
		//new ArduinoPrims(app, interp).addPrimsTo(primTable);
		addOtherPrims(primTable);
	}
	
	protected function addOtherPrims(primTable:Dictionary):void {
		new SensingPrims(app, interp).addPrimsTo(primTable);
		new ListPrims(app, interp).addPrimsTo(primTable);
	}
	
	private function primRandom(b:Block):Number {
		var n1:Number = interp.numarg(b, 0);
		var n2:Number = interp.numarg(b, 1);
		var low:Number = (n1 <= n2) ? n1 : n2;
		var hi:Number = (n1 <= n2) ? n2 : n1;
		if (low == hi) return low;

		// if both low and hi are ints, truncate the result to an int
		var ba1:BlockArg = b.args[0] as BlockArg;
		var ba2:BlockArg = b.args[1] as BlockArg;
		var int1:Boolean = ba1 ? ba1.numberType == BlockArg.NT_INT : int(n1) == n1;
		var int2:Boolean = ba2 ? ba2.numberType == BlockArg.NT_INT : int(n2) == n2;
		if (int1 && int2)
			return low + int(Math.random() * ((hi + 1) - low));

		return (Math.random() * (hi - low)) + low;
	}

	private function primLetterOf(b:Block):String {
		var s:String = interp.arg(b, 1);
		var i:int = interp.numarg(b, 0) - 1;
		if ((i < 0) || (i >= s.length)) return "";
		return s.charAt(i);
	}

	private function primModulo(b:Block):Number {
		var n:Number = interp.numarg(b, 0);
		var modulus:Number = interp.numarg(b, 1);
		var result:Number = n % modulus;
		if (result / modulus < 0) result += modulus;
		return result;
	}

	private function primMathFunction(b:Block):Number {
		var op:* = interp.arg(b, 0);
		var n:Number = interp.numarg(b, 1);
		switch(op) {
		case "abs": return Math.abs(n);
		case "floor": return Math.floor(n);
		case "ceiling": return Math.ceil(n);
		case "int": return n - (n % 1); // used during alpha, but removed from menu
		case "sqrt": return Math.sqrt(n);
		case "立方根": return Math.pow(n,1/3);
		case "sin": return Math.sin((Math.PI * n) / 180);
		case "cos": return Math.cos((Math.PI * n) / 180);
		case "tan": return Math.tan((Math.PI * n) / 180);
		case "asin": return (Math.asin(n) * 180) / Math.PI;
		case "acos": return (Math.acos(n) * 180) / Math.PI;
		case "atan": return (Math.atan(n) * 180) / Math.PI;
		case "ln": return Math.log(n);
		case "log": return Math.log(n) / Math.LN10;
		case "e ^": return Math.exp(n);
		case "10 ^": return Math.pow(10, n);
		}
		return 0;
	}
	
	//Clip Blocks================
	private function notEqualTo(b:Block):Boolean {
		var s1:* = interp.arg(b, 0);
		var s2:* = interp.arg(b, 1);
		if (!s1 || !s2) return false;
		return s1 != s2;
		
	}
	private function lessOrEqualTo(b:Block):Boolean {
		var s1:* = interp.arg(b, 0);
		var s2:* = interp.arg(b, 1);
		if (!s1 || !s2) return false;
		return s1 <= s2;
		
	}
	private function greaterOrEqualTo(b:Block):Boolean {
		var s1:* = interp.arg(b, 0);
		var s2:* = interp.arg(b, 1);
		if (!s1 || !s2) return false;
		return s1 >= s2;
		
	}
	
	private function doesExist(b:Block):Boolean {
		var num:int = int(interp.numarg(b, 1));
		var str: String = "";
		if ('_myself_' == String(interp.arg(b, 0))) {
			str = interp.activeThread.target.objName;
		} else{
			str = String(interp.arg(b, 0));
		}
		var hits:Array = app.stagePane.spritesAndClonesNamed(str);
		for each (var s:ScratchSprite in hits)
		if(s.cloneID == num) return true;
		return false;
	}

	
	private function countSprites(b:Block):Number {
		var num:int = interp.numarg(b, 0);
		return app.stagePane.countSpritesAndClones();
	}
	
	private function cloneIndex(b:Block):int {
		var clone:ScratchSprite = interp.targetSprite();
		if ((clone == null) || (!clone.isClone) || (clone.parent == null)) return 0;
		return clone.cloneID;
	}

	
	public function addTagTo(b:Block):void {
		var t:String = interp.arg(b, 0);
		var num:int = int(interp.numarg(b, 2));
		var str: String = "";
		if ('_myself_' == String(interp.arg(b, 1))) {
			str = interp.activeThread.target.objName;
		} else{
			str = String(interp.arg(b, 1));
		}
		var hits:Array = app.stagePane.spritesAndClonesNamed(str);
		for each (var s:ScratchSprite in hits)
		if(s.cloneID == num) {
			for (var ticker:int = 0; ticker < s.tags.length; ticker++)
				if (s.tags[ticker] == t){
					return;
				}
			s.tags.push(t);
		}
	}
	public function deleteTagFrom(b:Block):void {
		var tag:String = interp.arg(b, 0);
		var num:int = int(interp.numarg(b, 2));
		var str:String = '';
		if ('_myself_' == String(interp.arg(b, 1))) {
			str = interp.activeThread.target.objName;	
		} else {
			str = String(interp.arg(b, 1));
		}
		var hits:Array = app.stagePane.spritesAndClonesNamed(str);
		for each (var s:ScratchSprite in hits)
		if(s.cloneID == num) {			
			var oldTags:Array = s.tags;
			for (var ticker:int = 0; ticker < oldTags.length; ticker++)
				if (oldTags[ticker] == tag){
					s.tags.splice(ticker, 1);
					ticker--;
				}
			ticker++;
		}
	}

	private function cosName(b:Block):String {
		var s:ScratchSprite = interp.targetSprite();
		return s.currentCostume().costumeName;
	}
	
	private function ux(b:Block):Number {
		var p1:Point = mouseOrSpritePosition(interp.arg(b, 0));
		var p2:Point = mouseOrSpritePosition(interp.arg(b, 1));
		if ((p1 == null || p1 == p2) || (p2 == null)) return 0;
		var dx:Number = p2.x - p1.x;
		var dy:Number = p2.y - p1.y;
		return dx/Math.sqrt((dx * dx) + (dy * dy));
	}
	
	private function uy(b:Block):Number {
		var p1:Point = mouseOrSpritePosition(interp.arg(b, 0));
		var p2:Point = mouseOrSpritePosition(interp.arg(b, 1));
		if ((p1 == null || p1 == p2) || (p2 == null)) return 0;
		var dx:Number = p2.x - p1.x;
		var dy:Number = p2.y - p1.y;
		return dy/Math.sqrt((dx * dx) + (dy * dy));
	}
	
	private function turbo(b:Block):Boolean {
		return interp.turboMode;
	}
	
	private function turboOn(b:Block):void {
		interp.turboMode = true;
	}
	
	private function turboOff(b:Block):void {
		interp.turboMode = false;
	}
	
	private function effect(b:Block):Number {
		var s:ScratchObj = interp.targetObj();
		if (s == null) return 0;
		var filterName:String = interp.arg(b, 0);
		return s.filterPack.getFilterSetting(filterName);
	}
	
	private function isClone(b:Block):Boolean {
		var s:ScratchObj = interp.targetObj();
		if (s == null) return false;
		return s.isClone;
	}
	
	private function uxPoints(b:Block):Number {
		var x1:Number = interp.targetSprite().scratchX;
		var y1:Number = interp.targetSprite().scratchY;
		var x2:Number = interp.targetSprite().scratchX;
		var y2:Number = interp.targetSprite().scratchY;
		
		x1 = interp.numarg(b, 0);
		y1 = interp.numarg(b, 1);
		x2 = interp.numarg(b, 2);
		y2 = interp.numarg(b, 3);
		
		if (x1==x2 && y1==y2) return 0;
		var dx:Number = x2 - x1;
		var dy:Number = y2 - y1;
		return dx/Math.sqrt((dx * dx) + (dy * dy));
	}
	
	private function uyPoints(b:Block):Number {
		var x1:Number = interp.targetSprite().scratchX;
		var y1:Number = interp.targetSprite().scratchY;
		var x2:Number = interp.targetSprite().scratchX;
		var y2:Number = interp.targetSprite().scratchY;
		
		x1 = interp.numarg(b, 0);
		y1 = interp.numarg(b, 1);
		x2 = interp.numarg(b, 2);
		y2 = interp.numarg(b, 3);
		
		if (x1==x2 && y1==y2) return 0;
		var dx:Number = x2 - x1;
		var dy:Number = y2 - y1;
		return dy/Math.sqrt((dx * dx) + (dy * dy));
	}
	
	private function xComp(b:Block):Number {
		var r:Number = interp.numarg(b, 0);
		var t:Number = interp.numarg(b, 1);
		return r * Math.round(100*Math.cos((90-t)*3.14/180))/100;
	}
	
	private function yComp(b:Block):Number {
		var r:Number = interp.numarg(b, 0);
		var t:Number = interp.numarg(b, 1);
		return r * Math.round(100*Math.sin((90-t)*3.14/180))/100;
	}
	
	private function dirPoints(b:Block):Number {
		var x1:Number = interp.numarg(b, 0);
		var y1:Number = interp.numarg(b, 1);
		var x2:Number = interp.numarg(b, 2);
		var y2:Number = interp.numarg(b, 3);
		//if (x1 == null || y1 == null  || x2 == null || y2 == null || (x1==x2 && y1==y2)) return null;
		if (x1==x2 && y1==y2) return 0;
		var dx:Number = x2-x1;
		var dy:Number = y2-y1;
		return theta(dx,dy);
	}
	
	private function theta(xVal:Number, yVal:Number):Number {
		var alpha:Number = 90;
		if(yVal == 0)
		{
			if (xVal < 0) alpha = -90;
		}
		else
		{
			if (xVal >= 0)
			{
				alpha = 90 - Math.atan(yVal/xVal)*180/3.14;
			}
			else
			{
				alpha = - 90 - Math.atan(yVal/xVal)*180/3.14;
			}
		}
		return Math.round(10*alpha)/10;
	}
	private function dirForXY(b:Block):Number {
		var xVal:Number = interp.numarg(b, 0);
		var yVal:Number = interp.numarg(b, 1);
		return theta(xVal,yVal);
	}
	
	private function dir(b:Block):Number {
		var p1:Point = mouseOrSpritePosition(interp.arg(b, 0));
		var p2:Point = mouseOrSpritePosition(interp.arg(b, 1));
		if (p1 == p2) return 0;
		if (p1 == null) 
		{
			p1 = new Point(interp.targetSprite().scratchX,interp.targetSprite().scratchY);
		}
		else if (p2 == null)
		{
			p2 = new Point(interp.targetSprite().scratchX,interp.targetSprite().scratchY);
		}
		var dx:Number = p2.x - p1.x;
		var dy:Number = p2.y - p1.y;
		return theta(dx,dy);
	}
	
	private function setAttr(b:Block):void {
		var attribute:String = interp.arg(b, 0);
		var num:int = int(interp.numarg(b, 2));
		var str: String = String(interp.arg(b, 1));
		var val: * = String(interp.arg(b, 3));
		if ('_myself_' == str) {
			s = interp.activeThread.target;
			if ('x position' == attribute) s.setScratchXY(val, s.scratchY);
			if ('y position' == attribute) s.setScratchXY(s.scratchX, val);
			if ('direction' == attribute) s.setDirection(val);
			if ('costume #' == attribute) setCostume(s, val);
			if ('costume name' == attribute) setCostume(s, val);
			if ('size' == attribute) s.setSize(val);
			if ('volume' == attribute) s.setVolume(val);
			if (s.ownsVar(attribute)) s.setVarTo(attribute,val);
		}
		var hits:Array = app.stagePane.spritesAndClonesNamed(str);
		for each (var s:ScratchSprite in hits)
		if(s.cloneID == num) {
			if ('x position' == attribute) s.setScratchXY(val, s.scratchY);
			if ('y position' == attribute) s.setScratchXY(s.scratchX, val);
			if ('direction' == attribute) s.setDirection(val);
			if ('costume #' == attribute) setCostume(s, val);
			if ('costume name' == attribute) setCostume(s, val);
			if ('size' == attribute) s.setSize(val);
			if ('volume' == attribute) s.setVolume(val);
			if (s.ownsVar(attribute)) s.setVarTo(attribute,val);
		}
	}

	private function setCostume(s:ScratchObj, c:*):void {
		if (s == null) return;
		if (typeof(c) == 'number') {
			s.showCostume(c - 1);
		} else {
			var i:int = s.indexOfCostumeNamed(c);
			if (i >= 0) {
				s.showCostume(i);
			} else {
				var n:Number = Interpreter.asNumber(c);
				if (!isNaN(n)) s.showCostume(n - 1);
				else return; // arg did not match a costume name nor is it a valid number
			}
		}
		if (s.visible) interp.redraw();
	}

	public function addTag(b:Block):void {
		var s:ScratchSprite = interp.targetSprite();
		var tag:* = interp.arg(b, 0);
		for (var ticker:int = 0; ticker < s.tags.length; ticker++)
			if (s.tags[ticker] == tag){
				return;
			}
		s.tags.push(tag);
	}
	
	public function deleteTag(b:Block):void {
		var s:ScratchSprite = interp.targetSprite();
		var tag:* = interp.arg(b, 0);
		var oldTags:Array = s.tags;
		for (var ticker:int = 0; ticker < oldTags.length; ticker++)
			if (oldTags[ticker] == tag){
				s.tags.splice(ticker, 1);
				ticker--;
			}
		ticker++;
	}
	
	public function countTags(b:Block):Number {
		var s:ScratchSprite = interp.targetSprite();
		return s.tags.length;
	}
	
	public function getTagNumber(b:Block):* {
		var s:ScratchSprite = interp.targetSprite();
		var num:* = interp.arg(b, 0);
		var val:* = s.tags[num-1];
		if (!val) return void;
		return val;
	}
	
	public function hasTag(b:Block):Boolean {
		var tag:* = interp.arg(b, 0);
		var s:ScratchSprite = interp.targetSprite();
		for (var ticker:int = 0; ticker < s.tags.length; ticker++)
			if (s.tags[ticker] == tag){
				return true;
			}
		return false;
	}
	public function cloneHasTag(b:Block):Boolean {
		
		
		var id:* = interp.arg(b, 1);
		var tag:* = interp.arg(b, 2);
		
		var str:String = '';
		if ('_myself_' == String(interp.arg(b, 0))) {
			str = interp.activeThread.target.objName;	
		} else {
			str = String(interp.arg(b, 0));
		}
		var hits:Array = app.stagePane.spritesAndClonesNamed(str);
		for each (var s:ScratchSprite in hits)
		if(s.cloneID == id) {
			for (var ticker:int = 0; ticker < s.tags.length; ticker++)
				if (s.tags[ticker] == tag){
					return true;
				}
		}
		return false;
	}
	public function getTagNumberOfClone(b:Block):* {
		var id:* = interp.arg(b, 2);
		var num:* = interp.arg(b, 0);
		
		var str:String = '';
		if ('_myself_' == String(interp.arg(b, 1))) {
			str = interp.activeThread.target.objName;	
		} else {
			str = String(interp.arg(b, 1));
		}
		var hits:Array = app.stagePane.spritesAndClonesNamed(str);
		for each (var s:ScratchSprite in hits)
		if(s.cloneID == id) {
			var val:* = s.tags[num-1];
			if (!val) return void;
			return val;
		}
		return void;
	}

	private function countSpritesNamed(b:Block):Number {
		var nm:String = interp.arg(b, 0);
		return app.stagePane.countSpritesAndClonesNamed(nm);
	}
	
	private function thisName(b:Block):String {
		var objName:String = interp.arg(b, 0);
		var s:ScratchSprite = app.stagePane.spriteNamed(objName);
		if ('_myself_' == objName) s = interp.activeThread.target;
		if (!s) return "";
		return s.objName;
	}
	private function setName(b:Block):void {
		var newName:String = interp.arg(b, 0);
		var s:ScratchSprite = interp.activeThread.target;
		if (s == null) return;
		s.objName = newName;
	}
	
	private function printTxt(b:Block):void {
		var s:ScratchObj = interp.targetObj();
		var nm:String = String(interp.arg(b, 0));
		var val:String = '';
		var num:int = -1;
		var i:int = 0;
		for (i = 0; i < s.variables.length; i++)
			if(s.variables[i].name == nm) num = i;
		if (num == -1){
			s = app.stagePane;
			for (i = 0; i < s.variables.length; i++)
				if(s.variables[i].name == nm) num = i;
		}
		if (num == -1) return;
		val = s.variables[num].value;
		/*
		var textF:TextFormat = new TextFormat();
		textF.leftMargin = 0;         // the left margin of the paragraph, in pixels
		textF.font = "Helvetica";          // Defines the font used
		textF.color = '0x'+s.variables[num].col;        // Color
		textF.size = s.variables[num].fontsize;               // Text size (in pixels)
		*/
		
		//s.variables[num].txt.text = val;
		//s.variables[num].txt.setTextFormat(textF);
		
		s.variables[num].txt.backgroundColor = '0x'+s.variables[num].background;
		s.variables[num].txt.borderColor = '0x'+s.variables[num].border;
		
		var style:StyleSheet = new StyleSheet();
		var styleObj:Object = new Object();
		styleObj.fontSize = s.variables[num].fontsize;
		styleObj.color = '#'+s.variables[num].col;
		styleObj.fontFamily = '"Champagne & Limousines Regular", helvetica, arial, sans-serif';
		styleObj.textAlign = s.variables[num].alignment;
		style.setStyle('.'+s.variables[num].name,styleObj);
		s.variables[num].txt.styleSheet = style;
		s.variables[num].txt.htmlText = '<span class="'+s.variables[num].name+'">'+val+'</span>';
		
		/*
		
		// store CSS styles in a String variable
		//var css_st:String = ".bv{color:#0808fe; font-family:Arial; font-size:16px; font-weight:bold;} .adf{color:#ed0708; font-family:Verdana; font-size:13px; font-style:italic}";
		//var css_st:String = "#"+nm+"{color: #"+s.variables[num].col.toUpperCase()+'; }  ';
		
		
		// Defines the instance for the "StyleSheet" object
		var styles:StyleSheet = new StyleSheet();
		
		// Applies the "parseCSS" method to the variable with the CSS styles
		styles.parseCSS(css_st);
		
		// uses the "styleSheet" property to attach the CSS styles to the "txt" instance
		s.variables[num].txt.styleSheet = styles;
		
		// Adds HTML formated text
		s.variables[num].txt.htmlText = '<span id="'+nm+'">'+val+'</span>';
		*/
		
		// add the text in the Flash presentation
		app.stagePane.addChild(s.variables[num].txt);
		
	}
	
	private function showTxt(b:Block):void {
		var s:ScratchObj = interp.targetObj();
		var nm:String = String(interp.arg(b, 0));
		var val:String = '';
		var num:int = -1;
		var i:int = 0;
		for (i = 0; i < s.variables.length; i++)
			if(s.variables[i].name == nm) num = i;
		if (num == -1){
			s = app.stagePane;
			for (i = 0; i < s.variables.length; i++)
				if(s.variables[i].name == nm) num = i;
		}
		if (num == -1) return;
		app.stagePane.addChild(s.variables[num].txt);
	}
	
	private function hideTxt(b:Block):void {
		var s:ScratchObj = interp.targetObj();
		var nm:String = String(interp.arg(b, 0));
		var val:String = '';
		var num:int = -1;
		var i:int = 0;
		for (i = 0; i < s.variables.length; i++)
			if(s.variables[i].name == nm) num = i;
		if (num == -1){
			s = app.stagePane;
			for (i = 0; i < s.variables.length; i++)
				if(s.variables[i].name == nm) num = i;
		}
		if (num == -1) return;
		app.stagePane.addChild(s.variables[num].txt);
		app.stagePane.removeChild(s.variables[num].txt);
	}
	
	static private var stageRect:Rectangle = new Rectangle(0, 0, 480, 360);
	private function touchingClone(b:Block):Boolean {
		var s:ScratchSprite = interp.targetSprite();
		if (s == null) return false;
		var arg:* = interp.arg(b, 0);
		if ('_myself_' == arg) arg = s.objName;
		var num:* = interp.arg(b, 1);
		if ('_edge_' == arg) {
			if(stageRect.containsRect(s.getBounds(s.parent))) return false;
			
			var r:Rectangle = s.bounds();
			return  (r.left < 0) || (r.right > ScratchObj.STAGEW) ||
				(r.top < 0) || (r.bottom > ScratchObj.STAGEH);
		}
		if ('_mouse_' == arg) {
			return mouseTouches(s);
		}
		if (!s.visible) return false;
		
		var sBM:BitmapData = s.bitmap(true);
		for each (var s2:ScratchSprite in app.stagePane.spritesAndClonesNamed(arg))
		if (s2.visible && sBM.hitTest(s.bounds().topLeft, 1, s2.bitmap(true), s2.bounds().topLeft, 1) && s2.cloneID == num)
			return true;
		
		return false;
	}
	
	public function mouseTouches(s:ScratchSprite):Boolean {
		// True if the mouse touches the given sprite. This test is independent
		// of whether the sprite is hidden or 100% ghosted.
		// Note: p and r are in the coordinate system of the sprite's parent (i.e. the ScratchStage).
		if (!s.parent) return false;
		if(!s.getBounds(s).contains(s.mouseX, s.mouseY)) return false;
		var r:Rectangle = s.bounds();
		if (!r.contains(s.parent.mouseX, s.parent.mouseY)) return false;
		return s.bitmap().hitTest(r.topLeft, 1, new Point(s.parent.mouseX, s.parent.mouseY));
	}

	
	//=========================
	
	private function mouseOrSpritePosition(arg:String):Point {
		if (arg == '_mouse_') {
			var w:ScratchStage = app.stagePane;
			return new Point(w.scratchMouseX(), w.scratchMouseY());
		} else {
			var s:ScratchSprite = app.stagePane.spriteNamed(arg);
			if (s == null) return null;
			return new Point(s.scratchX, s.scratchY);
		}
		return null;
	}

	private function layer(b:Block):Number {
		var s:ScratchSprite = interp.targetSprite();
		if ((s == null) || (s.parent == null)) return 0;
		return s.parent.getChildIndex(s);
	}
	
	private function dPoints(b:Block):Number {
		var x1:Number = interp.numarg(b, 0);
		var y1:Number = interp.numarg(b, 1);
		var x2:Number = interp.numarg(b, 2);
		var y2:Number = interp.numarg(b, 3);
		//if ((x1 == null || y1 == null  || x2 == null || y2 == null)) return 0;
		var dx:Number = x2 - x1;
		var dy:Number = y2 - y1;
		return Math.sqrt((dx * dx) + (dy * dy));
	}

	private function d(b:Block):Number {
		var p1:Point = mouseOrSpritePosition(interp.arg(b, 0));
		var p2:Point = mouseOrSpritePosition(interp.arg(b, 1));
		if ((p1 == null || p1 == p2) || (p2 == null)) return 0;
		var dx:Number = p2.x - p1.x;
		var dy:Number = p2.y - p1.y;
		return Math.sqrt((dx * dx) + (dy * dy));
	}

	
	private static const emptyDict:Dictionary = new Dictionary();
	private static var lcDict:Dictionary = new Dictionary();
	public static function compare(a1:*, a2:*):int {
		// This is static so it can be used by the list "contains" primitive.
		var n1:Number = Interpreter.asNumber(a1);
		var n2:Number = Interpreter.asNumber(a2);
		// X != X is faster than isNaN()
		if (n1 != n1 || n2 != n2) {
			// Suffix the strings to avoid properties and methods of the Dictionary class (constructor, hasOwnProperty, etc)
			if (a1 is String && emptyDict[a1]) a1 += '_';
			if (a2 is String && emptyDict[a2]) a2 += '_';

			// at least one argument can't be converted to a number: compare as strings
			var s1:String = lcDict[a1];
			if(!s1) s1 = lcDict[a1] = String(a1).toLowerCase();
			var s2:String = lcDict[a2];
			if(!s2) s2 = lcDict[a2] = String(a2).toLowerCase();
			return s1.localeCompare(s2);
		} else {
			// compare as numbers
			if (n1 < n2) return -1;
			if (n1 == n2) return 0;
			if (n1 > n2) return 1;
		}
		return 1;
	}

	private function primCreateCloneOf(b:Block):void {
		var objName:String = interp.arg(b, 0);
		var proto:ScratchSprite = app.stagePane.spriteNamed(objName);
		if ('_myself_' == objName) proto = interp.activeThread.target;
		if (!proto) return;
		if (app.runtime.cloneCount > MaxCloneCount) return;
		var clone:ScratchSprite = new ScratchSprite();
		if (proto.parent == app.stagePane)
			app.stagePane.addChildAt(clone, app.stagePane.getChildIndex(proto));
		else
			app.stagePane.addChild(clone);

		clone.initFrom(proto, true);
		clone.objName = proto.objName;
		clone.isClone = true;
		for each (var stack:Block in clone.scripts) {
			if (stack.op == "whenCloned") {
				interp.startThreadForClone(stack, clone);
			}
		}
		app.runtime.cloneCount++;
	}

	private function primDeleteClone(b:Block):void {
		var clone:ScratchSprite = interp.targetSprite();
		if ((clone == null) || (!clone.isClone) || (clone.parent == null)) return;
		if (clone.bubble && clone.bubble.parent) {
			clone.bubble.parent.removeChild(clone.bubble);
			clone.bubble = null; // prevent potential exception inside hideAskBubble (via clearAskPrompts in stopThreadsFor below)
		}
		clone.parent.removeChild(clone);
		app.interp.stopThreadsFor(clone);
		app.runtime.cloneCount--;
	}

	
}}
