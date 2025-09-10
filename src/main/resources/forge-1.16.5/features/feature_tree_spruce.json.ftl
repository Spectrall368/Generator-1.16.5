<#include "mcitems.ftl">
<#include "trees.ftl">
new BaseTreeFeatureConfig.Builder(${toStateProvidertoFeatureState(input$trunk)}, ${toStateProvidertoFeatureState(input$foliage)},
new SpruceFoliagePlacer(FeatureSpread.func_242253_a(0, 2),
<@simpleTrunkPlacer "minecraft:straight_trunk_placer" field$base_height field$height_variation_a field$height_variation_b/>,
${input$radius}, ${input$trunk_height}), <@twoLayersFeatureSize limit=2 lower_size=0 upper_size=2/>)
<#if field$force_dirt == "TRUE">.setMaxWaterDepth(0)</#if>
<#if field$ignore_vines == "TRUE">.setIgnoreVines()</#if>
.setDecorators(ImmutableList.of(<#list input_list$decorator as decorator>${decorator}<#sep>,</#list>)).build()
$
world.setBlockState(new BlockPos(origin.getX(), origin.getY() - 1, origin.getZ()), ${toStatetoFeatureState(input$dirt)}, 3);
$