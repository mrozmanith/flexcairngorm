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
package com.universalmind.cairngorm.business
{
	/*
		Delegate representing request to create or update contacts on the server.
	
		Notes:
		Services.mxml has each remoteObject defined with 
		result="event.call.resultHandler(event)" fault="event.call.faultHandler(event)"
		
		so when the remoteObject returns, the above anonymous event handler defers the processing
		to the "event.call" instance which is ALSO "dataCall";
		
		Below, on lines 33-34, we allow the delegate or the command/responder to "handle" the event.			
		
	*/
	import com.universalmind.cairngorm.events.Callbacks;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.http.HTTPService;
	import mx.rpc.soap.WebService;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;	
		
	public class Delegate {
		
		public static function prepareResponder(token:AsyncToken,resultHandler:Function,faultHandler:Function):void {
			if (token != null) {
				token.addResponder(new mx.rpc.Responder(resultHandler,faultHandler));
			}
		}
		
		public function Delegate(commandHandlers:IResponder = null,serviceName:String="") {	
			// Usually the responder is the calling command instance... but not always
			__responder   = commandHandlers;
			__serviceName = serviceName;	
							  
			// Set up response handlers DIRECTLY to the command unless overriden later 
			// with another call to prepareHandlers
			try {
				if (serviceName != "" ) __service     = ServiceLocator.getInstance().getService(serviceName);
			} catch(e:Error) {
				__service     = ServiceLocator.getInstance().getHTTPService(serviceName);
			}
		}
		
		public function prepareHandlersWithOptions( token:AsyncToken=null ,options:*=null, handlers:Callbacks = null):void { 
			if (token != null) token.options = options;
			prepareHandlers(token, handlers);
		}
		
		public function prepareHandlers(token:AsyncToken=null,delegateHandlers:Callbacks =null,service:*=null):void {
			// Normally we have 1 call per service so the default handler implementation works
			// but if we have multiple call options, how do we assign different handlers to
			// different calls? .... alternateHandlers...
			if (token.message == null) {
				var msg       : String = "The Service for Delegate '{0}' has not been initialized properly.";
				var classInfo : Object = ObjectUtil.getClassInfo(this); 
				throw new Error(StringUtil.substitute(msg,[String(classInfo['name'])]));
			}
			
			token.addResponder(new mx.rpc.Responder(getResultHandler(delegateHandlers), getFaultHandler(delegateHandlers)));
		}
	
		// *********************** **********************************
		// Stub Handlers for IResponder
		// *********************** ********************************

		public function onResult(event:*):void {
			if (getResponder() != null) getResponder().result(event);
			else 						throwError("onResult");
		}
	
		public function onFault(event:*=null):void {
			if (getResponder() != null) getResponder().fault(event);
			else 						throwError("onFault");
		}
		

		// *********************** **********************************
		// Private utility methods
		// *********************** ********************************

		private function getResultHandler(delegateHandlers:Callbacks =null):Function {
				// Did the Delegate subclass have specific methods that should handler the results 1st?
				// This 1st handler is where the factories could convert the incoming data...
			return makeMethodClosure("onResult", delegateHandlers );
		}
		
		private function getFaultHandler(delegateHandlers:Callbacks =null):Function {
				// Did the Delegate subclass have specific methods that should handler the results 1st?
				// This 1st handler is where the factories could convert the incoming data...
			return makeMethodClosure("onFault",delegateHandlers );
		}
		
		private function makeMethodClosure(method:String,scope:IResponder=null):Function {
	
			var results : Function = null;
			
			if (scope == null) scope = getResponder();
			switch(method) {
				case "onResult":	results = scope.result;
									break;
				case "onFault":		results = scope.fault;
									break;
			}
			
			return results;
		}
		
		// *********************** **********************************
		// Private Attributes
		// *********************** ********************************

		private function throwError(eventType:String):void {
			var msg : String = StringUtil.substitute("Delegate for {0} does not have any eventHandlers for the {1} event.",
													  [__serviceName,eventType]);
			throw (new Error(msg));													  
		}
	
		public function get service():Object {
			return __service;
		}
		
		public function getHTTPService(serviceName:String):HTTPService {
			return ServiceLocator.getInstance().getHTTPService(serviceName);
		}
		
		public function getWebService(serviceName:String):WebService {
			return ServiceLocator.getInstance().getWebService(serviceName);
		}
		
		public function getService(serviceName:String=""):Object {
			var results : Object = __service;
			
			if (serviceName != "") {
				try {
					if (serviceName != "" ) results     = ServiceLocator.getInstance().getService(serviceName);
				} catch(e:Error) {
					results     = ServiceLocator.getInstance().getWebService(serviceName);
				}
			}
			
			return results;
		}
		
		public function getResponder():IResponder {
			return __responder;
		}
		
	
		// *********************** **********************************
		// Private Attributes
		// *********************** ********************************

		private var __service  		: *;
		private var __serviceName 	: String; 
		private var __responder		: IResponder;
	}
}