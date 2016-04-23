# Sample RIA: Adobe Flex Store #

![http://flexcairngorm.googlecode.com/svn/trunk/docs/samples/FlexStore.gif](http://flexcairngorm.googlecode.com/svn/trunk/docs/samples/FlexStore.gif)

## Introduction ##

The FlexBuilder 2 Installer from Macromedia installed a sample application called the **Flex Store**. The FlexStore was provided to the community to demonstrate rich-client application concepts that offered online by using UI components, filters, effects, transitions, view states, etc.

The FlexStore displays 3 screens of content: Home, Products, Support. The Products screen dynamically loads an xml catalog file with data for available mobile phones. In the Product screen (shown above), users can interactively:
  * filter which phones are displayed by criteria of cost, features, and other options.
  * compare features of 1 or more phones
  * add/remove phones from the shopping cart
  * drag 'n drop phones to the compare or shopping cart areas.

The FlexStore is quite amazing in the plethora of features that it demonstrates in a sample application. Developers can explore the source code to discover techniques and solutions that can be applied to their own custom applications.

## Issues ##

Unfortunately the original FlexStore suffers from **4 significant** problems:
  * The code is poorly organized, hard to understand, and impossible to enhance (as is).
  * Business logic is mixed with view logic and code.
  * Access to remote data services is mixed with view code.
  * View components are not using events properly.
  * View components have badly _coupling_ relationships.

With these considerations, it is obvious that the FlexStore is **not** an example of code that would be used to create a production or enterprise application. This application (in its original state) would be a _nightmare_ to enhance or reuse.

## Solution ##

To remove the above issues, The FlexStore application desperately needed its components separated into an MVC architecture. Java uses Struts or Swing, ColdFusion uses Mach-ii or Model-Glue. Flex uses the Adobe Cairngorm MVC framework.

Below are links to the versions of the FlexStore with and without Cairngorm MVC.
Developers are encouraged to download all versions below and compare the changes between the architectures, components, data structures, and couplings.

| Version | Download | SVN Link |
|:--------|:---------|:---------|
| FlexStore (original) | [download winzip](http://flexcairngorm.googlecode.com/svn/trunk/docs/samples/flexStoreOriginal.zip) |          |
| FlexStore (w/ Cairngorm MVC) | [download winzip](http://flexcairngorm.googlecode.com/svn/trunk/docs/samples/flexStore_CGX.zip) |          |
| FlexStore (w/ Cairngorm MVC and UM Extensions) | _coming soon_ | _pending_ |

Note: the above FlexStore links include the FlexBuilder project files. These project files require FlexBuilder 3 and include the Cairngorm 2.2.1 flex library (.swc).

Developers will notice that the visual aspects have not changed at all. Only the code _under the hood_ has changed. Component relationships, use of events, and code partitioning have all been significant improved.

Developers are encouraged to use the directory and file comparison tool [BeyondCompare](http://www.scootersoftware.com) to compare the different versions of the FlexStore. Comparing the changes will be the primary method that developers can learn about the changes and non-visual enhancements to the FlexStore.
