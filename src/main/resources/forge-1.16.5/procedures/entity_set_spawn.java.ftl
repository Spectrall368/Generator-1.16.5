<#include "mcelements.ftl">
if(${input$entity} instanceof ServerPlayerEntity)
	((ServerPlayerEntity) ${input$entity}).func_242111_a(((ServerPlayerEntity) ${input$entity}).world.getDimensionKey(), ${toBlockPos(input$x,input$y,input$z)}, ((ServerPlayerEntity) ${input$entity}).rotationYaw, true, false);
