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
   import flash.utils.Dictionary;
   
   /**
     * The UniversalMind FrontController is used as a "super"
     * cairngorm controller to allow modules to register their own sub-controllers
     * as part of the application set.
     * 
     * <p>
     * Often applications are developed with distinct modules (dynamically loaded
     * or static compiled). These modules may contain their own mini-Cairngorm MVC
     * but need to be used with the scope of an application MVC; used without namespace
     * conflicts or overrides.
     * </p>
     * 
     * <p>
     * Each subcontroller maps its own events to its own commands. This allows modules 
     * sub-MVCs to be "plugged" into other applications easily.
     * </p>
     * 
     * <pre>
     *
     *      import com.clientX.sales.control.SalesController;
     *      import com.clientX.accounts.control.AccountsController;
     *  
     *      public class ClientXController extends FrontController {
     *        
     *          public function SalesController() {
     *             registerClientXEvents();
     *             registerModules();
     *          }
     * 
     *          private function registerClientXEvents():void {
     *               addCommand(LoginUserEvent.EVENT_ID,     LoginCommand);
     *               addCommand(RegisterUserEvent.EVENT_ID,  RegistrationCommand);
     *          }
     * 
     *          private function registerModuleEvents():void {
     *              addSubController(SalesController);
     *              addSubController(AccountsController);
     *          }
     *      }
     * 
     * </pre>
     * 
     * @see com.universalmind.cairngorm.control.ModuleController
     */
   public class FrontController extends BaseController
   {   
      /**
        * This method allows classes of subControllers to be registered and instantiated
        * Events registered with the subcontroller are "added" to the global event->command
        * mappings. Events for subControllers are simply "forwarded" to that subController's
        * event-mapping processor.
        * 
        * @controllerRef This is the class name of module controller that should be 
        * instantiated and cached.
        * 
        * @see com.universalmind.cairngorm.control.ModuleController 
        */	 	 
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
	   	  		var moduleEvents : Array = (module as ModuleController).registeredEvents;   	  		
	   	  		for each (var eventID : String in moduleEvents) {
					      listenForEvent(eventID,module.eventHandler);   	  			
	   	  		}   	  		
	   	  	}
   	  	}
   	  }
   	  

      // ***********************************************************
      // Private methods
      // ***********************************************************

      /**
        * This method checks the runtime type of the sub-controller.
        * If not a subclass of ModuleController, then an error is thrown.
        * 
        * @subController This is an instance of a class that "should be" a sub-Controller
        */
  	  private function checkModuleType(subController:*):Boolean {
       		if (subController is ModuleController) return false;
       		else {
       			var msg : String = "SubControllers must be subclasses of ModuleController.";
       			throw new Error( msg );	
       		}
  	  }
      
      /**
        * This function performs a pre-instantiation check of registration for the
        * subcontroller. SubControllers can only be registered 1x.
        * 
        * @controllerRef The class of the subcontroller that we are preparing to
        * instantiate
        */
   	  private function isControllerRegistered(controllerRef : Class):Boolean {
   	  	return (__subControllers[controllerRef] != null);
   	  }
   	  
   	  /** Internal cache for all subControllers instantiated and registered */
	    private var __subControllers 	: Dictionary = new Dictionary();
   }   
}
