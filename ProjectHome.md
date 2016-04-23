The Adobe Cairngorm MVC framework is used by many Flex developers to deliver scalable and maintainable rich internet applications.


This is not the site for the core, "out-of-the-box" Adobe Cairngorm. Readers may visit the [Adobe Labs](http://labs.adobe.com/wiki/index.php/Cairngorm) for more information about Adobe Cairngorm MVC.  Meanwhile, the Cairngorm Extensions provided here have been open-sourced to help developers address Cairngorm implementation issues commonly encountered within enterprise RIA solutions.

# Extensions for Adobe Cairngorm #
The Cairngorm Extensions are summarized below. Each link will provide details and examples of the specific extension:

  1. [Events](http://code.google.com/p/flexcairngorm/wiki/Events)
    * Built-in support to transport responders for direct view or business logic callbacks.
    * Implementation of AnnounceFaultEvent to allow business logic to centralize error reporting and logging.
    * Implementation of EventGenerator to allow developers to automate dispatching of sequences of events.
    * Events now should self-dispatch... for direct deliver to the business/controller layer.

> 2) [View Notification](http://code.google.com/p/flexcairngorm/wiki/ViewNotifications)
    * Built-in framework support to allow views to using proxy responders to request direct notifications to business events responses.

> 3) [FrontControllers](http://code.google.com/p/flexcairngorm/wiki/FrontController)
    * SubControllers are available so modules implemented with sub-MVC and dynamically aggregated and used within a global MVC framework.
    * Improved error checking
    * Ability to easily register a Function callback for any business event

> 4) [Command Implementation](http://code.google.com/p/flexcairngorm/wiki/Commands)
    * Base class implementation
    * Enhancements to support aggregation of event-business logic within a single Command class.
    * Support for the optional view notifications
    * _Best practice_ to deprecate Command sequencing

> 5) [Delegate Implementation](http://code.google.com/p/flexcairngorm/wiki/Delegates)
    * Base class implementation
    * Support for easy queue of delegate calls
    * Improved support for WebService use and WSDL errors
    * _Best practice_ to allow easy data transformations
    * _Best practice_ to hide multiple server calls

> 6) [ServiceLocator](http://code.google.com/p/flexcairngorm/wiki/ServiceLocator)
    * Configure services (RDS) at runtime
    * Configure timeouts of HTTPService and WebService

Universal Mind has extended the "classic" Adobe 2.2.x Cairngorm version to provide many productivity and maintenance enhancements. Those extensions have now been open-sourced - with BSD licensing -  to the Flex and Flash developer community. Please note that - for now - the library source code contained here (and compiled into the .swc library) actually includes the source code from the **Cairngorm 2.2.1** release. Soon developers will be able to use build options to generate a CairngormExtensions.swc that does not include the core Adobe Cairngorm code.

Click here to read about the many **[Cairngorm myths](http://code.google.com/p/flexcairngorm/wiki/CairngormMyths)** that exist regarding Cairngorm and its appropriate place in developing Flex RIA solutions.

Click here to read [about Adobe Cairngorm](http://code.google.com/p/flexcairngorm/wiki/AboutCairngorm) and it's purposes and issues.


## Sample Applications ##

[![](http://flexcairngorm.googlecode.com/svn/trunk/docs/samples/FlexStore_Thumbnail.gif)](http://code.google.com/p/flexcairngorm/wiki/FlexStore)


