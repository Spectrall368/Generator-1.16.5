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
package ${package}.world.dimension;

<#compress>
@Mod.EventBusSubscriber public class ${name}Dimension {
	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public static class ${name}SpecialEffectsHandler {
		@SubscribeEvent public static void registerDimensionSurfaceBuilder(FMLCommonSetupEvent event) {
			Set<Block> replaceableBlocks = new HashSet<>();
			replaceableBlocks.add(${mappedBlockToBlock(data.mainFillerBlock)});
	
			<#list w.filterBrokenReferences(data.biomesInDimension) as biome>
			replaceableBlocks.add(ForgeRegistries.BIOMES.getValue(new ResourceLocation("${biome}"))
					.getGenerationSettings().getSurfaceBuilder().get().getConfig().getTop().getBlock());
			replaceableBlocks.add(ForgeRegistries.BIOMES.getValue(new ResourceLocation("${biome}"))
					.getGenerationSettings().getSurfaceBuilder().get().getConfig().getUnder().getBlock());
			</#list>
	
			DeferredWorkQueue.runLater(() -> {
				try {
					ObfuscationReflectionHelper.setPrivateValue(WorldCarver.class, WorldCarver.CAVE, new ImmutableSet.Builder<Block>()
							.addAll((Set<Block>) ObfuscationReflectionHelper.getPrivateValue(WorldCarver.class, WorldCarver.CAVE, "field_222718_j"))
							.addAll(replaceableBlocks).build(), "field_222718_j");
	
					ObfuscationReflectionHelper.setPrivateValue(WorldCarver.class, WorldCarver.CANYON, new ImmutableSet.Builder<Block>()
							.addAll((Set<Block>) ObfuscationReflectionHelper.getPrivateValue(WorldCarver.class, WorldCarver.CANYON, "field_222718_j"))
							.addAll(replaceableBlocks).build(), "field_222718_j");
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
		}

	<#if data.useCustomEffects>
		@SubscribeEvent @OnlyIn(Dist.CLIENT) public static void registerDimensionSpecialEffects(FMLClientSetupEvent event) {
			DimensionRenderInfo customEffect = new DimensionRenderInfo(<#if data.hasClouds>${data.cloudHeight}f<#else>Float.NaN</#if>,
				true, DimensionRenderInfo.FogType.${data.skyType}, false, false) {
					@Override public Vector3d func_230494_a_(Vector3d color, float sunHeight) {
						<#if data.airColor?has_content>
							return new Vector3d(${data.airColor.getRed()/255},${data.airColor.getGreen()/255},${data.airColor.getBlue()/255})
						<#else>
							return color
					</#if>
					<#if data.sunHeightAffectsFog>
						.mul(sunHeight * 0.94 + 0.06, sunHeight * 0.94 + 0.06, sunHeight * 0.91 + 0.09)
					</#if>;
					}

					@Override public boolean func_230493_a_(int x, int y) {
						return ${data.hasFog};
					}
			};

			DeferredWorkQueue.runLater(() -> {
				try {
					Object2ObjectMap<ResourceLocation, DimensionRenderInfo> effectsRegistry =
							(Object2ObjectMap<ResourceLocation, DimensionRenderInfo>) ObfuscationReflectionHelper.getPrivateValue(DimensionRenderInfo.class, null, "field_239208_a_");
					effectsRegistry.put(new ResourceLocation("${modid}:${registryname}"), customEffect);
				} catch (Exception e) {
					e.printStackTrace();
				}
			});
		}
	</#if>
	}

	<#if hasProcedure(data.onPlayerLeavesDimension) || hasProcedure(data.onPlayerEntersDimension)>
	@SubscribeEvent public static void onPlayerChangedDimensionEvent(PlayerEvent.PlayerChangedDimensionEvent event) {
		Entity entity = event.getPlayer();
		World world = entity.world;
		double x = entity.getPosX();
		double y = entity.getPosY();
		double z = entity.getPosZ();

		<#if hasProcedure(data.onPlayerLeavesDimension)>
		if (event.getFrom() == RegistryKey.getOrCreateKey(Registry.WORLD_KEY, new ResourceLocation("${modid}:${registryname}"))) {
			<@procedureOBJToCode data.onPlayerLeavesDimension/>
		}
        </#if>

		<#if hasProcedure(data.onPlayerEntersDimension)>
		if (event.getTo() == RegistryKey.getOrCreateKey(Registry.WORLD_KEY, new ResourceLocation("${modid}:${registryname}"))) {
			<@procedureOBJToCode data.onPlayerEntersDimension/>
		}
        </#if>
	}
    </#if>
}
</#compress>
