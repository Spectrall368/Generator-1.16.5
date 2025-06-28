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
package ${package}.world.features.ores;
<#if data.maxGenerateHeight gt 256>
	<#assign maxGenerateHeight = 256>
<#elseif data.maxGenerateHeight lt 0>
	<#assign maxGenerateHeight = 0>
<#else>
	<#assign maxGenerateHeight = data.maxGenerateHeight>
</#if>
<#if data.minGenerateHeight gt 256>
	<#assign minGenerateHeight = 256>
<#elseif data.minGenerateHeight lt 0>
	<#assign minGenerateHeight = 0>
<#else>
	<#assign minGenerateHeight = data.minGenerateHeight>
</#if>
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

public class ${name}Feature extends OreFeature {
    private static final ${name}Feature INSTANCE = new ${name}Feature();
  	private static ConfiguredFeature<?, ?> CONFIGURED_FEATURE = feature.withConfiguration(new OreFeatureConfig(${name}FeatureRuleTest.INSTANCE, ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState(), ${data.frequencyOnChunk}))
    <#if data.generationShape == "UNIFORM">
        .withPlacement(Placement.RANGE.configure(new TopSolidRangeConfig(${minGenerateHeight}, ${minGenerateHeight}, <#if maxGenerateHeight != minGenerateHeight><#else> 1 + </#if>${maxGenerateHeight})))
	<#else>
        <#assign averageHeight = (maxGenerateHeight + minGenerateHeight) / 2>
        <#assign averageHeight = averageHeight?int>
		.withPlacement(Placement.DEPTH_AVERAGE.configure(new DepthAverageConfig(${averageHeight}, ${averageHeight})))
	</#if>
	.square().func_242731_b(${data.frequencyPerChunks});
	public static IRuleTestType<${name}FeatureRuleTest> CUSTOM_MATCH = null;

	public ${name}Feature() {
		super(OreFeatureConfig.CODEC);
	}

	public static ConfiguredFeature<?, ?> configuredFeature() {
		return CONFIGURED_FEATURE;
	}

	public static class ${name}FeatureRuleTest extends RuleTest {
		public static final ${name}FeatureRuleTest INSTANCE = new ${name}FeatureRuleTest();
	  	public static final Codec<${name}FeatureRuleTest> CODEC = Codec.unit(() -> INSTANCE);

	  	public boolean test(BlockState blockAt, Random random) {
				boolean blockCriteria = false;
				<#list data.blocksToReplace as replacementBlock>
			        <#if replacementBlock.getUnmappedValue().startsWith("TAG:")>
				    	if (BlockTags.getCollection().getOrCreate(new ResourceLocation("${replacementBlock.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":").replace("stone_ore_replaceables", "minecraft:overworld_carver_replaceables")}")).contains(blockAt.getBlock()))
				    	<#if replacementBlock.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":") == "stone_ore_replaceables">
				    	    blockCriteria = true;
				    	if (blockAt.getBlock() == Blocks.STONE || blockAt.getBlock() == Blocks.GRANITE || blockAt.getBlock() == Blocks.DIORITE || blockAt.getBlock() == Blocks.ANDESITE || blockAt.getBlock() == Blocks.NETHERRACK)
                        </#if>
					<#elseif replacementBlock.getMappedValue(1).startsWith("#")>
					    if (BlockTags.getCollection().getOrCreate(new ResourceLocation("${replacementBlock.getMappedValue(1).replace("#", "")}")).contains(blockAt.getBlock()))
					<#else>
						if(blockAt == ${mappedBlockToBlockStateCode(replacementBlock)})
					</#if>
						blockCriteria = true;
				</#list>
				return blockCriteria;
	  	}

	  	protected IRuleTestType<?> getType() {
	    		return CUSTOM_MATCH;
	  	}
	}

    <#if data.restrictionBiomes?has_content && cond>
	@Override public boolean generate(ISeedReader world, ChunkGenerator generator, Random random, BlockPos pos, OreFeatureConfig config) {
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


	    return super.generate(world, generator, random, pos, config);
	}
    </#if>

	public static void addFeatureToBiomes(BiomeLoadingEvent event) {
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

			event.getGeneration().getFeatures(GenerationStage.Decoration.UNDERGROUND_ORES).add(() -> ${name}Feature.configuredFeature());
	}
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