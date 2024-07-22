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
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}VillagerProfessions {

	private static final Map<String, ProfessionPoiType> POI_TYPES = new HashMap<>();
	public static final DeferredRegister<VillagerProfession> PROFESSIONS = DeferredRegister.create(ForgeRegistries.PROFESSIONS, ${JavaModName}.MODID);

	<#list villagerprofessions as villagerprofession>
		public static final RegistryObject<VillagerProfession> ${villagerprofession.getModElement().getRegistryNameUpper()} =
			registerProfession(
				"${villagerprofession.getModElement().getRegistryName()}",
				() -> ${mappedBlockToBlock(villagerprofession.pointOfInterest)},
				() -> ForgeRegistries.SOUND_EVENTS.getValue(new ResourceLocation("${villagerprofession.actionSound}"))
			);
	</#list>

	private static RegistryObject<VillagerProfession> registerProfession(String name, Supplier<Block> block, Supplier<SoundEvent> soundEvent) {
		POI_TYPES.put(name, new ProfessionPoiType(block, null));

		return PROFESSIONS.register(name, () -> {
			PointOfInterestType poiPredicate = POI_TYPES.get(name).poiType;
			return new VillagerProfession(${JavaModName}.MODID + ":" + name, poiPredicate, ImmutableSet.of(), ImmutableSet.of(), soundEvent.get());
		});
	}

	@SubscribeEvent public static void registerProfessionPointsOfInterest(RegistryEvent.Register<PointOfInterestType> event) {
			for (Map.Entry<String, ProfessionPoiType> entry : POI_TYPES.entrySet()) {
				Block block = entry.getValue().block.get();
				String name = entry.getKey();

				Optional<PointOfInterestType> existingCheck = PointOfInterestType.forState(block.getDefaultState());
				if (existingCheck.isPresent()) {
					${JavaModName}.LOGGER.error("Skipping villager profession " + name + " that uses POI block " + block + " that is already in use by " + existingCheck);
					continue;
				}

				PointOfInterestType poiType = new PointOfInterestType(name, ImmutableSet.copyOf(block.getStateContainer().getValidStates()), 1, 1).setRegistryName(${JavaModName}.MODID + ":" + name);;
				poiType.registerBlockStates(poiType);
        			event.getRegistry().register(poiType);
				entry.getValue().poiType = poiType;
			}
	}

	private static class ProfessionPoiType {
		final Supplier<Block> block;
		PointOfInterestType poiType;

		ProfessionPoiType(Supplier<Block> block, PointOfInterestType poiType) {
			this.block = block;
			this.poiType = poiType;
		}
	}
}
<#-- @formatter:on -->
