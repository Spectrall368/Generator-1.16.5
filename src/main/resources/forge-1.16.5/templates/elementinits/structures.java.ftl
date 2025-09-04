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
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

@Mod.EventBusSubscriber
public class ${JavaModName}Structures {
    public static final DeferredRegister<Structure<?>> REGISTRY = DeferredRegister.create(ForgeRegistries.STRUCTURE_FEATURES, ${JavaModName}.MODID);
	private static final List<StructureRegistration> STRUCTURE_REGISTRATIONS = new ArrayList<>();

    <#list structures as structure>
	public static final RegistryObject<${JavaModName}StructureBase> ${structure.getModElement().getRegistryNameUpper()} =
	    register("${structure.getModElement().getRegistryName()}", ${structure.getModElement().getName()}Structure::new);
	</#list>

	private static RegistryObject<${JavaModName}StructureBase> register(String registryname, Supplier<${JavaModName}StructureBase> structure) {
        StructureRegistration structureRegistration = new StructureRegistration(REGISTRY.register(registryname, structure));
        STRUCTURE_REGISTRATIONS.add(structureRegistration);
        return structureRegistration.structure();
	}

    @Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD)
    private static class InitClass {
        @SubscribeEvent public static void init(FMLCommonSetupEvent event) {
            event.enqueueWork(() -> {
                for (StructureRegistration registration : STRUCTURE_REGISTRATIONS) {
                    ${JavaModName}StructureBase structure = registration.structure().get();
                    StructureSeparationSettings configuration = structure.getStructureFeatureConfiguration();
                    String id = structure.getRegistryName().toString();

                    Structure.NAME_STRUCTURE_BIMAP.put(id, structure);

                    if(structure.isSurroundedByLand()) {
                        Structure.field_236384_t_ = ImmutableList.<Structure<?>>builder()
                            .addAll(Structure.field_236384_t_).add(structure).build();
                    }

                    DimensionStructuresSettings.field_236191_b_ = ImmutableMap.<Structure<?>, StructureSeparationSettings>builder()
                        .putAll(DimensionStructuresSettings.field_236191_b_).put(structure, configuration).build();

                    WorldGenRegistries.NOISE_SETTINGS.getEntries().forEach(settings -> {
                        Map<Structure<?>, StructureSeparationSettings> structureMap = settings.getValue().getStructures().func_236195_a_();

                        if(structureMap instanceof ImmutableMap) {
                            Map<Structure<?>, StructureSeparationSettings> tempMap = new HashMap<>(structureMap);
                            tempMap.put(structure, configuration);
                            settings.getValue().getStructures().field_236193_d_ = tempMap;
                        } else {
                            structureMap.put(structure, configuration);
                        }
                    });

                    Registry.register(WorldGenRegistries.CONFIGURED_STRUCTURE_FEATURE, id, structure.configuredFeature());
                    FlatGenerationSettings.STRUCTURES.put(structure, structure.configuredFeature());
                }
            });
        }
    }

	@SubscribeEvent(priority = EventPriority.HIGH) public static void addFeaturesToBiomes(BiomeLoadingEvent event) {
		for (StructureRegistration registration : STRUCTURE_REGISTRATIONS) {
            ${JavaModName}StructureBase structure = registration.structure().get();
			if (structure.getBiomes() == null || structure.getBiomes().contains(event.getName()))
				event.getGeneration().getStructures().add(() -> structure.configuredFeature());
		}
	}

	@SubscribeEvent public static void addDimensionalSpacing(WorldEvent.Load event) {
            if(event.getWorld() instanceof ServerWorld) {
                ServerWorld serverWorld = (ServerWorld) event.getWorld();

            if(serverWorld.getChunkProvider().getChunkGenerator() instanceof FlatChunkGenerator && serverWorld.getDimensionKey().equals(World.OVERWORLD)) {
                return;
            }

            Map<Structure<?>, StructureSeparationSettings> tempMap = new HashMap<>(serverWorld.getChunkProvider().generator.func_235957_b_().func_236195_a_());

            for (StructureRegistration registration : STRUCTURE_REGISTRATIONS) {
                ${JavaModName}StructureBase structure = registration.structure().get();
                if (structure.getDimensions() != null && !structure.getDimensions().contains(serverWorld.getDimensionKey())) {
                    tempMap.remove(structure);
                    continue;
                }

                tempMap.putIfAbsent(structure, DimensionStructuresSettings.field_236191_b_.get(structure));

            }

            serverWorld.getChunkProvider().generator.func_235957_b_().field_236193_d_ = tempMap;
            }
	}

    private static class StructureRegistration {
        private final RegistryObject<${JavaModName}StructureBase> structure;

        public StructureRegistration(RegistryObject<${JavaModName}StructureBase> structure) {
            this.structure = structure;
        }

        public RegistryObject<${JavaModName}StructureBase> structure() {
            return structure;
        }
    }
}
<#-- @formatter:on -->