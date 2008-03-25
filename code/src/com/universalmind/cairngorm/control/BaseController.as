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
        Darron Schall,   Principal Architect
        ThomasB@UniversalMind.com
@ignore
*/
package com.universalmind.cairngorm.control
{
   import com.adobe.cairngorm.control.CairngormEvent;
   import com.adobe.cairngorm.control.CairngormEventDispatcher;
   import com.adobe.cairngorm.commands.ICommand;
   
   import flash.events.Event;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   
   import mx.core.UIComponent;
   import mx.core.mx_internal;

   /**
     *
     * The traditional cairngorm FrontController requires events to be dispatched
     * to the CairngormEventDispatcher in order for the "event->command" mappings to 
     * trigger. This Class continues to support that mechanism [for direct triggering] but now
     * supports an improved mechanism for dispatching CairngormEvents from the UI layers.
     * 
     * <p> 
     * Alternate extensions have modified the FrontController to not only register
     * events with the CairngormEventDispatcher but also with the <mx:Application>.
     * This solution would allow events - via event bubbling - to reach the Cairngorm framework
     * and not require the use of CairngormEventDispatcher in view class. Opponents 
     * of this solution did not want their Cairngorm events to bubble thru the entire 
     * view hierarchy.
     * </p>
     * 
     * <p>
     * Recent changes have now leveraged a UIComponent event hook to not only dispatch
     * the event "up" the view hierarchy but to also directly trigger the Cairngorm 
     * event->command mapping (if any exists).
     * </p>
     */
   public class BaseController extends com.adobe.cairngorm.control.FrontController
   {

	      /**
	        * This function provides extra runtime type checking of Command class argument: commandRef 
	        * This argument must not be null and must support the ICommand interface.
	        * After these checks, the request is forwarded to the Adobe FrontController 
	        */
		  override public function addCommand( commandName : String, commandRef : Class, useWeakReference : Boolean = true ) : void {

			// Provide runtime checking to confirm the commandRef is non-null and implements ICommand 
			if (null == commandRef) throw new Error("The commandRef argument cannot be null");
			else {
				var classDescription:XML = describeType(commandRef) as XML;
				
				var clazzName         : String = getQualifiedClassName(ICommand);
				var implementsICommand:Boolean = (classDescription.factory.implementsInterface.(@type == clazzName).length() != 0);
				if (!implementsICommand) throw new Error("The commandRef argument '" + commandRef + "' must implement the ICommand interface");
			  }

			super.addCommand(commandName, commandRef, useWeakReference);
		  }

	      /**
	        * This function allows FrontController subclasses to easily register new 
	        * event-command mappings.
	        * 
	        * @eventType This is the event.type or ID of events that we will listen for.
	        * @handler   This is the event handler; usually this is the FrontController::execute()
	        */
	      protected function listenForEvent(eventType:String, handler:Function):void {
	      	 
	      	 // FIXME: need to cache the eventType and throw console traces if already registered
	      	 
	         CairngormEventDispatcher.getInstance().addEventListener(eventType, handler);
    			 /* 
    			  * The code below is no longer needed because of the eventHook used instead
    		      *   
    		      *   Application.application.addEventListener( eventType, handler);
    		      *  @Todo - add listener to popupmanager 
    			  */                  
	      }

    		/**
    		 * Add a hook into dispatchEvent high up in the inheritance chain.  Any
    		 * subclass of UIComponent is now "UMEvent-aware" and no longer
    		 * needs separate event dispatching code for Cairngorm events.
    		 * The event is still dispatched normally but ALSO gets sent to the CairngormEventDispatcher
    		 */
    		[Deprecated("CairngormEvents should now self dispatch. Event hooks or event bubbling should not be used!")]
    		private static function hookDispatchEvent():Boolean
    		{
    		    use namespace mx_internal;
      		 	UIComponent.mx_internal::dispatchEventHook = eventHook;
      
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
    		 	if ( event is CairngormEvent)
    		 	{
    		  		___dispatcher.dispatchEvent( event as CairngormEvent );
    		  	}
    		}
    
      	  /** 
      	  * The dispatch event hook when the Application is created. 
      	  * Note: This feature has been disabled! 
      	  **/
    	  private static var __dispatchEventHooked : Boolean                  = false; // hookDispatchEvent();
    	  
    	  /** Maintain a reference to prevent garbage collection. Also shortcut alias */
    	  private static var ___dispatcher         : CairngormEventDispatcher = CairngormEventDispatcher.getInstance();
   }   

}
