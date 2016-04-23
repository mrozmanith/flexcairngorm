# About Cairngorm #

Cairngorm is a model-view-controller (MVC) framework which encourages developers to separate "all" business and data persistence logic from their Flex UI/view code.

Cairngorm **does not** help the developer improve the user interfaces or UI components. In fact, Cairngorm has almost no involvement with user interfaces and the Flex "mx" Framework. The only _connection_ between your Cairngorm business code and your Flex UI is via **business events**, data binding.

Below are the basic principles of using Cairngorm... or other MVC solutions.

  * Views data bind to models or business data.
  * Views render or display data.
  * Views dispatch business events to a "business" layer (or group of business components)
  * 
---

  * Controllers routes business events to business processors and remote data services;
  * The Controller layer is also known as the "business" layer.
  * Controllers update model or business data
  * 
---

  * Business data is passive. Persistence [and saving](loading.md) is performed by the Controller
  * Business data manages its relationships with "business data" logic; e.g. adding an order item updates the total cost in the shopping cart
  * Business data and models do not know anything about the Controller or views
  * 
---

  * Views do not "know" anything about the business layer. Controller does not anything about the view layer. Events and Models are the "connections points" between the View and Controller layers.