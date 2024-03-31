<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onEntityTamed(AnimalTameEvent event) {
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
			"x": "event.getAnimal().getPosX()",
			"y": "event.getAnimal().getPosY()",
			"z": "event.getAnimal().getPosZ()",
			"world": "event.getAnimal().world",
			"entity": "event.getAnimal()",
			"sourceentity": "event.getTamer()",
			"event": "event"
			}/>
		</#compress></#assign>
		execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
	}
