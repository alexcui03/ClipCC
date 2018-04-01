/* 此as为额外编写，具体源码内容由西南交通大学创客空间 & 魅客科技 
模块请谨慎改动谢谢

*/ 

// ArduinoPrims.as // sf.Deng , April 11th,2015 
package primitives { 
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.Dictionary;
	import blocks.Block;
	import interpreter.*;
	import scratch.*;
	
	public function primDigitalIo(b:Block):void {
		// 添加您需要的功能
		
	}
	public class ArduinoPrims { 
		
		private var app:Scratch;
		private var interp:Interpreter; 
		
		
		//public function ArduinoPrims(app:Scratch, interpreter:Interpreter) {
			//this.app = app;   
			//this.interp = interpreter;
			
			
			

		}} 
	

	
	
		} 

	


	public function addPrimsTo(primTable:Dictionary):void {
		primTable['digitalIo:']   = primDigitalIo; 
		
}
	