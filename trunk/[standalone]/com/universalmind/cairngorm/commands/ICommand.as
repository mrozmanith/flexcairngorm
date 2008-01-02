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
   import com.universalmind.cairngorm.events.UMEvent;

   /**
    * 
    * The ICommand interface enforces the contract between the Front
    * Controller and concrete command classes in your application.
    * 
    * <p>In a Cairngorm application, the application specific Front Controller
    * will listen for events of interest, dispatching control to appropriate
    * command classes according to the type of the event broadcast.</p>
    *
    * <p>
    * When an event is broadcasted by the Front Controller, it will
    * lookup its list of registered commands, to find the command capable
    * of carrying out the appropriate work in response to the user gesture
    * that has caused the event.
    * </p>
    *
    * <p>
    * When the event that an command is registered against is broadcast,
    * the Front Controller class will invoke the command by calling its
    * execute() method, which can be considered the entry point to a
    * command.
    * </p>
    *
    * @see com.universalmind.cairngorm.control.FrontController
    * @see com.universalmind.cairngorm.control.CairngormEventDispatcher
    */ 
   public interface ICommand
   {
      /** Called by the Front Controller to execute the command.
       * 
       * <p>The single entry point into an ICommand, the 
       * execute() method is called by the Front Controller when a 
       * user-gesture indicates that the user wishes to perform a 
       * task for which a particularconcrete command class has been 
       * provided.</p>
       *
       * @param event When the Front Controller receives notification
       * of a user gesture, the Event that it receives contains both the
       * type of the event (indicating which command should handle the
       * work) but also any data associated with the event.
       *
       * <p>
       * For instance, if a "login" event has been broadcasted,
       * to which the controller has registered the LoginCommand,
       * the event may also contain some associated data, such as
       * the number of prior attempts at login have been made
       * already. In this case, the event.type would be set to
       * "login" while other properties define in the custom login 
       * event object would contain (by way of example)
       * an attribute such as attemptedLogins. 
       * </p>
       *
       * <p>
       * By careful use of custom event objects, the same
       * concrete command class is capable of responding in slightly
       * different ways to similar user gesture requests.
       * </p>
       */
      function execute( event : UMEvent ) : void;
   }
}