<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onPickup(EntityItemPickupEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPlayer().getPosX()",
			"y": "event.getPlayer().getPosY()",
			"z": "event.getPlayer().getPosZ()",
			"world": "event.getPlayer().world",
			"entity": "event.getPlayer()",
			"itemstack": "event.getItem().getItem()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
