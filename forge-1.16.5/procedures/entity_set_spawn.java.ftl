<#include "mcelements.ftl">
if(${input$entity} instanceof PlayerEntity) ((PlayerEntity) ${input$entity}).func_242111_a(((PlayerEntity) ${input$entity}).world.getDimensionKey(), ${toBlockPos(input$x,input$y,input$z)}, 0, true, false);
