<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onPlayerFishItem(ItemFishedEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPlayer().getPosX()",
			"y": "event.getPlayer().getPosY()",
			"z": "event.getPlayer().getPosZ()",
			"world": "event.getPlayer().world",
			"entity": "event.getPlayer()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
