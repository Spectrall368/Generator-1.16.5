<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2025, Pylo, opensource contributors
 #
 # This program is free software: you can redistribute it and/or modify
 # it under the terms of the GNU General Public License as published by
 # the Free Software Foundation, either version 3 of the License, or
 # (at your option) any later version.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <https://www.gnu.org/licenses/>.
 #
 # Additional permission for code generator templates (*.ftl files)
 #
 # As a special exception, you may create a larger work that contains part or
 # all of the MCreator code generator templates (*.ftl files) and distribute
 # that work under terms of your choice, so long as that work isn't itself a
 # template for code generation. Alternatively, if you modify or redistribute
 # the template itself, you may (at your option) remove this special exception,
 # which will cause the template and the resulting code generator output files
 # to be licensed under the GNU General Public License without this special
 # exception.
-->

<#-- @formatter:off -->
<#include "../procedures.java.ftl">
<#include "../mcitems.ftl">
package ${package}.world.features.plants;
<#assign cond = false>
<#if data.restrictionBiomes?has_content>
	<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
	    <#assign biomeName = fixNamespace(restrictionBiome)>
        <#if biomeName == "#minecraft:is_overworld" || biomeName == "#minecraft:is_nether" || biomeName == "#minecraft:is_end">
			<#assign cond = true>
			 <#break>
		</#if>
	</#list>
</#if>

public class ${name}Feature extends <#if data.plantType == "normal" && data.generationType == "Flower">DefaultFlowers<#else>RandomPatch</#if>Feature {
    private static ${name}Feature INSTANCE = null;
  	private static ConfiguredFeature<?, ?> CONFIGURED_FEATURE = null;

	public ${name}Feature() {
		super(BlockClusterFeatureConfig.field_236587_a_);
	}

	public static Feature<?> feature() {
		INSTANCE = new ${name}Feature();
		CONFIGURED_FEATURE = INSTANCE.withConfiguration(
                new BlockClusterFeatureConfig.Builder(new SimpleBlockStateProvider(${JavaModName}Blocks.${REGISTRYNAME}.get().getDefaultState()),
                    <#if data.plantType == "double">DoublePlantBlockPlacer.PLACER
                    <#elseif data.plantType == "normal">SimpleBlockPlacer.PLACER
                    <#else>new ColumnBlockPlacer(2, 2)</#if>)
                    <#if data.plantType == "growapable">.xspread(4).yspread(0).zspread(4).func_227317_b_()</#if>
                    <#if data.plantType == "double" && data.generationType == "Flower">.func_227317_b_()</#if>
                    .tries(${data.patchSize}).build())
                    .func_242731_b(${data.frequencyOnChunks})
                    <#if data.generationType == "Flower" || data.plantType == "growapable">
                    .chance(32)</#if>
                    .square()
                    <#if data.generateAtAnyHeight>
                    .range(128)
                    <#else>
                    .withPlacement(Features.Placements.<#if !(data.generationType == "Grass" || data.plantType == "growapable")>BAMBOO_PLACEMENT<#else>FLOWER_TALL_GRASS_PLACEMENT</#if>)
                    </#if>;

        Registry.register(WorldGenRegistries.CONFIGURED_FEATURE, new ResourceLocation("${modid}:${registryname}"), CONFIGURED_FEATURE);
		return INSTANCE;
	}

	public static ConfiguredFeature<?, ?> configuredFeature() {
	    if (CONFIGURED_FEATURE == null)
	        feature();

		return CONFIGURED_FEATURE;
	}

	<#if data.restrictionBiomes?has_content && cond>
	@Override public boolean generate(ISeedReader world, ChunkGenerator generator, Random random, BlockPos pos, BlockClusterFeatureConfig config) {
		    RegistryKey<World> dimensionType = world.getWorld().getDimensionKey();
			boolean dimensionCriteria = false;
			<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
	            <#assign biomeName = fixNamespace(restrictionBiome)>
				<#if biomeName == "#minecraft:is_overworld">
				    if(dimensionType == World.OVERWORLD)
					    dimensionCriteria = true;
				<#elseif biomeName == "#minecraft:is_nether">
				    if(dimensionType == World.THE_NETHER)
						dimensionCriteria = true;
				<#else>
					if(dimensionType == World.THE_END)
			    		dimensionCriteria = true;
				</#if>
	    	</#list>

			if(!dimensionCriteria)
			    return false;

		return super.generate(world, generator, random, pos, config);
	}
	</#if>

	public static final Set<ResourceLocation> GENERATE_BIOMES =
	<#if data.restrictionBiomes?has_content && !cond>
	ImmutableSet.of(
		<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
		    <#assign expandedBiomes = expandBiomeTag(restrictionBiome)>
		    <#list expandedBiomes as expandedBiome>
			new ResourceLocation("${expandedBiome}")<#sep>,
		    </#list><#sep>,
        </#list>
	)
	<#else>
	null
	</#if>;
}
<#-- @formatter:on -->
<#function expandBiomeTag biomeTag>
    <#local result = []>

    <#if biomeTag?contains("#")>
        <#local biomeName = fixNamespace(biomeTag)>
        <#local tagKey = "BIOMES:" + biomeName?substring(1)>

        <#local tagFound = false>
        <#list w.getWorkspace().getTagElements()?keys as tagElement>
            <#if tagElement.toString().replace("mod:", modid + ":") == tagKey>
                <#local tagFound = true>
                <#local biomeValues = w.getWorkspace().getTagElements().get(tagElement)>
                <#list biomeValues as biomeValue>
                    <#if biomeValue?starts_with("#")>
                        <#local expandedSubValues = expandBiomeTag(biomeValue?replace("mod:", modid + ":"))>
                        <#list expandedSubValues as expandedSubValue>
                            <#local result = result + [expandedSubValue]>
                        </#list>
                    <#else>
                        <#local result = result + [generator.map(biomeValue, "biomes")]>
                    </#if>
                </#list>
                <#break>
            </#if>
        </#list>

        <#if !tagFound>
            <#local result = result + [biomeName?substring(1)]>
        </#if>
    <#else>
        <#local result = result + [biomeTag]>
    </#if>

    <#return result>
</#function>
<#function fixNamespace input>
    <#assign noHash = input?starts_with("#")?then(input?substring(1), input)/>

    <#if noHash?contains(":")>
        <#return input>
    <#else>
        <#assign result = "minecraft:" + noHash />
        <#return input?starts_with("#")?then("#" + result, result)/>
    </#if>
</#function>
