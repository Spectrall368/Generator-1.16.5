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
package ${package}.world.features;

<#compress>
@Mod.EventBusSubscriber public class StructureModFeature extends Feature<StructureModFeatureConfiguration> {
	public static final DeferredRegister<Feature<?>> REGISTRY = DeferredRegister.create(ForgeRegistries.FEATURES, ${JavaModName}.MODID);
	public static final RegistryObject<Feature<?>> STRUCTURE_FEATURE = REGISTRY.register("structure_feature", () -> new StructureModFeature(StructureModFeatureConfiguration.CODEC));

	public StructureModFeature(Codec<StructureModFeatureConfiguration> codec) {
		super(codec);
	}

	@Override public boolean generate(ISeedReader world, ChunkGenerator generator, Random random, BlockPos pos, StructureModFeatureConfiguration config) {
		Rotation rotation = config.randomRotation ? Rotation.randomRotation(random) : Rotation.NONE;
		Mirror mirror = config.randomMirror ? Mirror.values()[random.nextInt(2)] : Mirror.NONE;
		// Load the structure template
		TemplateManager structureManager = world.getWorld().getStructureTemplateManager();
		Template template = structureManager.getTemplateDefaulted(config.structure);
		PlacementSettings placeSettings = (new PlacementSettings()).setRotation(rotation).setMirror(mirror).setRandom(random).setIgnoreEntities(false)
				.addProcessor(new BlockIgnoreStructureProcessor(config.ignoredBlocks.stream().map(BlockState::getBlock).collect(Collectors.toList())));
		BlockPos placePos = pos.add(Template.transformedBlockPos(placeSettings, new BlockPos(config.offset)));
		template.func_237146_a_(world, placePos, placePos, placeSettings, random, 2);
		return true;
	}
}
</#compress>
<#-- @formatter:on -->
