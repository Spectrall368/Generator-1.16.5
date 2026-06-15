<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityAttacked(LivingHurtEvent event) {
		if (event != null && event.getEntity() != null) {
			<#assign dependenciesCode>
			<@procedureDependenciesCode dependencies, {
				"x": "event.getEntity().getPosX()",
				"y": "event.getEntity().getPosY()",
				"z": "event.getEntity().getPosZ()",
				"world": "event.getEntity().world",
				"amount": "event.getAmount()",
				"entity": "event.getEntity()",
				"damagesource": "event.getSource()",
				"sourceentity": "event.getSource().getTrueSource()",
				"event": "event"
				}/>
			</#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
