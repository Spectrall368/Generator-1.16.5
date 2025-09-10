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
package ${package}.world.structures;

public class ${JavaModName}StructureBase extends Structure<StructureConfiguration> {
    private final String startPool;

    public ${JavaModName}StructureBase(String startPool) {
        super(StructureConfiguration.CODEC);
        this.startPool = startPool;
    }

    @Override
    public GenerationStage.Decoration getDecorationStage() {
        return null;
    }

    public Set<ResourceLocation> getBiomes() {
        return null;
    }

    public Set<RegistryKey<DimensionType>> getDimensions() {
        return null;
    }

    public StructureSeparationSettings getStructureFeatureConfiguration() {
        return null;
    }

    public boolean isSurroundedByLand() {
        return false;
    }

    public StructureFeature<?, ?> configuredFeature() {
        return null;
    }

    @Override
    public List<MobSpawnInfo.Spawners> getSpawnList() {
        return null;
    }

    @Override
    public List<MobSpawnInfo.Spawners> getCreatureSpawnList() {
        return null;
    }

    @Override
    public Structure.IStartFactory<StructureConfiguration> getStartFactory() {
        return (structure, chunkX, chunkZ, mutableBoundingBox, referenceIn, seedIn) -> {
           return new FeatureStart(this, chunkX, chunkZ, mutableBoundingBox, referenceIn, seedIn, startPool);
        };
    }

    protected static class FeatureStart extends MarginedStructureStart<StructureConfiguration> {
        private final String startPool;

        public FeatureStart(Structure<StructureConfiguration> structure, int chunkX, int chunkZ, MutableBoundingBox mutableBoundingBox, int referenceIn, long seedIn, String startPool) {
            super(structure, chunkX, chunkZ, mutableBoundingBox, referenceIn, seedIn);
            this.startPool = startPool;
        }

        @Override
        public void func_230364_a_(DynamicRegistries registryAccess, ChunkGenerator chunkGenerator, TemplateManager structureManager, int chunkX, int chunkZ, Biome biome, StructureConfiguration config) {
            int topLandY = config.startHeight().sample(rand);
            BlockPos blockpos = new BlockPos(chunkX * 16, topLandY, chunkZ * 16);

            VillageConfig jigsawConfig = new VillageConfig(() -> registryAccess.getRegistry(Registry.JIGSAW_POOL_KEY).getOrDefault(new ResourceLocation("${modid}:" + startPool)), config.maxDepth());

            JigsawPatternRegistry.func_244093_a();

            JigsawManager.IPieceFactory factory = AbstractVillagePiece::new;

            if (config.projectStartToHeightmap().isPresent()) {
                Rotation rotation = Rotation.randomRotation(rand);
                JigsawPiece element = jigsawConfig.func_242810_c().get().getRandomPiece(rand);
                MutableBoundingBox box = factory.create(structureManager, element, blockpos, element.getGroundLevelDelta(), rotation, element.getBoundingBox(structureManager, blockpos, rotation)).getBoundingBox();
                int i = (box.maxX + box.minX) / 2;
                int j = (box.maxZ + box.minZ) / 2;
                blockpos = new BlockPos(blockpos.getX(), blockpos.getY() + chunkGenerator.getNoiseHeight(i, j, config.projectStartToHeightmap().get()), blockpos.getZ());
            }

            JigsawManager.func_242837_a(registryAccess, jigsawConfig, factory, chunkGenerator, structureManager, blockpos, this.components, this.rand, false, false);
            this.recalculateStructureSize();
        }
    }
}