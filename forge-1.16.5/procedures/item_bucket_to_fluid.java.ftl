<#include "mcitems.ftl">
/*@BlockState*/(${mappedMCItemToItem(input$source)} instanceof BucketItem ? ((BucketItem) ${mappedMCItemToItem(input$source)}).getFluid().getDefaultState().getBlockState() : Blocks.AIR.getDefaultState())
