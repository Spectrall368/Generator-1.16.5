<#-- Macro for trunk placers that only use height parameters -->
<#macro simpleTrunkPlacer type height rand_a rand_b>
new ${type}(${height}, ${rand_a}, ${rand_b})
</#macro>

<#-- Macro for foliage placers that only use radius, offset, and optional height parameters -->
<#macro simpleFoliagePlacer type radius offset height=-1>
new ${type}(FeatureSpread.func_242252_a(${radius}), FeatureSpread.func_242252_a(${offset})<#if type == "SpruceFoliagePlacer" || type == "PineFoliagePlacer" || type == "MegaPineFoliagePlacer">, FeatureSpread.func_242252_a(${height})<#elseif type == "AcaciaFoliagePlacer" || type == "DarkOakFoliagePlacer"><#else>, ${height}</#if>)
</#macro>

<#macro twoLayersFeatureSize limit lower_size upper_size>
new TwoLayerFeature(${limit}, ${lower_size}, ${upper_size})
</#macro>

<#macro threeLayersFeatureSize limit upper_limit lower_size middle_size upper_size>
new ThreeLayerFeature(${limit}, ${upper_limit}, ${lower_size}, ${middle_size}, ${upper_size})
</#macro>
