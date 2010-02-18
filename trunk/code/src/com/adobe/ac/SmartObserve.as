package com.adobe.ac
{
	import mx.core.IMXMLObject;
	
	public class SmartObserve extends Observer implements IMXMLObject
	{
		public  var id : String = "";
		
		override public function get handler() : Function {   return _handler;  }
		public function set handler( value : Function ) : void {
			_handler = value;
			invoke();
		}
  
		override public function get source() : Object  {  return _source;    }
		public function set source( value : Object ) : void	{	
			_source = value; 
			invoke();
		}
		
		public function initialized(document:Object, id:String):void {
			this._initialized = true;
			this.id           = id;
			
			invoke();
		}
		
		private function invoke():void {
			if (_initialized && _handler && _source) {
				callHandler();
			}
		}
	
		private var _handler 	 : Function = null;
		private var _source 	 : Object   = null;
		private var _initialized : Boolean  = false;
 		
	}
}