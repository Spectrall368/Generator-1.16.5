<#include "procedures.java.ftl">
@Mod.EventBusSubscriber public class ${name}Procedure {
	@SubscribeEvent public static void onCommand(CommandEvent event) {
		Entity entity = event.getParseResults().getContext().getSource().getEntity();
		if (entity != null) {
			<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
				"x": "entity.getPosX()",
				"y": "entity.getPosY()",
				"z": "entity.getPosZ()",
				"world": "entity.world",
				"entity": "entity",
				"command": "event.getParseResults().getReader().getString()",
				"arguments": "event.getParseResults().getContext().build(event.getParseResults().getReader().getString())",
				"event": "event"
				}/>
			</#compress></#assign>
			execute(event<#if dependenciesCode?has_content>,</#if>${dependenciesCode});
		}
	}
