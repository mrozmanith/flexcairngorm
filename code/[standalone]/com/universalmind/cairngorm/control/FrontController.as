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
package com.universalmind.cairngorm.control
{
   import flash.utils.Dictionary;
   import mx.core.Application;
   
   import com.universalmind.cairngorm.commands.Command;
   import com.universalmind.cairngorm.control.CairngormEventDispatcher;
   import com.universalmind.cairngorm.events.UMEvent;
   

   public class FrontController extends BaseController
   {   	
   	  public function addSubController(controllerRef : Class):void {
   	  	if (!isControllerRegistered(controllerRef)) {
   	  		// 1) let's create instance
   	  		// 2) listen for all events for that module
   	  		// 3) direct handler for those events to that module controller

   	  		// Cache the moduile instance for later reuse
   	  		var module : * = new controllerRef();	   	  		
   	  		if (checkModuleType(module) == true) {
	   	  		
	   	  		__subControllers[controllerRef] = module;
	   	  		
				// Register events and handlers   	  		
	   	  		var moduleEvents : Array = module.registeredEvents;   	  		
	   	  		for each (var eventID : String in moduleEvents) {
					listenForEvent(eventID,module.eventHandler);   	  			
	   	  		}   	  		
	   	  	}
   	  	}
   	  }
   	  

      // ***********************************************************
      // Private methods
      // ***********************************************************
	  private function checkModuleType(subController:*):Boolean {
 		if (subController is ModuleController) return false;
 		else {
 			var msg : String = "SubControllers must be subclasses of ModuleController.";
 			throw new Error( msg );	
 		}
	  }
      
   	  private function isControllerRegistered(controllerRef : Class):Boolean {
   	  	return (__subControllers[controllerRef] != null);
   	  }
   	  
	  private var __subControllers 	: Dictionary = new Dictionary();
   }   
}
