<#include "mcelements.ftl">
if (world instanceof ServerWorld) {
	LightningBoltEntity entityToSpawn = EntityType.LIGHTNING_BOLT.create((World) world);
	entityToSpawn.moveForced(Vector3d.copyCenteredHorizontally(${toBlockPos(input$x,input$y,input$z)}));
	entityToSpawn.setEffectOnly(${(field$effectOnly!false)?lower_case});
	((World) world).addEntity(entityToSpawn);
}