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
   import flash.events.Event;
   
   import com.universalmind.cairngorm.commands.ICommand;

   import com.universalmind.cairngorm.control.CairngormEventDispatcher;
   import com.universalmind.cairngorm.events.UMEvent;
   
   public class SequenceCommand implements ICommand 
   {      
      public var nextEvent : UMEvent;  	// next event to manually dispatch when onResults__<xxx> is done     
       
      public function SequenceCommand( nextEvent : Event = null ) : void {
         super();
         this.nextEvent = nextEvent as UMEvent;
      }
             
      public function execute( event : Event ) : void       {
          // abstract, so this method must be provided.   Rather than convolute additional framework classes to enforce
          // abstract classes, we instead delegate responsibility to the developer of a SequenceCommand to ensure that
          // they provide a concrete implementation of this method.
      }
      
      public function executeNextCommand() : void
      {
         var isSequenceCommand : Boolean = ( nextEvent != null );
         if( isSequenceCommand ) {
            CairngormEventDispatcher.getInstance().dispatchEvent( nextEvent );
         }
      }
      
   }
}