<#include "mcitems.ftl">
<#include "trees.ftl">
new BaseTreeFeatureConfig.Builder(${toStateProvidertoFeatureState(input$trunk)}, ${toStateProvidertoFeatureState(input$foliage)},
<#if field$type == "pine">
new PineFoliagePlacer(FeatureSpread.func_242252_a(1), FeatureSpread.func_242252_a(1), FeatureSpread.func_242252_a(${input$foliage_height}))
<#else>
new MegaPineFoliagePlacer(FeatureSpread.func_242252_a(0), FeatureSpread.func_242252_a(0), FeatureSpread.func_242252_a(${input$foliage_height}))
</#if>,
<#if field$type == "pine">
<@simpleTrunkPlacer "minecraft:straight_trunk_placer" field$base_height field$height_variation_a field$height_variation_b/>, <@twoLayersFeatureSize limit=2 lower_size=0 upper_size=2/>
<#else>
<@simpleTrunkPlacer "minecraft:giant_trunk_placer" field$base_height field$height_variation_a field$height_variation_b/>, <@twoLayersFeatureSize limit=1 lower_size=1 upper_size=2/>
</#if>)<#if field$force_dirt == "TRUE">.setMaxWaterDepth(0)</#if>
<#if field$ignore_vines == "TRUE">.setIgnoreVines()</#if>.setDecorators(ImmutableList.of(<#list input_list$decorator as decorator>${decorator}<#sep>,</#list>)).build()
$
world.setBlockState(new BlockPos(origin.getX(), origin.getY() - 1, origin.getZ()), ${toStatetoFeatureState(input$dirt)}, 3);
$