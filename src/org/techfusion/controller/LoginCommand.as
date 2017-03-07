package org.techfusion.controller {
	
	// Import Model Classes
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.techfusion.events.LoginViewEvent;
	import org.techfusion.model.proxies.AsteriskManagerInterfaceProxy;
	
	public class LoginCommand extends SimpleCommand implements ICommand {
		
		public function LoginCommand() {
		}
		
		override public function execute(notification:INotification):void {
			// Debug
			trace("LoginCommand ==> Executing Login Command");
			
			// Retrieve LoginViewEvent Object
			var loginViewEvent:LoginViewEvent = notification.getBody() as LoginViewEvent;
			
			// Retrieve Proxy Connector
			var mgrTopologyProxy:AsteriskManagerInterfaceProxy = facade.retrieveProxy(AsteriskManagerInterfaceProxy.NAME) as AsteriskManagerInterfaceProxy;
			
			// Do Connection
			mgrTopologyProxy.doConnect(loginViewEvent.getServer());
			
			// Do Login and Enable Events Handling
			mgrTopologyProxy.manLogin(loginViewEvent.getUsername(), loginViewEvent.getPassword(), "on");
		}
	}
}