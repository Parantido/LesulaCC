package org.techfusion.controller {
	
	// Import Model Classes
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.techfusion.model.proxies.AsteriskManagerInterfaceProxy;
	import org.techfusion.model.proxies.DatabaseProxy;
	import org.techfusion.view.mediators.ApplicationMediator;

	public class StartupCommand extends SimpleCommand implements ICommand {
		
		override public function execute(notification:INotification):void {
			// Debug
			trace("StartupCommand ==> Executing Startup Command");
			
			// Register needed Proxies
			facade.registerProxy(new AsteriskManagerInterfaceProxy());
		
			// Register a new Mediator
			facade.registerMediator(new ApplicationMediator(notification.getBody() as LesulaCC));
		}
	}
}