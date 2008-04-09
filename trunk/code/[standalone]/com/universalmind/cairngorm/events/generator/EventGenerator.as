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
package com.universalmind.cairngorm.events.generator
{
   import com.universalmind.cairngorm.control.CairngormEventDispatcher;
   import com.universalmind.cairngorm.events.Callbacks;
   import com.universalmind.cairngorm.events.UMEvent;
   
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   import mx.core.UIComponent;
   import mx.utils.StringUtil;

	// *****************************************************
	// Events broadcast by the generator to outside listeners
	// *****************************************************
	
   [Event(name="fault", type="flash.events.Event")]
   [Event(name="result", type="flash.events.Event")]
   
   [DefaultProperty("events")]
   
   public class EventGenerator extends UIComponent implements IEventGenerator
   {      
       
      /*   
      		Actionscript and MXML example usages below:
      
      			// If any task/event fails, then abort the task processing entirely (e.g. trigger == "0")
	      	    var parallelEvents 		: Array 			= [LoadUserProfileEvent,LoadMetaDataEvent];
	      	    var parallelGen         : EventGenerator 	= new EventGenerator(parallelEvents,null,0,"parallel");
	      	    
	      	    // Now, manually add the parallel generator into the list for the consecutive generator...
	      	    var consecutiveTasks    : Array     		= [LoadBundleEvent, parallelGen, LoadUserPreferencesEvent];
	      	    
	      	    var handlers 			: CallBacks 		= new Callbacks(whenAppIsReady, notifyUserOfError);	      	    
	      		var cmd      			: EventGenerator 	= new EventGenerator(consecutiveTasks,handlers,0);
	      			cmd.dispatch();

				[!! full classpaths are not specified above... should specify]
			
			or use tag notations:
			      	
			  <generator:EventGenerator id="startUpEvents" 										xmlns:generator="com.universalmind.cairngorm.events.generator.*">
				      <generator:EventGenerator trigger="sequence" result="onUserLoaded(event);" >
		         		  <events:LoadResourcesEvent 			            					xmlns:events="com.clientXXX.appXXX.control.events.*" />
						  <events:GetLoggedInUserEvent 											xmlns:events="com.clientXXX.appXXX.control.events.login.*" />
			  			  <!-- events:LoadClassesOfBusinessEvent                      			xmlns:events="com.clientXXX.appXXX.control.events.questionnaire.*"/ -->
				      </generator:EventGenerator>
			  		  <generator:EventGenerator trigger="parallel">
			      			<events:LoadRolesForFeaturesEvent               				xmlns:events="com.clientXXX.appXXX.control.events.login.*" />
					  		<events:LoadAssociatedUsersEvent 	                    		xmlns:events="com.clientXXX.common.control.events.*" /> 
			  		  </generator:EventGenerator>  			
			  </generator:EventGenerator>
      
				[!! MXML tag notation is very convenient for consecutive tasks ONLY]			
      */
      
      public static const TRIGGER_SEQUENCE : String = "sequence";
      public static const TRIGGER_PARALLEL : String = "parallel";
      
      public var trigger	 	: String 	= TRIGGER_SEQUENCE;
      public var failCount		: int		= -1;        
        	
      // ****************************************************************
      // Public Methods
      // ****************************************************************
      
      public function EventGenerator( 	eventsToFire 	: Array     = null, 
                      									handlers 		  : Callbacks = null, 
                      									failCount		  : int       = -1,
                      									triggerType		: String    = TRIGGER_SEQUENCE) {

         buildCache(eventsToFire);
         
         
         this.failCount 	= failCount;
         this.trigger   	= triggerType;         
         
         __announcer 	    = handlers;
      }
             
      public function dispatch(handlers:Callbacks = null) : void       {      	
      	 __announcer = handlers;
      	 resetCache();	
      	 
         dispatchNext();
      }            
      
      public function set events(eventsToFire : Array) : void {
      	buildCache(eventsToFire);
      }
	      
      // ****************************************************************
      // Private Methods
      // ****************************************************************
      
      private function dispatchNext():void {
      	
      	while(hasNext() == true){
      	
      		var item : * = getNext();
			
		  	if (item is EventGenerator) {
		  		// may be sequence or parallel event generator
		  		item.dispatch(new Callbacks(onEventDone,onEventFail));
		  	} else {
		  		// So we must have an instance or Class of an UMEvent subclass
  				var inst : * = null;
			  	if (item is Class) inst = new item();
			  	else 	           inst = item;
			  	
			  	if ((inst is UMEvent) != true) {
			  		var msg : String = "EventGenerators can only dispatch UMEvent subclasses: {0} is an invalid class.";
			  		throw new Error(StringUtil.substitute(msg,[inst]));
			  	}
			  	
			  	// We expect the Class to be an UMEvent or subclass only
			  	// so handlers can be attached during construction
			  	var handlers : Callbacks = new Callbacks(onEventDone,onEventFail);
			  	(inst as UMEvent).callbacks = handlers;
			  	
			  	// Use the UMEventDispatcher to dispatch the actual events...
			  	// If using UMCairngorm MVC, this works great because registered commands will
			  	// get this events from the EventGenerator
			  	
			  	CairngormEventDispatcher.getInstance().dispatchEvent( inst );		  	
		  	}
		  	
		  	markAsDispatched(item);
		  	
		  	// Only break loop if firing a SINGLE event
		  	if (this.trigger == TRIGGER_SEQUENCE) break;
      	}
      }
      
      // *****************************************************
      // Event Handlers for responses to each dispatch action
      // *****************************************************
      
      private function onEventFail(response:*):void {
      	__doneCounter ++;
      	
		var announced : Boolean = announceFail(response);
      	if ((trigger == TRIGGER_SEQUENCE) && hasNext() && !announced)  {
      			dispatchNext();
      			return;
      	} 
      	
      	if ((__doneCounter >= __sequence.length) && !announced)  announceDone(response);
      }

      private function onEventDone(response:*):void {
      	__doneCounter ++;
      	
      	if ((trigger == TRIGGER_SEQUENCE) && hasNext()) 	{
      		dispatchNext();
      		return;
      	}

      	if (__doneCounter >= __sequence.length) announceDone(response);
	      		
      }
      
      
      
      
      private function announceDone(response:*=null):void {
  			// Announce event condition to any explicit or implicit (respectively) listeners
  			if (__announcer != null)__announcer.result(response);  				
  			dispatchEvent(new UMEvent("result",null,false,false,response));
  			
	      clearCache();		
      }
      
      private function announceFail(response:*=null): Boolean{
	    var failed : Boolean = false; 
	    
	    __numOfFails ++;
      	if ((failCount > -1) && (__numOfFails > failCount)) {
  				    // Announce event condition to any explicit or implicit (respectively) listeners
  	      		if (__announcer != null) __announcer.fault(response);					      		
  	      		else                     dispatchEvent(new UMEvent("fault",null,false,false,response));

  	      		clearCache();
  	      		failed = true;
  	     }  
  	     
  	     return failed;
      } 

	  // *****************************************
	  // Event Cache methods
	  // *****************************************

	  private function clearCache():void {
	  	for (var key:* in __events) {
	  		// clear value for each item...
	  		// since we constructed with weak references
	  		// this allows refactoring
	  		__events[key] = null;
	  	}
	  }
      private function buildCache(eventsToFire:Array):void {
      	clearCache();
      	
      	__sequence = eventsToFire;
      	for each (var item:* in eventsToFire) {     		
      		
      		// Notice how we attach behaviours/flags to object instances
      		// WITHOUT modifying the object
      		__events[item] = { hasBeenDispatched : false };
      	}
      }
      
      private function resetCache():void {
      	buildCache(__sequence);
      }
      
	  // *****************************************
	  // Dispatch Tracking methods
	  // *****************************************

      private function getNext():* {
      	var results : * = null;
      	
      	switch(trigger) {
      	  case TRIGGER_SEQUENCE :  		if (__doneCounter <= __sequence.length) {
                                  		  	results = __sequence[__doneCounter];      	
                                  		};
                                  		break;
                                  		
          case TRIGGER_PARALLEL :     for each (var item : * in __sequence) {
                                        if (hasBeenDispatched(item) != true) {
                                          results = item;
                                          break;
                                        }                                        
                                      }
                                      break;
      	} 
		  	
      	return results;
      }
      
	  private function hasNext():Boolean {
	  	var result : Boolean = false;
	  	var key    : *       = getNext();

	  	if ((key != null) && !hasBeenDispatched(key)){ 
  				result = true;
	  	}
	  	
	  	return result;
	  }   
	     
      private function hasBeenDispatched(key:*):Boolean {
      	var results : Boolean = false;
      	if (__events[key] != null) {
      		results = __events[key].hasBeenDispatched;
      	}
      	return results;
      }
      
      private function markAsDispatched(key:*):void {
        __events[key].hasBeenDispatched = true;
      }
      
	  // *****************************************
	  // Private Attributes
	  // *****************************************
      private var __numOfFails  : int = 0;
      private var __doneCounter : int = 0;

	    private var __sequence    : Array      = new Array();					      // maintains sequence of all events to fire
      private var __events 		  : Dictionary = new Dictionary(true);  		// tracks additional flags/conditions for each event
      private var __announcer   : Callbacks  = null;						          // callbacks for broadcasting fail/success conditions
   }
}