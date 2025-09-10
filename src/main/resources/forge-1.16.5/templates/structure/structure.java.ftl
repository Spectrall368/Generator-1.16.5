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
package ${package}.world.structures;

public class ${name}Structure extends ${JavaModName}StructureBase {
    private static final StructureConfiguration INSTANCE = new StructureConfiguration(${[data.size, 7]?min}, StructureConfiguration.<#if data.useStartHeight>${data.startHeightProviderType?replace("UNIFORM", "UniformHeight")?replace("VERY_BIASED_TO_BOTTOM", "VeryBiasedToBottomHeight")?replace("BIASED_TO_BOTTOM", "BiasedToBottomHeight")?replace("TRAPEZOID", "TrapezoidHeight")}.of(${data.startHeightMin}, ${data.startHeightMax})<#else>ConstantHeight.of(0)</#if>, Optional.<#if !data.useStartHeight>of(Heightmap.Type.${data.surfaceDetectionType}<#else>empty(</#if>), ${data.maxDistanceFromCenter});

    public ${name}Structure() {
        super("${registryname}");
    }

    @Override
    public GenerationStage.Decoration getDecorationStage() {
        return GenerationStage.Decoration.${generator.map(data.generationStep, "generationsteps")};
    }

    <#if data.restrictionBiomes?has_content && !cond>
    @Override public Set<ResourceLocation> getBiomes() {
        return ImmutableSet.of(
            <#list w.filterBrokenReferences(data.restrictionBiomes) as restrictionBiome>
                <#assign expandedBiomes = expandBiomeTag(restrictionBiome)>
                <#list expandedBiomes as expandedBiome>
                new ResourceLocation("${expandedBiome}")<#sep>,
                </#list><#sep>,
            </#list>
        );
    }
	</#if>

    <#if data.restrictionBiomes?has_content && cond>
    @Override public Set<RegistryKey<DimensionType>> getDimensions() {
        return ImmutableSet.of(
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
	}
	</#if>

    @Override
    public StructureSeparationSettings getStructureFeatureConfiguration() {
        return new StructureSeparationSettings(${data.spacing}, ${data.separation}, ${thelper.randompositiveint(registryname)});
    }

    <#if data.terrainAdaptation != "none">
    @Override
    public boolean isSurroundedByLand() {
        return true;
    }
	</#if>

    @Override
    public StructureFeature<?, ?> configuredFeature() {
        return ${JavaModName}Structures.${REGISTRYNAME}.get().withConfiguration(INSTANCE);
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