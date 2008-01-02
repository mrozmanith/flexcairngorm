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
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.adobe.cairngorm.control.CairngormEventDispatcher;
	import com.universalmind.cairngorm.events.*;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	
  /**
    * A base class used by developers to (a) allow a single command class to manage multiple events, 
    * (b) provide easy notifications to callers, (c) allows commands to dispatch business events,
    * and (d) allows data to be easily cached for calls to delegates or remote services. 
    * 
    * Using the Callbacks class, ANY caller can serve as an Responder without implementing 
    * the IResponder interface(s). Using the UMEvent class, any such event recieved at the 
    * Command instance can contain optional information that will be used later for caller notifications.
    *
    * @example This example demonstrates how the Command class can be subclass and used properly.
    * 
    * <listing version="3.0">
    *    public class LoginCommand extends Command {
    * 
    *       override public function execute(event:CairngormEvent):void {
    *           // always call the super.execute() method which allows the 
    *           // callBack information to be cached.
    * 
    *           super.execute(event);
    * 
    *           switch(event.type) {
    *                case LoginUserEvent.EVENT_ID  :  doLogin(event as LoginUserEvent);  break;
    *                case LogoutUserEvent.EVENT_ID :  doLogout(event as LogoutUserEvent); break;
    *           }
    *       }
    * 
    *       private function doLogin(event:LoginUserEvent)  :void {  
    *             var handlers : Callbacks     = new Callbacks(onResults_doLogin,onFault);
    *             var delegate : LoginDelegate = new LoginDelegate(handlers);
    * 
    * 			delegate.login(event.userID,event.password);
    * 	  }
    *       private function doLogout(event:LogoutUserEvent):void { ; }
    * 
    *       // ********************************************************************
    *       // DataService Result Handlers
    *       // ********************************************************************
    * 
    *       private function onResults_doLogin(event:*):void {
    *             __model.user = (event.result as UserVO);
    *       }
    * 
    *       private var __model : ModelLocator = ModelLocator.getInstance();
    *    }
    * </listing>
    * 
    * @see com.universalmind.cairngorm.events.Callbacks
    * @see com.universalmind.cairngorm.events.UMEvent
    */
	public class Command implements ICommand, IResponder
	{

	    /** 
	      * This function allows the incoming event to "cache" optional caller notification details.
	      * Note: this method is overridden by the subclass; and should always be called by the subclass.
	      * 
	      * @param event The event that was dispatched by a caller and recieved by an instance of the command subclass.
	      */ 
		public function execute(event:CairngormEvent) : void
		{	
			cacheCaller(event as UMEvent);
		}
	
	  /**
	    * This method allows commands to dispatch business events. This functionality allows commands to 
	    * to decoupled and provides better cohesion for inter-command activity.
	    * 
	    * @event This is a new business event that should be dispatched; and may be handled by the same class
	    * or by another completely separate command subclass instance.
	    * 
	    * @see com.universalmind.cairngorm.FrontController
	    */ 
		public function dispatchEvent(event:CairngormEvent):void {
			// Assumes that the "controller" has registered this event with a command class
			CairngormEventDispatcher.getInstance().dispatchEvent(event);
		}
		
		// ----------------------------------------------------------------------------
		// Callback methods to the original dispatcher of the event-command...
		// (if any)	
		// ----------------------------------------------------------------------------
	  
  	  /** 
  	    * This method allows callers (if originally packaged with the incoming event) to be receive a notification of response.
  	    * 
  	    * <p>
  	    * Conventional Cairngorm MVC solutions use the ModelLocator as a global repository and views {bind} to variables
  	    * exposed within the ModelLocator instance. Often, as enterprise needs scale the complexity of the applicaiton,
  	    * view instances need proprietary data that should not be shared nor contained within the ModelLocator. Direct "caller notification"
  	    * from command instances allow commands to deliver data [aka "notify"] to views or callers. The Callbacks class allows the
  	    * command to ignore any coupling issues regarding datatypes of the caller.
  	    * </p>
  	    *  
  	    * @results This is any data type that should be provided to the caller. If the type is a faultEvent, then the caller's faultHandler is invoked.
  	    * All other data types (including scalar values) are delivered to the caller by invoking its resultHandler.
  	    * 
  	    * @see com.universalmind.cairngorm.events.Callbacks
  	    */ 
  		public function notifyCaller(results:* = null):void {
  			// Default result handler simply forwards 
  			// the event to the view handler... if available
  			// Note: the results == FaultEvent or ANY data type
  			//       this allows data to be directly delivered to the caller without
  			//       a ResultEvent wrapper
  			if (__viewHandlers != null) {
  				if (results is FaultEvent) this.fault(results);
  				else 					             this.result(results);
  			}
  		}
  		
  	  /** 
  	    * This method caches optional callers response handlers so callers can later receive a notification of response.
  	    * 
  	    * <p>
  	    * Normally this method is called by Command subclasses calling super.execute(). 
  	    * However, manual invocation of this method is also supported.
  	    * </p>
  	    *  
  	    * @event If the event is an UMEvent subclass, then IResponder handlers [optional] are cached for future use.
  	    * 
  	    * @see com.universalmind.cairngorm.events.Callbacks
  	    * @see com.universalmind.cairngorm.events.UMEvent
  	    */ 
  		protected function cacheCaller(event:Event):void {
  			// Cache the view result/fault handlers IF any...
  			if (event && (event is UMEvent)) {
  				__viewHandlers = (event as UMEvent).callbacks as IResponder;			
  			}
  		}

		// ----------------------------------------------------------------------------
		// DataService Event Handlers	
		// ----------------------------------------------------------------------------

      /**
        * Method required to allow Commands to support the "result" response for the IResponder interfaces.
        * Support of the IResponder interface allows command instances to use either Callbacks as proxy Responders or the command instance itself to 
        * serve as the responder to a delegate or remote dataservice call.
        * 
        * @info The object that is returned as the Result of the [usually] asychronous call.
        * 
        * @see mx.rpc.IResponder
        */ 	
  		public function result(info:Object):void {
  			if (__viewHandlers != null) {
  				if(__viewHandlers.result  != null)	__viewHandlers.result(info);
  			}
  		}
  	
      /**
        * Method required to allow Commands to support the "fault" response for the IResponder interfaces.
        * Support of the IResponder interface allows command instances to use either Callbacks as proxy Responders or the command instance itself to 
        * serve as the responder to a delegate or remote dataservice call.
        * 
        * @info The object that is returned as the Result of the [usually] asychronous call.
        * 
        * @see mx.rpc.IResponder
        */ 	
  		public function fault( info:Object ) : void {
  			// Default fault handler simply forwards 
  			// the event to the view handler... if available
  			if (__viewHandlers && (__viewHandlers.fault != null)) __viewHandlers.fault(info);
  			
  			var faultEv : FaultEvent = info as FaultEvent;
  			if (faultEv != null) {
  			  // If "info" is a FaultEvent, the send to the FrontController
  			  // Dispatch the event with the original fault information
  			  dispatchEvent(new AnnounceFaultEvent(faultEv.fault));
  			}
  		}
  	
  	  /**
  	    * Utility method to allow command subclasses to use a shared method for "fault" respones.
  	    */ 
	    public function onFault(info:Object):void { fault(info); }

  		// *****************************************************
		//  Command-Delegate Token Methods
		// ****************************************************
		
		/**
		 * Method to allow commands to gather information for caching during asynchronous calls.
		 * After the asynchronous RDS is dispatched, this preserves all information for access by 
		 * the result/fault handlers... if needed.
		 * 
		 * @details This is an associative array [aka Object] that contains key/value pairs of information.
		 */
		protected function buildTokenOptions(details:*):TokenOptions {
			return (new TokenOptions(details));		
		}
		
		/**
		  * This utility method provides an easy lookup of an token-cached value; to be retrieved by key/name
		  * 
		  * @event This is the asynchronous response event (FaultEvent or ResultEvent) that may have TokenOptions cached.
		  * @key   This is the key/name used to lookup the value cached in the TokeOptions array.
		  * 
		  */
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
		
		/** 
			* By default Commands will handle the dataservice result/fault events themselves... views have not registered
			* This variable allows the caller's responders to be invoked.
			* 
			* @private
			*/ 
		private var __viewHandlers  : IResponder = null;
	}
}	

/**
  * This is a class internal to the commands package that allows command subclasses to easily
  * use the async token to cache information between aysnchronous invocations and their responses.
  */
dynamic class TokenOptions {
	
	/**
	  * Constructor to easily transform generic token objects to a stronger class type
	  */
	public function TokenOptions(options:Object) {
		for (var key:String in options) {
			this[key] = options[key];
		}
	}
}