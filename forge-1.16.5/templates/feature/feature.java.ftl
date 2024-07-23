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
<#assign isRulePresent = (configuration == "OreFeatureConfig")>
<#assign cond = false>
<#if data.restrictionBiomes?has_content>
	<#list data.restrictionBiomes as restrictionBiome>
		<#if restrictionBiome?contains(":is_")>
			<#assign cond = true>
			 <#break>
		</#if>
		<#break>
	</#list>
</#if>
<#compress>
@Mod.EventBusSubscriber public class ${name}Feature extends ${generator.map(featuretype, "features")} {
	private static Feature<${configuration}> feature = null;
	private static ConfiguredFeature<?, ?> configuredFeature = null;
	<#if isRulePresent>
	private static IRuleTestType<${name}FeatureRuleTest> CUSTOM_MATCH = null;

	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) private static class ${name}FeatureRuleTest extends RuleTest {
		static final ${name}FeatureRuleTest INSTANCE = new ${name}FeatureRuleTest();
	  	static final com.mojang.serialization.Codec<${name}FeatureRuleTest> codec = com.mojang.serialization.Codec.unit(() -> INSTANCE);

	  	public boolean test(BlockState blockAt, Random random) {
	    		boolean blockCriteria = false;
	    		return blockCriteria;
	  	}

	  	protected IRuleTestType<?> getType() {
	    		return CUSTOM_MATCH;
	  	}
	}
	</#if>
	
	public ${name}Feature() {
		super(${generator.map(featuretype, "features", 2)});
	}

	<#if configuration != "BaseTreeFeatureConfig">
	@Override public boolean generate(ISeedReader world, ChunkGenerator generator, Random random, BlockPos pos, ${configuration} config) {
		BlockPos placePos = pos;
		<#if data.restrictionBiomes?has_content && cond>
			RegistryKey<World> dimensionType = world.getWorld().getDimensionKey();
			boolean dimensionCriteria = false;
			<#list data.restrictionBiomes as restrictionBiome>
					<#if restrictionBiome == "#minecraft:is_overworld">
						if(dimensionType == World.OVERWORLD)
							dimensionCriteria = true;
					<#elseif restrictionBiome == "#minecraft:is_nether">
						if(dimensionType == World.THE_NETHER)
							dimensionCriteria = true;
					<#elseif restrictionBiome == "#minecraft:is_end">
						if(dimensionType == World.THE_END)
							dimensionCriteria = true;
					<#else>
						if(dimensionType == RegistryKey.getOrCreateKey(Registry.WORLD_KEY, new ResourceLocation("${modid}:${restrictionBiome?keep_after("is_")}")))
							dimensionCriteria = true;
					</#if>
			</#list>

			if(!dimensionCriteria)
				return false;
		</#if>

		<#list extractParts(placementcode) as part>
		    ${part}
		</#list>

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

	@Mod.EventBusSubscriber(modid = "${modid}", bus = Mod.EventBusSubscriber.Bus.MOD) private static class FeatureRegisterHandler {
		@SubscribeEvent public static void registerFeature(RegistryEvent.Register<Feature<?>> event) {
			Random random = new Random();
			feature = new ${name}Feature();
			configuredFeature = feature.withConfiguration(${configurationcode?keep_before_last(".withCondition")})${removeParts(placementcode)};

			event.getRegistry().register(feature.setRegistryName("${registryname}"));
			Registry.register(WorldGenRegistries.CONFIGURED_FEATURE, new ResourceLocation("${modid}:${registryname}"), configuredFeature);
		}
	}

	 @Mod.EventBusSubscriber(modid = "${modid}", bus = Mod.EventBusSubscriber.Bus.FORGE) private static class FeatureSpawningHandler {
		@SubscribeEvent public static void addFeatureToBiomes(BiomeLoadingEvent event) {
		<#if data.restrictionBiomes?has_content && !cond>
			boolean biomeCriteria = false;
			<#list data.restrictionBiomes as restrictionBiome>
				<#if restrictionBiome.canProperlyMap()>
				if (new ResourceLocation("${restrictionBiome}").equals(event.getName()))
					biomeCriteria = true;
				</#if>
			</#list>
			if (!biomeCriteria)
				return;
		</#if>
	
			event.getGeneration().getFeatures(GenerationStage.Decoration.${generator.map(data.generationStep, "generationsteps")}).add(() -> configuredFeature);
	        }
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
