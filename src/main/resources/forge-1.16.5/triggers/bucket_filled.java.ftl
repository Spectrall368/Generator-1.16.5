<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onBucketFill(FillBucketEvent event) {
		<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getPlayer().getPosX()",
			"y": "event.getPlayer().getPosY()",
			"z": "event.getPlayer().getPosZ()",
			"world": "event.getWorld()",
			"itemstack": "event.getFilledBucket()",
			"entity": "event.getPlayer()",
			"event": "event"
			}/>
		</#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
