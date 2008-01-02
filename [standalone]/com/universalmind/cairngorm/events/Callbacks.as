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
	import mx.rpc.IResponder;
	import mx.rpc.events.*;
	
	public class Callbacks implements IResponder
	{
		public function Callbacks(	resultFunc  : Function = null,
              									faultFunc   : Function = null,
              									conflictFunc: Function = null,
              									priority    : int      = PRIORITY_AFTER) {
			
			// This class uses "method closures" to allow dynamic callbacks
			// to methods of class instances.
			this.resultHandler   = resultFunc;
			this.faultHandler    = faultFunc;
			this.conflictHandler = conflictFunc;
		}
		
		public function result(info:Object):void       {    if (resultHandler != null) resultHandler(info);			}
		public function fault(info:Object):void        {	if (faultHandler != null) faultHandler(info);			}
		
		
		
		public var resultHandler   : Function;
		public var faultHandler    : Function;
		public var conflictHandler : Function;
		
		public var priority        : int;
		
		public static const PRIORITY_BEFORE   : int = 0;
		public static const PRIORITY_AFTER    : int = 1;
		public static const PRIORITY_OVERRIDE : int = 2;
	}
}