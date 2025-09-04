<#include "mcelements.ftl">
if(world instanceof World)
  ${field$dimension.replace("CUSTOM:", "")}PortalBlock.portalSpawn(((World) world), ${toBlockPos(input$x,input$y,input$z)});
