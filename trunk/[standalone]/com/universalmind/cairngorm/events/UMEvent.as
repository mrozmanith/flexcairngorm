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
package com.universalmind.cairngorm.events
{
    import com.universalmind.cairngorm.control.CairngormEventDispatcher;
    
    import flash.events.Event;

   /**
    * The UMEvent class is used to differentiate Cairngorm events 
    * from events raised by the underlying Flex framework (or even the standard CairngormEvent)
    * It is mandatory to use UMEvent for dispatching to Commands. Commands
    * understand and "use" the optional "handlers" responder within the event 
    * 
    * <p>For more information on how event dispatching works in Cairngorm, 
    * please check with CairngormEventDispatcher.</p>
    *
    * <p>For more information on how event dispatching works uniquely with Commands, 
    * please check with Command.</p>
    *
    * <p>
    * Events are typically broadcast as the result of a user gesture occuring
    * in the application, such as a button click, a menu selection, a double
    * click, a drag and drop operation, etc.  
    * </p>
    *
    * @see com.universalmind.cairngorm.controller.CairngormEventDispatcher
    * @see com.universalmind.cairngorm.commands.Command
    */	
    public class UMEvent extends flash.events.Event implements IUMEvent 
    {
	      /**
	       * The data property can be used to hold information to be passed with the event
	       * in cases where the developer does not want to extend the UMEvent class.
	       * However, it is recommended that specific classes are created for each type
	       * of event to be dispatched.
	       */
	      	public var data 	 : *         = null;

	      /**
	       * The data property can be used to hold information to be passed with the event
	       * in cases where the developer does not want to extend the UMEvent class.
	       * However, it is recommended that specific classes are created for each type
	       * of event to be dispatched.
	       */
	   	  	public var callbacks : Callbacks = null;

	      /**
	       * Constructor, takes the event name (type), Responder proxy to allow caller to be notified,
	       * data object (defaults to null), and also defaults the standard Flex event properties bubbles and cancelable
	       * to true and false respectively.
	       * 
	       * @param eventType  This is the signature or type of event
	       * @param handlers   This is the "responder" proxy that allows notifications/callbacks to the original caller
	       * @param bubbles    This flag indicates if the event should "bubble". [default = true]
	       * @param cancelable This flag indicates if the event can be cancelled. [default = false]
	       * @parma data       This is the optional data object that can be packaged with the event without creating an event subclass
	       */
			public function UMEvent(	eventType 	: String 	= "com.universalmind.cairngorm.events.Event", 
										handlers 	: Callbacks = null, 
										bubbles	 	: Boolean	= true, 
										cancelable	: Boolean	= false,
										data		: *         = null) {
											
				super(eventType,bubbles,cancelable);
				
				this.callbacks = handlers;
				this.data      = data;
			}

			/**
			  * Per Adobe Flex recommendations all events should support a clone() operation for bubbling and dispatching purposes
			  * 
			  */ 			
			override public function clone():Event {
				return new UMEvent(type, null, bubbles, cancelable).copyFrom(this);
			}
			
			/**
			  * Utility method to allow quick initialization of an event based on current settings from another event. 
			  * Also used to implement the clone() method functionality
			  * 
			  * @param src The event from which current settings and references should be copied.
			  */
			public function copyFrom(src : Event):Event {					
				// Note: can change/specify the values of type,bubbles,etc...
				// during at construction only.
				
				// Note the callbacks is copied by REFERENCE 
				this.callbacks = (src as UMEvent).callbacks;
				this.data      = (src as UMEvent).data;
							
				return this;
			}
			
	 
		 /**
	       * <p><strong>Deprecated, Do not use! The default UMEvent bubbling and FrontController event hooks obviate this method.</strong></p>
	       * This method also completely distorts the event structures within Flex... no other events in Flex can dispatch themselves.
	       * Events are "announcements" with optional data packaged in the announcement. Events are passive. NOT active.
	       *  
	       * Dispatch this event via the Cairngorm event dispatcher.
	       */
	      override public function dispatch() : Boolean
	      {
	         return CairngormEventDispatcher.getInstance().dispatchEvent( this );
	      }    		

	}
}