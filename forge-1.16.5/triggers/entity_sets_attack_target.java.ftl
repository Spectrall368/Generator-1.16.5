<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntitySetsAttackTarget(LivingSetAttackTargetEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getTarget().getPosX()",
			"y": "event.getTarget().getPosY()",
			"z": "event.getTarget().getPosZ()",
			"world": "event.getEntityLiving().getEntityWorld()",
			"entity": "event.getTarget()",
			"sourceentity": "event.getEntityLiving()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
