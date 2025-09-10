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
<#assign placementPattern = r'\$([^$]+)\$'>
<#assign placementMatches = placementcode?matches(placementPattern)>
<#assign placementHardcodedElements = []>
<#list placementMatches as match>
    <#assign placementHardcodedElements = placementHardcodedElements + [match?groups[1]]>
</#list>
<#assign nonHardcodedPlacement = placementcode?replace(placementPattern, "", "r")>
<#assign configurationMatches = configurationcode?matches(placementPattern)>
<#assign configurationHardcodedElements = []>
<#list configurationMatches as match>
    <#assign configurationHardcodedElements = configurationHardcodedElements + [match?groups[1]]>
</#list>
<#assign nonHardcodedConfiguration = configurationcode?replace(placementPattern, "", "r")>
<#assign allHardcodedElements = placementHardcodedElements + configurationHardcodedElements>
<#compress>
public class ${name}Feature extends ${generator.map(featuretype, "features")} {
	private static ${name}Feature FEATURE = null;
	private static ConfiguredFeature<?, ?> CONFIGURED_FEATURE = null;

	public ${name}Feature() {
		super(${generator.map(featuretype, "features", 2)});
	}

	public static Feature<?> feature() {
	    Random random = new Random();
		FEATURE = new ${name}Feature();
		CONFIGURED_FEATURE = <#if featuretype == "configured_feature_reference">${nonHardcodedConfiguration}<#else>FEATURE.withConfiguration(<#if nonHardcodedConfiguration == "">NoFeatureConfig.field_236559_b_<#else>${nonHardcodedConfiguration}</#if>)</#if><#if data.hasPlacedFeature()>${nonHardcodedPlacement}</#if>;

		Registry.register(WorldGenRegistries.CONFIGURED_FEATURE, new ResourceLocation("${modid}:${registryname}"), CONFIGURED_FEATURE);

		return FEATURE;
	}

	public static ConfiguredFeature<?, ?> configuredFeature() {
	    if (CONFIGURED_FEATURE == null)
	        feature();

		return CONFIGURED_FEATURE;
	}

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

    <#if data.restrictionBiomes?has_content && cond>
	private final Set<RegistryKey<DimensionType>> generateDimensions = ImmutableSet.of(
			<#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
	        <#assign biomeName = fixNamespace(restrictionBiome)>
			<#if biomeName == "#minecraft:is_overworld">
				DimensionType.OVERWORLD
			<#elseif biomeName == "#minecraft:is_nether">
				DimensionType.THE_NETHER
			<#else>
				DimensionType.THE_END
			</#if><#sep>,
		</#list>
	);
	</#if>

	<#if featuretype == "feature_simple_block" || (data.hasPlacedFeature() && ((data.restrictionBiomes?has_content && cond) || data.hasGenerationConditions() || (allHardcodedElements?size > 0)))>
	@Override public boolean generate(ISeedReader world, ChunkGenerator generator, Random random, BlockPos pos, ${configuration} config) {
		<#-- #4781 - we need to use WorldGenLevel instead of Level, or one can run incompatible procedures in condition -->
		BlockPos origin = pos;
		<#if data.restrictionBiomes?has_content && cond>
		if (!generateDimensions.contains(world.getWorld().getDimensionKey()))
			return false;
		</#if>

		<#if hasProcedure(data.generateCondition)>
		int x = origin.getX();
		int y = origin.getY();
		int z = origin.getZ();
		if (!<@procedureOBJToConditionCode data.generateCondition/>)
			return false;
		</#if>

		<#if data.hasPlacedFeature() && (allHardcodedElements?size > 0)>
            <#list allHardcodedElements as element>
            ${element}
            </#list>
		</#if>

		<#if featuretype == "feature_simple_block">
			BlockState state = config.state;
			if (state.isValidPosition(world, origin)) {
				if (state.getBlock() instanceof DoublePlantBlock) {
					if (!world.isAirBlock(origin.up()))
						return false;
					((DoublePlantBlock) state.getBlock()).placeAt(world, origin, 2);
				} else
					world.setBlockState(origin, config.state, 2);
				return true;
			}
			return false;
		<#else>
			return super.generate(world, generator, random, origin, config);
		</#if>
	}
	</#if>
}</#compress>
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