<#assign entity = generator.map(field$entity, "entities", 1)!"null">
<#if entity != "null">
if (world instanceof ServerWorld) {
	Entity entityToSpawn = new ${generator.map(field$entity, "entities", 0)}(${entity}, ((ServerWorld) world);
	entityToSpawn.setLocationAndAngles(${input$x}, ${input$y}, ${input$z}, ${opt.toFloat(input$yaw)}, ${opt.toFloat(input$pitch)});
	entityToSpawn.setRenderYawOffset(${opt.toFloat(input$yaw)});
	entityToSpawn.setRotationYawHead(${opt.toFloat(input$yaw)});

	if (entityToSpawn instanceof MobEntity)
		((MobEntity) entityToSpawn).onInitialSpawn(((ServerWorld) world), world.getDifficultyForLocation(entityToSpawn.getPosition()), SpawnReason.MOB_SUMMONED, null, null);

	world.addEntity(entityToSpawn);
}
</#if>
