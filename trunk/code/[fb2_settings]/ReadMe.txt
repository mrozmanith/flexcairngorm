Universal Mind Cairngorm v2.2.1

Introduction
---------------------
This version of Cairngorm supports Adobe's Cairngorm v2.2.1. In fact, the UM_Cairnngorm swc file contains the com.adobe.cairngorm.* files and packages.
The Universal Mind class extensions now support the same package structures as the com.adobe.cairngorm.* packages;
   e.g.
        com.adobe.cairngorm.business.ServicLocator
	com.universalmind.cairngorm.business.ServicLocator
This 1-to-1 mapping of packages allows the UM Cairngorm framework to be easily plugged into existing cairngorm applications with minimal impact.


Descriptions of Extensions
------------------------------
The Universal Mind library extends the Adobe Cairngorm in several lightweight, but significant, manners:

1) FrontControllers
   The UniversalMind FrontController supports 
      (a) subControllers so mini-MVC modules can be aggregated and used within a global MVC framework.
      (b) UIComponent eventHook functionality so UI-level events may continue to bubble up the view hierarchy but are also be dispatched directly to the CairngormEventDispatcher
          if the event is a UMEvent subclass. As such, no view code is now required to import CairngormEventDispatcher. Nor are PopUpManage event dispatches an issue for the 
	  cairngorm mvc framework

2) Events
   The UMEvent now deprecates the dispatchEvent() method, and enforces the implementation of clone() and copyFrom() methods. These events now bubble [ === true ] by default and 
   allow callers to provide an optional constructor parameter to specify the Responder for the call. This allows any event destination to notify the responder regarding a result or fault event.

3) Commands

4) Delegates
5) ServiceLocators
