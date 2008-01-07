/*

Copyright (c) 2007. Universal Mind, Inc. 
All rights reserved.
 
This source code is the property of Universal Mind, Inc. ("Universal Mind")
and is licensed, not sold or assigned, to the Universal Mind customer that
obtains this code from Universal Mind. 

  * This code may not be disclosed to any party without the prior written 
    consent of Universal Mind.
  * This code and may only be used as permitted in the agreement between 
    Universal Mind and its customer.

This code contains the valuable trade secrets of Universal Mind, the
development of which required the expenditure of considerable time and money.
Unless otherwise expressly set forth in the agreement between Universal
Mind and its customer, this code is provided "as-is" without warranty of
any kind.

Author: Thomas Burleson, Principal Architect
        ThomasB@UniversalMind.com
@ignore
*/
package com.universalmind.cairngorm.commands
{
	import com.universalmind.cairngorm.control.CairngormEventDispatcher;
	import com.universalmind.cairngorm.events.*;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	
	public class Command implements ICommand, IResponder
	{
		public function Command() {
			// By default Commands will handle the dataservice result/fault events
			// themselves... views have not registered
			__viewHandlers = null;
		}
		
		public function execute(event:Event) : void
		{	
			cacheCaller(event as UMEvent);
		}
	
	
		public function dispatchEvent(event:UMEvent):void {
			// Assumes that the "controller" has registered this event with a command class
			CairngormEventDispatcher.getInstance().dispatchEvent(event);
		}
		// ----------------------------------------------------------------------------
		// Callback methods to the original dispatcher of the event-command...
		// (if any)	
		// ----------------------------------------------------------------------------
	
		public function cacheCaller(event:Event):void {
			// Cache the view result/fault handlers IF any...
			if ((event != null) && (event is UMEvent)) {
				__viewHandlers = (event as UMEvent).callbacks as IResponder;			
			}
		}

		public function notifyCaller(results:* = null):void {
			// Default result handler simply forwards 
			// the event to the view handler... if available
			
			if (__viewHandlers != null) {
				if (results is FaultEvent) this.fault(results);
				else 					   this.result(results);
			}
		}
		
		// ----------------------------------------------------------------------------
		// DataService Event Handlers	
		// ----------------------------------------------------------------------------
	
		public function result(info:Object):void {
			if (__viewHandlers != null) {
				if(__viewHandlers.result  != null)	__viewHandlers.result(info);
			}
		}
	
	    public function onFault(info:Object):void { fault(info); }
		public function fault( info:Object ) : void {
			// Default fault handler simply forwards 
			// the event to the view handler... if available
			if (__viewHandlers != null) {
				if(__viewHandlers.fault  != null) {
					__viewHandlers.fault(info);
				}	
				else {
					var faultEv : FaultEvent = info as FaultEvent;
					if (faultEv != null) {
						Alert.show(faultEv.fault.faultDetail);
					}
				}
			}
		}
	
		// *****************************************************
		//  Command-Delegate Token Methods
		// ****************************************************
		
		/**
		 * After the asynchronous RDS is dispatched, this preserves all 
		 * information for access by the result/fault handlers... if needed.
		 */
		protected function buildTokenOptions(details:*):TokenOptions {
			return (new TokenOptions(details));		
		}
		protected function getTokenOption(event:Event, key:String):* {
			var options : TokenOptions = (event["token"] != null) ? event["token"]["options"] : null; 
			return options ? options[key] : null;
		}

		// ----------------------------------------------------------------------------
		// Private Methods
		// ----------------------------------------------------------------------------
	
		// ----------------------------------------------------------------------------
		// Private Attributes
		// ----------------------------------------------------------------------------
		private var __viewHandlers  : IResponder = null;
	}
}	

dynamic class TokenOptions {
	public function TokenOptions(options:Object) {
		for (var key:String in options) {
			this[key] = options[key];
		}
	}
}