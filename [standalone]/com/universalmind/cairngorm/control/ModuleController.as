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
   

   public class ModuleController extends BaseController
   {

	  public function get registeredEvents():Array {
	  	var results : Array = new Array();
	  	
	  	for each (var eventID:String in __commands) {
	  		results.push(eventID);	
	  	}
	  	
	  	return results;
	  } 
	  
	  public function get eventHandler():Function {
	  	return this.onExecuteCommand;
	  } 	   	   	  
   }   
}
