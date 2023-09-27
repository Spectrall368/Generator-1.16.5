<#include "mcitems.ftl">
new BlockClusterFeatureConfig(${field$tries}, ${field$xzSpread}, ${field$ySpread},
    PlacementUtils.filtered(Feature.SIMPLE_BLOCK, new BlockStateFeatureConfig(${mappedBlockToBlockStateProvider(input$block)}), ${input$condition}))
