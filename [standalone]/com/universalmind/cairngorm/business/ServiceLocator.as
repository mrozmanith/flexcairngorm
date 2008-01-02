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
package com.universalmind.cairngorm.business
{    
   import mx.rpc.AbstractService;
   import mx.rpc.AbstractInvoker;
   import mx.rpc.http.HTTPService;
   import mx.rpc.soap.WebService;

   import mx.core.UIComponent;
   import mx.rpc.remoting.mxml.RemoteObject;
   import mx.rpc.events.ResultEvent;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.soap.LoadEvent;
   
 
    public class ServiceLocator extends UIComponent {
   	
		public var local 		: Boolean = false;
		public var urlDetails 	: Array   = [];
			
		public function updateServiceURLS(urlDetails:Array):void {
			this.urlDetails = urlDetails != null ? urlDetails : [];
			
			// Scan thru the services and attempt to set the proper URL or WSDL references...
			for each (var item:* in urlDetails) {
				/* !! expected data format: 
					
					[ 
					 {serviceName, localURL, remoteURL},
					 {serviceName, localURL, remoteURL} 
					]
				*/								
				var serviceID   : String = item.serviceName;
				var serviceURL  : String = lookupServiceURL(serviceID);
				var service     : *      = findInvoker(serviceID,true);
				
				if (service != null) {
					if  (service is WebService)		{
						var ws : WebService = (service as WebService);	
						
					    ws.addEventListener(FaultEvent.FAULT,	onWSDL_LoadError);
					    ws.addEventListener(ResultEvent.RESULT,	onWSDL_Loaded);
					    					
						ws.requestTimeout 	= 2;
						if (serviceURL != "") {
							ws.wsdl 			= serviceURL;								
							ws.loadWSDL();
						}
					}
					else if (service is HTTPService)	{
				    	var hs : HTTPService = service as HTTPService;
						hs.url = serviceURL;
					}
				}					
			}
						
		}

   	  // ************************************************* 
   	  // Singleton functions 
   	  // ************************************************* 

      public static function getInstance() : ServiceLocator
      {
         if ( __serviceLocator == null )
            __serviceLocator = new ServiceLocator();
   
         return __serviceLocator;
      }
      
      public function ServiceLocator()
      {
         if ( ServiceLocator.__serviceLocator != null )
            throw new Error( "Only one UM ServiceLocator instance should be instantiated" );
   
         ServiceLocator.__serviceLocator = this;
      }
         
   	  // ************************************************* 
   	  // Public Service Lookup functions 
   	  // ************************************************* 

	  public function getWebService( serviceID : String ) 	: WebService		{      
	  	 return WebService(     findInvoker(serviceID) );	 
	  }
	  	 
      public function getHTTPService( serviceID : String ) 	: HTTPService    	{       return HTTPService(    findInvoker(serviceID) );	 }
      public function getService( serviceID : String ) 		: AbstractService   {       return AbstractService(findInvoker(serviceID) );     }      

	  private function findInvoker(serviceID:String, throwError : Boolean = true ) : * {
	  	var results 	: * 	 = undefined;
		var serviceName : String = lookupServiceNameByID(serviceID);
		
		try {
			if ((serviceName != "") && (this.hasOwnProperty(serviceName))) results = this[serviceName];
		} catch(e:Error){}
		
		if (results == undefined) {
			if (throwError == true) throw new Error( "Service "+serviceID+" was not found in the UM Services registry." );
			else 					results = null; 
		}
		
		return results;
	  }
	  
	  // ***************************************************
	  // Utility methods...
	  // ***************************************************
		
	  private function lookupServiceNameByID(serviceID:String):String {
	  	var results : String = serviceID;
	  	
		for each (var item:* in urlDetails) {
			// !! expected data format: [ {serviceName, localURL, remoteURL} ]
			if (item.serviceName == serviceID) {
				results = (local && (String(item.localURL) != "")) ? "sapLocalService"  : item.serviceName;
				break;
				
			}
		}
	  	
	  	return results;	
	  }

	  private function lookupServiceURL(serviceID:String):String {
	  	var serviceURL : String = "";
	  	
		for each (var item:* in urlDetails) {
			// !! expected data format: [ {serviceName, localURL, remoteURL} ]
			if (item.serviceName == serviceID) {
				serviceURL = (local && (String(item.localURL) != "")) ? item.localURL      : item.remoteURL;
				break;
			}
		}	  		
		
		// If the urlDetails did NOT contain the service information... then perhaps it is in the Services.mxml
		if (serviceURL == "") {
			var service : * = this[serviceID];
			if (service != null) {
				if 		(service is WebService)		serviceURL = (service as WebService).wsdl;
				else if (service is HTTPService)	serviceURL = (service as HTTPService).url;
				else if (service is RemoteObject)	serviceURL = (service as RemoteObject).endpoint;
			}
		}
		
		return serviceURL;
		
	  }
		
	 //******************************************************
	 // Safe error handlers
	 //******************************************************
	 	  
		private function onWSDL_LoadError(event:FaultEvent):void {
			if (local != true) 	throw new Error(event.fault.faultDetail);
		}
		private function onWSDL_Loaded(event:ResultEvent):void {
			var ws : WebService = event.target as WebService;
			if (ws != null) {
				// So the WSDL loaded... reset any future calls to 
				// timeout the call after 5 minutes
				ws.requestTimeout = 300;
			}
		}

      private static var __serviceLocator : ServiceLocator;      
      
   }   
}
