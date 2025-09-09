<#include "mcitems.ftl">
$if (!${mappedBlockToBlock(input$block)}.isValidPosition(world.getBlockState(origin.down()), world, origin))
  return false;$