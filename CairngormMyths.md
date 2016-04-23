# Myths and Misconceptions of Cairngorm MVC #

  1. Flex already has a framework. I do not need Cairngorm MVC.
> > _Answer_:


> 2) Cairngorm is Flex only.
> > _Answer_:


> 3) Why do I need to consider Cairngorm when I can use my own - better - MVC framework.
> > _Answer_:


> 4) I have to create so many files. Cairngorm seems to require many, many classes such as events, commands, delegates.
> > _Answer_: Cairngorm wants a (1) FrontController (to map events to commands), (2) business events, and (3) commands. Delegates are optional. You DO NOT, however, 0need a distinct Command class for each business Event. That is RIDICULOUS and creates huge quantity of files. Simply create Command classes to handle classes/groups of related events. So LogInEvent, LogOutEvent, RefreshSessionEvent would be handled by the AuthenticationCommand, etc. In the AuthenticationCommand::execute() do a switch off the event.type to call a protected or private method. Thus you will have many event classes, but a small set of Command and Delegate classes.


> 5) My UI code is polluted with _CairngormEventDispatcher.getInstance().dispatchEvent()_
> > _Answer_:


> 6) Why do I have to use Delegates?
> > _Answer_: Developers use delegates for two purposes. (1) A delegate can provide the client-side API for its server-side mappings. This means the delegate class has an API that matches the remote services. This can be quite nice. (2) A delegate is the PERFECT layer (between commands and RPC) to transform incoming and outgoing data. With delegate transformations, commands then focus on VOs, business logic, and models... without needing to worry about data conversions; e.g. converting XML to domain value objects.


> 7) I can store all my application data in the ModelLocator
> > _Answer_: If you are tempted to store all your data in one large ModelLocator class, do not do it! Create specific models classes such as UserVO, PermissionsVO, EmployeeModel, etc... store instances of those in the ModelLocator. Thus the ModelLocator becomes a tree-like repository for data.