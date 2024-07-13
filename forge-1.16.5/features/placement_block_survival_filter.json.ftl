<#include "mcitems.ftl">
if (!${mappedBlockToBlockStateCode(input$block)}.isValidPosition(world, placePos))
  return false;
