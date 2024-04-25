<#include "mcitems.ftl">
if (world instanceof ServerWorld) {
	ItemEntity entityToSpawn = new ItemEntity(((ServerWorld) world), ${input$x}, ${input$y}, ${input$z}, ${mappedMCItemToItemStackCode(input$block, 1)});
	entityToSpawn.setPickupDelay(${opt.toInt(input$pickUpDelay!10)});
	<#if (field$despawn!true)?lower_case == "false">
	entityToSpawn.setNoDespawn();
	</#if>
	((ServerWorld) world).addEntity(entityToSpawn);
}
