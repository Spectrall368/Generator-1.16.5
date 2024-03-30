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
<#include "../mcitems.ftl">
<#include "../procedures.java.ftl">
package ${package}.world.features.lakes;

@Mod.EventBusSubscriber public class ${name}Feature {

  private static Feature<BlockStateFeatureConfig> feature = null;
  private static ConfiguredFeature<?, ?> configuredFeature = null;

  @SubscribeEvent public void registerFeature(RegistryEvent.Register<Feature<?>> event) {
    feature = new LakesFeature(BlockStateFeatureConfig.field_236455_a_) {
      @Override public boolean generate(ISeedReader world, ChunkGenerator generator, Random rand, BlockPos pos, BlockStateFeatureConfig config) {
        RegistryKey<World> dimensionType = world.getWorld().getDimensionKey();
        boolean dimensionCriteria = false;

        <#list data.spawnWorldTypes as worldType>
          <#if worldType=="Surface">
          if(dimensionType == World.OVERWORLD)
            dimensionCriteria = true;
          <#elseif worldType=="Nether">
          if(dimensionType == World.THE_NETHER)
            dimensionCriteria = true;
          <#elseif worldType=="End">
          if(dimensionType == World.THE_END)
            dimensionCriteria = true;
          <#else>
          if(dimensionType == RegistryKey.getOrCreateKey(Registry.WORLD_KEY,
            new ResourceLocation("${generator.getResourceLocationForModElement(worldType.toString().replace("CUSTOM:", ""))}")))
            dimensionCriteria = true;
          </#if>
        </#list>

        if(!dimensionCriteria)
          return false;

        <#if hasProcedure(data.generateCondition)>
        int x = pos.getX();
        int y = pos.getY();
        int z = pos.getZ();
        if (!<@procedureOBJToConditionCode data.generateCondition/>)
          return false;
        </#if>

        return super.generate(world, generator, rand, pos, config);
      }
		};

		configuredFeature = feature
		  .withConfiguration(new BlockStateFeatureConfig(${JavaModName}Fluids.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState()))
		  .withPlacement(Placement.WATER_LAKE.configure(new ChanceConfig(${data.frequencyOnChunks})));

		event.getRegistry().register(feature.setRegistryName("${registryname}_lakes"));
		Registry.register(WorldGenRegistries.CONFIGURED_FEATURE, new ResourceLocation("${modid}:${registryname}_lakes"), configuredFeature);
	}

	@SubscribeEvent public void addFeatureToBiomes(BiomeLoadingEvent event) {
	  <#if data.restrictionBiomes?has_content>
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

	  event.getGeneration().getFeatures(GenerationStage.Decoration.LOCAL_MODIFICATIONS).add(() -> configuredFeature);
	}
}
<#-- @formatter:on -->
