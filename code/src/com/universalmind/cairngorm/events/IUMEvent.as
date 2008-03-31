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
	import flash.events.Event;
	
 /**
    * This interface is similar to the IValueObject interface to 
    * require all UMEvent implementations to have copyFrom() and clone()
    * functionality
    */
	public interface IUMEvent
	{
	  /**
	    * This method allows events to easily initialize themselved based on
	    * values within other instances.
	    */
		function copyFrom(src : Event)	: Event;
    /**
		  * This method allows events to easily clone themselves; and allows developers
		  * to quickly create new copies for re-dispatching, 
		  */		
		function clone()				        : Event;
	}
}