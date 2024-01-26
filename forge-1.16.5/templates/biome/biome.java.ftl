<#--
 # MCreator (https://mcreator.net/)
 # Copyright (C) 2012-2020, Pylo
 # Copyright (C) 2020-2023, Pylo, opensource contributors
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
<#assign hasConfiguredFeatures = false/>
package ${package}.world.biome;

import net.minecraftforge.common.BiomeManager;
import net.minecraft.sounds.SoundEvent;

public class ${name}Biome extends Biome {

	private static final ConfiguredSurfaceBuilder<?> SURFACE_BUILDER = SurfaceBuilder.DEFAULT.func_242929_a(new SurfaceBuilderConfig(
            ${mappedBlockToBlockStateCode(data.groundBlock)},
            ${mappedBlockToBlockStateCode(data.undergroundBlock)},
            ${mappedBlockToBlockStateCode(data.getUnderwaterBlock())}));

    public static Biome createBiome() {
            BiomeAmbience effects = new BiomeAmbience.Builder()
                .setFogColor(${data.airColor?has_content?then(data.airColor.getRGB(), 12638463)})
                .setWaterColor(${data.waterColor?has_content?then(data.waterColor.getRGB(), 4159204)})
                .setWaterFogColor(${data.waterFogColor?has_content?then(data.waterFogColor.getRGB(), 329011)})
                .withSkyColor(${data.airColor?has_content?then(data.airColor.getRGB(), 7972607)})
                .withFoliageColor(${data.foliageColor?has_content?then(data.foliageColor.getRGB(), 10387789)})
                .withGrassColor(${data.grassColor?has_content?then(data.grassColor.getRGB(), 9470285)})
                <#if data.ambientSound?has_content && data.ambientSound.getMappedValue()?has_content>
                    .setAmbientSound(new SoundEvent(new ResourceLocation("${data.ambientSound}")))
                </#if>
                <#if data.moodSound?has_content && data.moodSound.getMappedValue()?has_content>
                    .setMoodSound(new MoodSoundAmbience(new SoundEvent(new ResourceLocation("${data.moodSound}")), ${data.moodSoundDelay}, 8, 2))
                </#if>
                <#if data.additionsSound?has_content && data.additionsSound.getMappedValue()?has_content>
                    .setAdditionsSound(new SoundAdditionsAmbience(new SoundEvent(new ResourceLocation("${data.additionsSound}")), 0.0111D))
                </#if>
                <#if data.music?has_content && data.music.getMappedValue()?has_content>
                    .setMusic(new BackgroundMusicSelector(new SoundEvent(new ResourceLocation("${data.music}")), 12000, 24000, true))
                </#if>
                <#if data.spawnParticles>
                    .setParticle(new ParticleEffectAmbience(${data.particleToSpawn}, ${data.particlesProbability / 100}f))
                </#if>
                .build();

        BiomeGenerationSettings.Builder biomeGenerationSettings = new BiomeGenerationSettings.Builder().withSurfaceBuilder(SURFACE_BUILDER);

        <#if data.spawnStronghold>
            biomeGenerationSettings.withStructure(StructureFeatures.STRONGHOLD);
        </#if>

        <#if data.spawnMineshaft>
            biomeGenerationSettings.withStructure(StructureFeatures.MINESHAFT);
        </#if>

        <#if data.spawnMineshaftMesa>
            biomeGenerationSettings.withStructure(StructureFeatures.MINESHAFT_BADLANDS);
        </#if>

        <#if data.spawnPillagerOutpost>
            biomeGenerationSettings.withStructure(StructureFeatures.PILLAGER_OUTPOST);
        </#if>

        <#if data.villageType != "none">
            biomeGenerationSettings.withStructure(StructureFeatures.VILLAGE_${data.villageType?upper_case});
        </#if>

        <#if data.spawnWoodlandMansion>
            biomeGenerationSettings.withStructure(StructureFeatures.MANSION);
        </#if>

        <#if data.spawnJungleTemple>
            biomeGenerationSettings.withStructure(StructureFeatures.JUNGLE_PYRAMID);
        </#if>

        <#if data.spawnDesertPyramid>
            biomeGenerationSettings.withStructure(StructureFeatures.DESERT_PYRAMID);
        </#if>

        <#if data.spawnSwampHut>
            biomeGenerationSettings.withStructure(StructureFeatures.SWAMP_HUT);
        </#if>

        <#if data.spawnIgloo>
            biomeGenerationSettings.withStructure(StructureFeatures.IGLOO);
        </#if>

        <#if data.spawnOceanMonument>
            biomeGenerationSettings.withStructure(StructureFeatures.MONUMENT);
        </#if>

        <#if data.spawnShipwreck>
            biomeGenerationSettings.withStructure(StructureFeatures.SHIPWRECK);
        </#if>

        <#if data.spawnShipwreckBeached>
            biomeGenerationSettings.withStructure(StructureFeatures.SHIPWRECH_BEACHED);
        </#if>

        <#if data.spawnBuriedTreasure>
            biomeGenerationSettings.withStructure(StructureFeatures.BURIED_TREASURE);
        </#if>

        <#if data.oceanRuinType != "NONE">
            biomeGenerationSettings.withStructure(StructureFeatures.OCEAN_RUIN_${data.oceanRuinType});
        </#if>

        <#if data.spawnNetherBridge>
            biomeGenerationSettings.withStructure(StructureFeatures.FORTRESS);
        </#if>

        <#if data.spawnNetherFossil>
            biomeGenerationSettings.withStructure(StructureFeatures.NETHER_FOSSIL);
        </#if>

        <#if data.spawnBastionRemnant>
            biomeGenerationSettings.withStructure(StructureFeatures.BASTION_REMNANT);
        </#if>

        <#if data.spawnEndCity>
            biomeGenerationSettings.withStructure(StructureFeatures.END_CITY);
        </#if>

        <#if data.spawnRuinedPortal != "NONE">
          <#if data.spawnRuinedPortal == "STANDARD">
            biomeGenerationSettings.withStructure(StructureFeatures.RUINED_PORTAL);
          <#else>
            biomeGenerationSettings.withStructure(StructureFeatures.RUINED_PORTAL_${data.spawnRuinedPortal});
          </#if>
        </#if>

        <#if (data.treesPerChunk > 0)>
        	<#assign ct = data.treeType == data.TREES_CUSTOM>
            <#assign hasConfiguredFeatures = true/>

        	<#if data.vanillaTreeType == "Big trees">
        	biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
				Feature.TREE.withConfiguration((new BaseTreeFeatureConfig.Builder(
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.JUNGLE_LOG.getDefaultState()")}),
                    new MegaJungleTrunkPlacer(${ct?then([data.minHeight, 32]?min, 10)}, 2, 19),
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.JUNGLE_LEAVES.getDefaultState()")}),
                    new SimpleBlockStateProvider(Blocks.OAK_SAPLING.getDefaultState()),
                    new JungleFoliagePlacer(FeatureSpread.func_242252_a(2), FeatureSpread.func_242252_a(0), 2),
                    new TwoLayerFeature(1, 1, 2)))
                    <#if data.hasVines() || data.hasFruits()>
                    	<@vinesAndFruits/>
                    <#else>
                    	.setIgnoreVines()
                    </#if>
            	.build())
            	.withPlacement(Features.Decorators.HEIGHTMAP_PLACEMENT)
            	.withPlacement(Placement.COUNT_EXTRA.configure(new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1))));
        	<#elseif data.vanillaTreeType == "Savanna trees">
        	biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
                Feature.TREE.withConfiguration((new BaseTreeFeatureConfig.Builder(
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.ACACIA_LOG.getDefaultState()")}),
                    new ForkyTrunkPlacer(${ct?then([data.minHeight, 32]?min, 5)}, 2, 2),
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.ACACIA_LEAVES.getDefaultState()")}),
                    new SimpleBlockStateProvider(Blocks.ACACIA_SAPLING.getDefaultState()),
                    new AcaciaFoliagePlacer(FeatureSpread.func_242252_a(2), FeatureSpread.func_242252_a(0)),
                    new TwoLayerFeature(1, 0, 2)))
                    <#if data.hasVines() || data.hasFruits()>
                    	<@vinesAndFruits/>
                    <#else>
                    	.setIgnoreVines()
                    </#if>
            	.build())
            	.withPlacement(Features.Decorators.HEIGHTMAP_PLACEMENT)
            	.withPlacement(Placement.COUNT_EXTRA.configure(new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1))));
        	<#elseif data.vanillaTreeType == "Mega pine trees">
        	biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
				Feature.TREE.withConfiguration((new BaseTreeFeatureConfig.Builder(
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.SPRUCE_LOG.getDefaultState()")}),
                    new GiantTrunkPlacer(${ct?then([data.minHeight, 32]?min, 13)}, 2, 14),
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.SPRUCE_LEAVES.getDefaultState()")}),
                    new SimpleBlockStateProvider(Blocks.SPRUCE_SAPLING.getDefaultState()),
                    new MegaPineFoliagePlacer(FeatureSpread.func_242252_a(0), FeatureSpread.func_242252_a(0), FeatureSpread.func_242253_a(3, 4)),
                    new TwoLayerFeature(1, 1, 2)))
                    <#if data.hasVines() || data.hasFruits()>
                    	<@vinesAndFruits/>
                    </#if>
            	.build())
            	.withPlacement(Features.Decorators.HEIGHTMAP_PLACEMENT)
            	.withPlacement(Placement.COUNT_EXTRA.configure(new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1))));
        	<#elseif data.vanillaTreeType == "Mega spruce trees">
        	biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
				Feature.TREE.withConfiguration((new BaseTreeFeatureConfig.Builder(
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.SPRUCE_LOG.getDefaultState()")}),
                    new GiantTrunkPlacer(${ct?then([data.minHeight, 32]?min, 13)}, 2, 14),
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.SPRUCE_LEAVES.getDefaultState()")}),
                    new SimpleBlockStateProvider(Blocks.SPRUCE_SAPLING.getDefaultState()),
                    new MegaPineFoliagePlacer(FeatureSpread.func_242252_a(0), FeatureSpread.func_242252_a(0), FeatureSpread.func_242253_a(13, 4)),
                    new TwoLayerFeature(1, 1, 2)))
                    .setDecorators(ImmutableList.of(new AlterGroundDecorator(new SimpleBlockStateProvider(Blocks.PODZOL.getDefaultState()))))
                    <#if data.hasVines() || data.hasFruits()>
                    	<@vinesAndFruits/>
                    </#if>
            	.build())
            	.withPlacement(Features.Decorators.HEIGHTMAP_PLACEMENT)
            	.withPlacement(Placement.COUNT_EXTRA.configure(new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1))));
        	<#elseif data.vanillaTreeType == "Birch trees">
        	biomeGenerationSettings.withFeature(GenerationStep.Decoration.VEGETAL_DECORATION,
				Feature.TREE.withConfiguration((new BaseTreeFeatureConfig.Builder(
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.BIRCH_LOG.getDefaultState()")}),
                    new StraightTrunkPlacer(${ct?then([data.minHeight, 32]?min, 5)}, 2, 0),
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.BIRCH_LEAVES.getDefaultState()")}),
                    new SimpleBlockStateProvider(Blocks.BIRCH_SAPLING.getDefaultState()),
                    new BlobFoliagePlacer(FeatureSpread.func_242252_a(2), FeatureSpread.func_242252_a(0), 3),
                    new TwoLayerFeature(1, 0, 1)))
                    <#if data.hasVines() || data.hasFruits()>
                    	<@vinesAndFruits/>
                    <#else>
                    	.setIgnoreVines()
                    </#if>
            	.build())
            	.withPlacement(Features.Decorators.HEIGHTMAP_PLACEMENT)
            	.withPlacement(Placement.COUNT_EXTRA.configure(new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1))));
        	<#else>
        	biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
				Feature.TREE.withConfiguration((new BaseTreeFeatureConfig.Builder(
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeStem), "Blocks.OAK_LOG.getDefaultState()")}),
                    new StraightTrunkPlacer(${ct?then([data.minHeight, 32]?min, 4)}, 2, 0),
                    new SimpleBlockStateProvider(${ct?then(mappedBlockToBlockStateCode(data.treeBranch), "Blocks.OAK_LEAVES.getDefaultState()")}),
                    new SimpleBlockStateProvider(Blocks.OAK_SAPLING.getDefaultState()),
                    new BlobFoliagePlacer(FeatureSpread.func_242252_a(2), FeatureSpread.func_242252_a(0), 3),
                    new TwoLayerFeature(1, 0, 1)))
                    <#if data.hasVines() || data.hasFruits()>
                    	<@vinesAndFruits/>
                    <#else>
                    	.setIgnoreVines()
                    </#if>
            	.build())
            	.withPlacement(Features.Decorators.HEIGHTMAP_PLACEMENT)
            	.withPlacement(Placement.COUNT_EXTRA.configure(new AtSurfaceWithExtraConfig(${data.treesPerChunk}, 0.1F, 1))));
        	</#if>
        </#if>

        <#if (data.grassPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
				Feature.RANDOM_PATCH.withConfiguration(Features.Configs.GRASS_PATCH_CONFIG)
                .withPlacement(Features.Decorators.PATCH_PLACEMENT)
                .withPlacement(Placement.COUNT_NOISE.configure(new NoiseDependant(-0.8D, 5, ${data.grassPerChunk}))));
        </#if>

        <#if (data.seagrassPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.SEAGRASS.withConfiguration(new ProbabilityConfig(0.3F))
                .func_242731_b(${data.seagrassPerChunk})
                .withPlacement(Features.Placements.SEAGRASS_DISK_PLACEMENT));
        </#if>

        <#if (data.flowersPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.FLOWER.withConfiguration(Features.Configs.NORMAL_FLOWER_CONFIG)
                .withPlacement(Features.Placements.VEGETATION_PLACEMENT)
                .withPlacement(Features.Placements.HEIGHTMAP_PLACEMENT)
                .func_242731_b(${data.flowersPerChunk}));
        </#if>

        <#if (data.mushroomsPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.RANDOM_PATCH.withConfiguration((new BlockClusterFeatureConfig.Builder(
                new SimpleBlockStateProvider(Blocks.BROWN_MUSHROOM.getDefaultState()), SimpleBlockPlacer.PLACER))
                .tries(${data.mushroomsPerChunk}).func_227317_b_().build()));
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.RANDOM_PATCH.withConfiguration((new BlockClusterFeatureConfig.Builder(
                new SimpleBlockStateProvider(Blocks.RED_MUSHROOM.getDefaultState()), SimpleBlockPlacer.PLACER))
                .tries(${data.mushroomsPerChunk}).func_227317_b_().build()));
        </#if>

        <#if (data.bigMushroomsChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.HUGE_BROWN_MUSHROOM.withConfiguration(new BigMushroomFeatureConfig(
                new SimpleBlockStateProvider(Blocks.BROWN_MUSHROOM_BLOCK.getDefaultState().with(HugeMushroomBlock.UP, Boolean.TRUE).with(HugeMushroomBlock.DOWN, Boolean.FALSE)),
                new SimpleBlockStateProvider(Blocks.MUSHROOM_STEM.getDefaultState().with(HugeMushroomBlock.UP, Boolean.FALSE)
                .with(HugeMushroomBlock.DOWN, Boolean.FALSE)), ${data.bigMushroomsChunk})));
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.HUGE_RED_MUSHROOM.withConfiguration(new BigMushroomFeatureConfig(
                new SimpleBlockStateProvider(Blocks.RED_MUSHROOM_BLOCK.getDefaultState().with(HugeMushroomBlock.DOWN, Boolean.FALSE)),
                new SimpleBlockStateProvider(Blocks.MUSHROOM_STEM.getDefaultState().with(HugeMushroomBlock.UP, Boolean.FALSE)
                .with(HugeMushroomBlock.DOWN, Boolean.FALSE)), ${data.bigMushroomsChunk})));
        </#if>

        <#if (data.sandPatchesPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.DISK.withConfiguration(new SphereReplaceConfig(Blocks.SAND.getDefaultState(), FeatureSpread.func_242253_a(2, 4), 2,
                ImmutableList.of(${mappedBlockToBlockStateCode(data.groundBlock)}, ${mappedBlockToBlockStateCode(data.undergroundBlock)})))
                .withPlacement(Features.Placements.SEAGRASS_DISK_PLACEMENT).func_242731_b(${data.sandPatchesPerChunk}));
        </#if>

        <#if (data.gravelPatchesPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.DISK.withConfiguration(new SphereReplaceConfig(Blocks.GRAVEL.getDefaultState(), FeatureSpread.func_242253_a(2, 3), 2,
                ImmutableList.of(${mappedBlockToBlockStateCode(data.groundBlock)}, ${mappedBlockToBlockStateCode(data.undergroundBlock)})))
                .withPlacement(Features.Placements.SEAGRASS_DISK_PLACEMENT).func_242731_b(${data.gravelPatchesPerChunk}));
        </#if>

        <#if (data.reedsPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.RANDOM_PATCH.withConfiguration(Features.Configs.SUGAR_CANE_PATCH_CONFIG)
                .withPlacement(Features.Placements.PATCH_PLACEMENT).func_242731_b(${data.reedsPerChunk}));
        </#if>

        <#if (data.cactiPerChunk > 0)>
            <#assign hasConfiguredFeatures = true/>
            biomeGenerationSettings.withFeature(GenerationStage.Decoration.VEGETAL_DECORATION,
			    Feature.RANDOM_PATCH.withConfiguration((new BlockClusterFeatureConfig.Builder(
                new SimpleBlockStateProvider(Blocks.CACTUS.getDefaultState()), new ColumnBlockPlacer(1, 2)))
                .tries(${data.cactiPerChunk}).func_227317_b_().build()));
        </#if>

        <#list data.defaultFeatures as defaultFeature>
        	<#assign mfeat = generator.map(defaultFeature, "defaultfeatures")>
        	<#if mfeat != "null">
            DefaultBiomeFeatures.with${mfeat}(biomeGenerationSettings);
        	</#if>
        </#list>

        MobSpawnInfo.Builder mobSpawnInfo = new MobSpawnInfo.Builder().isValidSpawnBiomeForPlayer();
        <#list data.spawnEntries as spawnEntry>
			<#assign entity = generator.map(spawnEntry.entity.getUnmappedValue(), "entities", 1)!"null">
			<#if entity != "null">
			mobSpawnInfo.withSpawner(${generator.map(spawnEntry.spawnType, "mobspawntypes")},
				new MobSpawnInfo.Spawners(${entity}, ${spawnEntry.weight}, ${spawnEntry.minGroup}, ${spawnEntry.maxGroup}));
			</#if>
        </#list>

        return new Biome.Builder()
            .precipitation(Biome.RainType.<#if (data.rainingPossibility > 0)><#if (data.temperature > 0.15)>RAIN<#else>SNOW</#if><#else>NONE</#if>)
            .category(Biome.Category.NONE)
            .depth(${data.baseHeight}f)
            .scale(${data.heightVariation}f)
            .temperature(${data.temperature}f)
            .downfall(${data.rainingPossibility}f)
            .setEffects(effects)
            .withMobSpawnSettings(mobSpawnInfo.copy())
            .withGenerationSettings(biomeGenerationSettings.build())
            .build();
    }

    public static void init() {
		Registry.register(WorldGenRegistries.CONFIGURED_SURFACE_BUILDER, new ResourceLocation(${JavaModName}.MODID, "${registryname}"), SURFACE_BUILDER);

        <#if hasConfiguredFeatures>
        CONFIGURED_FEATURES.forEach((resourceLocation, configuredFeature) -> Registry.register(WorldGenRegistries.CONFIGURED_FEATURE, resourceLocation, configuredFeature));
        </#if>

        <#if data.spawnBiome>
            BiomeManager.addBiome(
				BiomeManager.BiomeType.
				<#if (data.temperature < -0.25)>
					ICY
				<#elseif (data.temperature > -0.25) && (data.temperature <= 0.15)>
					COOL
				<#elseif (data.temperature > 0.15) && (data.temperature <= 1.0)>
					WARM
				<#elseif (data.temperature > 1.0)>
					DESERT
				</#if>,
				new BiomeManager.BiomeEntry(RegistryKey.getOrCreateKey(Registry.BIOME_KEY, WorldGenRegistries.BIOME.getKey(${JavaModName}Biomes.${registryname?upper_case})), ${data.biomeWeight})
			);
        </#if>

    <#if hasConfiguredFeatures>
    private static final Map<ResourceLocation, ConfiguredFeature<?, ?>> CONFIGURED_FEATURES = new HashMap<>();

    private static ConfiguredFeature<?, ?> register(String name, ConfiguredFeature<?, ?> configuredFeature) {
		CONFIGURED_FEATURES.put(new ResourceLocation(${JavaModName}.MODID, name + "_${registryname}"), configuredFeature);
    	return configuredFeature;
    }
    </#if>
    }
}
<#macro vinesAndFruits>
.setDecorators(ImmutableList.of(
	<#if data.hasVines()>
		${name}LeaveDecorator.INSTANCE,
		${name}TrunkDecorator.INSTANCE
	</#if>

	<#if data.hasFruits()>
	    <#if data.hasVines()>,</#if>
        ${name}FruitDecorator.INSTANCE
	</#if>
))
</#macro>
<#-- @formatter:on -->
