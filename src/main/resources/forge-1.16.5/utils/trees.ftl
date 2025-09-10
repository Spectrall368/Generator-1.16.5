<#-- Macro for trunk placers that only use height parameters -->
<#macro simpleTrunkPlacer type height rand_a rand_b>
<#if type == "minecraft:straight_trunk_placer">
new StraightTrunkPlacer(${height}, ${rand_a}, ${rand_b})
<#elseif type == "minecraft:forking_trunk_placer">
new ForkyTrunkPlacer(${height}, ${rand_a}, ${rand_b})
<#elseif type == "minecraft:dark_oak_trunk_placer">
new DarkOakTrunkPlacer(${height}, ${rand_a}, ${rand_b})
<#elseif type == "minecraft:fancy_trunk_placer">
new FancyTrunkPlacer(${height}, ${rand_a}, ${rand_b})
<#else>
new MegaJungleTrunkPlacer(${height}, ${rand_a}, ${rand_b})
</#if>
</#macro>

<#-- Macro for foliage placers that only use radius, offset, and optional height parameters -->
<#macro simpleFoliagePlacer type radius offset height=-1>
<#if type == "minecraft:blob_foliage_placer">
new BlobFoliagePlacer(FeatureSpread.func_242252_a(${radius}), FeatureSpread.func_242252_a(${offset}), ${height})
<#elseif type == "minecraft:acacia_foliage_placer">
new AcaciaFoliagePlacer(FeatureSpread.func_242252_a(${radius}), FeatureSpread.func_242252_a(${offset}))
<#elseif type == "minecraft:dark_oak_foliage_placer">
new DarkOakFoliagePlacer(FeatureSpread.func_242252_a(${radius}), FeatureSpread.func_242252_a(${offset}))
<#elseif type == "minecraft:bush_foliage_placer">
new BushFoliagePlacer(FeatureSpread.func_242252_a(${radius}), FeatureSpread.func_242252_a(${offset}), ${height})
<#elseif type == "minecraft:fancy_foliage_placer">
new FancyFoliagePlacer(FeatureSpread.func_242252_a(${radius}), FeatureSpread.func_242252_a(${offset}), ${height})
<#else>
new JungleFoliagePlacer(FeatureSpread.func_242252_a(${radius}), FeatureSpread.func_242252_a(${offset}), ${height})
</#if>
</#macro>

<#macro twoLayersFeatureSize limit lower_size upper_size min_clipped_height=-1>
new TwoLayerFeature(${limit}, ${lower_size}, ${upper_size}<#if min_clipped_height != -1>, OptionalInt.of(${min_clipped_height})</#if>)
</#macro>

<#macro threeLayersFeatureSize limit upper_limit lower_size middle_size upper_size>
new ThreeLayerFeature(${limit}, ${upper_limit}, ${lower_size}, ${middle_size}, ${upper_size}, OptionalInt.empty())
</#macro>