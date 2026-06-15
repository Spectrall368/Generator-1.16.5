<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onChat(ServerChatEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPlayer().getPosX()",
			"y": "event.getPlayer().getPosY()",
			"z": "event.getPlayer().getPosZ()",
			"world": "event.getPlayer().world",
			"entity": "event.getPlayer()",
			"text": "event.getMessage()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
