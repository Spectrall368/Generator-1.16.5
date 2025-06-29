<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2024, Pylo, opensource contributors
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
package ${package}.world.features;

<#assign configuration = generator.map(featuretype, "features", 1)>
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
<#compress>
public class ${name}Feature extends ${generator.map(featuretype, "features")} {
    private static final ${name}Feature INSTANCE = new ${name}Feature();
  	private static ConfiguredFeature<?, ?> CONFIGURED_FEATURE = feature.withConfiguration(${configurationcode?keep_before_last(".withCondition")})<#if data.hasPlacedFeature()><#if placementcode?contains("£")>${removeParts(placementcode)}<#else>${placementcode?remove_ending(",")}</#if></#if>;

	public ${name}Feature() {
		super(${generator.map(featuretype, "features", 2)});
	}

	public static ConfiguredFeature<?, ?> configuredFeature() {
		return CONFIGURED_FEATURE;
	}

    <#if configuration != "BaseTreeFeatureConfig">
	@Override public boolean generate(ISeedReader world, ChunkGenerator generator, Random random, BlockPos pos, ${configuration} config) {
	    BlockPos placePos = pos;
	    <#if data.restrictionBiomes?has_content && cond>
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
	    </#if>

		<#if placementcode != "" && data.hasPlacedFeature()>
		<#list extractParts(placementcode) as part>
		    ${part}
		</#list>
		</#if>

		<#if featuretype == "feature_random_patch_simple">
		if(!(${configurationcode?keep_after_last(".withCondition(")?keep_before_last(")")}))
			return false;
		</#if>

		<#if hasProcedure(data.generateCondition)>
			int x = placePos.getX();
			int y = placePos.getY();
			int z = placePos.getZ();
			if (!<@procedureOBJToConditionCode data.generateCondition/>)
				return false;
		</#if>

		<#if featuretype == "feature_simple_block">
			BlockState state = config.state;
			if (state.isValidPosition(world, placePos)) {
				if (state.getBlock() instanceof DoublePlantBlock) {
					if (!world.isAirBlock(placePos.up()))
						return false;
					((DoublePlantBlock) state.getBlock()).placeAt(world, placePos, 2);
				} else
					world.setBlockState(placePos, config.state, 2);
				return true;
			}
			return false;
		<#else>
			return super.generate(world, generator, random, placePos, config);
		</#if>
	}
	</#if>

	public static void addToBiomes(BiomeLoadingEvent event) {
	    <#if data.hasPlacedFeature()>
            <#if data.restrictionBiomes?has_content && !cond>
                boolean biomeCriteria = false;
                <#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
                    <#assign expandedBiomes = expandBiomeTag(restrictionBiome)>
                    <#list expandedBiomes as expandedBiome>
                        if (event.getName().equals(new ResourceLocation("${expandedBiome}")))
                            biomeCriteria = true;
                    </#list>
                </#list>

                if (!biomeCriteria)
                    return;
            </#if>

			event.getGeneration().getFeatures(GenerationStage.Decoration.${generator.map(data.generationStep, "generationsteps")}).add(() -> ${name}Feature.configuredFeature());
		</#if>
	}
}</#compress>
<#-- @formatter:on -->
<#function extractParts str>
    <#assign parts = []>
    <#assign remainingStr = str>

    <#list 1..str?length as i>
        <#assign startIndex = remainingStr?index_of('£')>
        <#if startIndex == -1>
            <#break>
        </#if>
        <#assign endIndex = remainingStr?index_of('^', startIndex)>
        <#if endIndex == -1>
            <#break>
        </#if>
        <#assign part = remainingStr?substring(startIndex + 1, endIndex)>
        <#assign parts = parts + [part]>
        <#assign remainingStr = remainingStr?substring(endIndex + 1)>
    </#list>

    <#return parts>
</#function>
<#function removeParts str>
    <#assign start = str?index_of("£")>

    <#if start == -1>
        <#return str>
    </#if>

    <#assign end = str?index_of("^", start)>

    <#if end == -1>
        <#return str>
    </#if>

    <#return removeParts(str?substring(0, start) + str?substring(end + 1))>
</#function>
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