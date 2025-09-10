<#include "mcitems.ftl">
new BlockClusterFeatureConfig.Builder(${mappedBlockToBlockStateProvider(input$block)}, SimpleBlockPlacer.PLACER)
.tries(${field$tries}).xSpread(${field$xzSpread}).zSpread(${field$xzSpread}).ySpread(${field$ySpread}).build()
$
if(!(${input$condition})) return false;
$