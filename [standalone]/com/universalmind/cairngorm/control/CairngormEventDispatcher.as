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
   import flash.events.IEventDispatcher;
   import flash.events.EventDispatcher;
   import com.universalmind.cairngorm.events.UMEvent;
   
   public class CairngormEventDispatcher {
   	
      public static function getInstance() : CairngormEventDispatcher {
         if ( __instance == null )
            __instance = new CairngormEventDispatcher();
          
           return __instance;
      }
      
      public function CairngormEventDispatcher( target:IEventDispatcher = null ) {
         __eventDispatcher = new EventDispatcher( target );
      }
      
      public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = true ) : void {
         __eventDispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
      }
      
      public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ) : void {
         __eventDispatcher.removeEventListener( type, listener, useCapture );
      }

      public function dispatchEvent( event:UMEvent ) : Boolean {
         return __eventDispatcher.dispatchEvent( event );
      }
      
      public function hasEventListener( type:String ) : Boolean {
         return __eventDispatcher.hasEventListener( type );
      }
      
      public function willTrigger(type:String) : Boolean  {
         return __eventDispatcher.willTrigger( type );
      }


      private static var __instance : CairngormEventDispatcher;  
      private var __eventDispatcher : IEventDispatcher;
      
   }
}