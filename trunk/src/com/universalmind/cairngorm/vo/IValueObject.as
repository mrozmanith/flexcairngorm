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
package com.universalmind.cairngorm.vo
{
  /**
    * This class replaces the com.adobe.cairngorm.vo interface to 
    * require all VO implementations to have copyFrom() and clone()
    * functionality
    */
	public interface IValueObject {

      /** 
        * Allows any value object (complex or simple) to compare itself 
        * to a "source" object. This allows business logic to easily perform
        * comparisons to even tree-like data structures by simply comparing
        * the root nodes. [Of course the equals() implementation must ask the
        * children to compare themselves also...]
        * 
        * @src This is another value object that should be compared for equality.
        * An easy check is to see if the runtime datatype is of the same class type.
        * Note: that this allows comparisons of complex data types to scalar values...
        * if the developer wishes to support such "polymorphic" method overrides.
        */	
	  function equals(src:*):Boolean;

	  /**
	    * This method allows VOs to easily initialize themselved based on
	    * values within other instances.
	    */
		function copyFrom(src:*):*;
		
		/**
		  * This method allows VOs to easily clone themselves; allows developers
		  * to quickly create local copies, presever master references, and bypass
		  * issues related to Flex's "pass-by-reference".
		  */
		function clone():*;
	
	}
}