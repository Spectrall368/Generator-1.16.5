<#include "mcelements.ftl">
<#assign entity = generator.map(field$entity, "entities", 1)!"null">
<#if entity != "null">
if (world instanceof ServerWorld) {
	Entity entityToSpawn = ${entity}.spawn((ServerWorld) world, world.getDifficultyForLocation(${toBlockPos(input$x,input$y,input$z)}), SpawnReason.MOB_SUMMONED, null, null);
	if (entityToSpawn != null) {
		entityToSpawn.rotationYaw = world.getRandom().nextFloat() * 360F;
	}
}
</#if>