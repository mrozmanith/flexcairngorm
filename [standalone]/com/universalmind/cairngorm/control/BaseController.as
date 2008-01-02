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
   import com.universalmind.cairngorm.commands.Command;
   import com.universalmind.cairngorm.events.UMEvent;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   import mx.core.UIComponent;
   
   import mx.core.mx_internal;
   
   public class BaseController
   {
   	
      public function addCommand( eventType : String, commandRef : Class ) : void
      {
         if( __commands[ eventType ] != null )
            throw new Error( "UM Command already registered for " + eventType );
         
         __commands[ eventType ] = commandRef;

		listenForEvent(eventType, this.onExecuteCommand);
      }
      
      
      // ***********************************************************
      // Private Event Handler
      // ***********************************************************
      
      protected function onExecuteCommand( event : UMEvent ) : void
      {
         var commandToInitialise : Class = getCommand( event.type );
         var commandToExecute : Command = new commandToInitialise();

         commandToExecute.execute( event );
      }

      // ***********************************************************
      // Private methods
      // ***********************************************************
      
      protected function getCommand( commandName : String ) : Class
      {
         var command : Class = __commands[ commandName ];
         if ( command == null )
            throw new Error( "UM Command not found for " + commandName );
            
         return command;
      }      


      protected function listenForEvent(eventType:String, handler:Function):void {
      	
         CairngormEventDispatcher.getInstance().addEventListener(eventType, handler);

		 /* 
		  * The code below is no longer needed because of the eventHook used instead
	      *   
	      *   Application.application.addEventListener( eventType, handler);
	      *  @Todo - add listener to popupmanager 
		  */                  
      
      }
   	  
      protected var __commands 		: Dictionary = new Dictionary();


		/**
		 * Add a hook into dispatchEvent high up in the inheritance chain.  Any
		 * subclass of UIComponent is now "UMEvent-aware" and no longer
		 * needs separate event dispatching code for Cairngorm events.
		 * The event is still dispatched normally but ALSO gets sent to the CairngormEventDispatcher
		 */
		private static function hookDispatchEvent():Boolean
		{
		    use namespace mx_internal;
		 	mx_internal::dispatchEventHook = eventHook;

		 	return true;
		}
		
		/**
		 * The event hook itself.  Any time we encounter a UMEvent, we
		 * dispatch it directly through the centralized UMEventDispatcher.  This
		 * abstraction prevents UI subclasses from having to know how to deal with
		 * UM events.
		 */
		private static function eventHook( event:Event, uic:UIComponent ):void
		{
		 	if ( event is UMEvent )
		 	{
		  		___dispatcher.dispatchEvent( event as UMEvent );
		  	}
		}

  	  /** Create the dispatch event hook when the Application is created. */
	  private static var __dispatchEventHooked : Boolean           = hookDispatchEvent();
	  private static var ___dispatcher         : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
   }   

}
