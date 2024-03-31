<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityJump(LivingEvent.LivingJumpEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getEntityLiving().getPosX()",
			"y": "event.getEntityLiving().getPosY()",
			"z": "event.getEntityLiving().getPosZ()",
			"world": "event.getEntityLiving().world",
			"entity": "event.getEntityLiving()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
