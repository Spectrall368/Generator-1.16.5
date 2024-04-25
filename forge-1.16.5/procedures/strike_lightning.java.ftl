<#include "mcelements.ftl">
if (world instanceof ServerWorld) {
	LightningBoltEntity entityToSpawn = EntityType.LIGHTNING_BOLT.create((ServerWorld) world);
	entityToSpawn.moveForced(Vector3d.copyCenteredHorizontally(${toBlockPos(input$x,input$y,input$z)}));
	<#if (field$effectOnly!false)?lower_case == "true">entityToSpawn.setEffectOnly(true)</#if>;
	((ServerWorld) world).addEntity(entityToSpawn);
}
