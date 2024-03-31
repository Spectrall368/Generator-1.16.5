<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onItemExpire(ItemExpireEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getEntity().getPosX()",
			"y": "event.getEntity().getPosY()",
			"z": "event.getEntity().getPosZ()",
			"world": "event.getEntity().world",
			"entity": "event.getEntity()",
			"itemstack": "event.getEntityItem().getItem()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
