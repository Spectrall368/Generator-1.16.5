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
<#include "../mcitems.ftl">
package ${package}.world.features.plants;
<#assign featurename = "new DefaultFlowersFeature">
<#if data.plantType == "normal">
	<#if data.staticPlantGenerationType != "Flower">
	<#assign featurename = "new RandomPatchFeature">
	</#if>
<#elseif data.plantType == "growapable">
	<#assign featurename = "new Feature<BlockClusterFeatureConfig>">
<#else>
	<#assign featurename = "new RandomPatchFeature">
</#if>

@Mod.EventBusSubscriber public class ${name}Feature  {

	private static Feature<BlockClusterFeatureConfig> feature = null;
	private static ConfiguredFeature<?, ?> configuredFeature = null;

	@SubscribeEvent public void registerFeature(RegistryEvent.Register<Feature<?>> event) {
    		feature = ${featurename}(BlockClusterFeatureConfig.field_236587_a_) {
    		<#if data.staticPlantGenerationType == "Flower">
		@Override public BlockState getFlowerToPlace(Random random, BlockPos bp, BlockClusterFeatureConfig fc) {
			return ${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState();
		}
    		</#if>

		@Override public boolean generate(ISeedReader world, ChunkGenerator generator, Random random, BlockPos pos, BlockClusterFeatureConfig config) {
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
			if(dimensionType == RegistryKey.getOrCreateKey(Registry.WORLD_KEY, new ResourceLocation("${generator.getResourceLocationForModElement(worldType.toString().replace("CUSTOM:", ""))}")))
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

			<#if data.plantType == "growapable">
			int generated = 0;
			for(int j = 0; j < ${data.frequencyOnChunks}; ++j) {
				BlockPos blockpos = pos.add(random.nextInt(4) - random.nextInt(4), 0, random.nextInt(4) - random.nextInt(4));
				if (world.isAirBlock(blockpos)) {
					BlockPos blockpos1 = blockpos.down();
					int k = 1 + random.nextInt(random.nextInt(${data.growapableMaxHeight}) + 1);
					k = Math.min(${data.growapableMaxHeight}, k);
					for(int l = 0; l < k; ++l) {
						if (block.getDefaultState().isValidPosition(world, blockpos)) {
							world.setBlockState(blockpos.up(l), block.getDefaultState(), 2);
							generated++;
						}
					}
				}
			}
			return generated > 0;
			<#else>
			return super.generate(world, generator, random, pos, config);
			</#if>
		}
	};

	configuredFeature = feature.withConfiguration((new BlockClusterFeatureConfig.Builder(new SimpleBlockStateProvider(${JavaModName}Blocks.${data.getModElement().getRegistryNameUpper()}.get().getDefaultState()),
		new <#if data.plantType == "double">DoublePlant<#else>Simple</#if>BlockPlacer())).tries(${data.patchSize})
		<#if data.plantType == "double" && data.doublePlantGenerationType == "Flower">.func_227317_b_()</#if>.build())
		<#if (data.plantType == "normal" && data.staticPlantGenerationType == "Grass") || (data.plantType == "double" && data.doublePlantGenerationType == "Grass")>
		.withPlacement(Placement.COUNT_NOISE.configure(new NoiseDependant(-0.8, 0, ${data.frequencyOnChunks})))
		<#else>
			<#if data.plantType == "normal" || data.plantType == "double">
		.withPlacement(Features.Placements.VEGETATION_PLACEMENT).withPlacement(Features.Placements.HEIGHTMAP_PLACEMENT).func_242731_b(${data.frequencyOnChunks})
			<#else>
		.withPlacement(Features.Placements.PATCH_PLACEMENT).func_242731_b(${data.frequencyOnChunks})
			</#if>
		</#if>;

		event.getRegistry().register(feature.setRegistryName("${registryname}_plants"));
		Registry.register(WorldGenRegistries.CONFIGURED_FEATURE, new ResourceLocation("${modid}:${registryname}_plants"), configuredFeature);
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

	event.getGeneration().getFeatures(GenerationStage.Decoration.VEGETAL_DECORATION).add(() -> configuredFeature);
	}
}
<#-- @formatter:on -->
