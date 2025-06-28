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
 * MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;
<#assign featuresList = w.getGElementsOfType("block")?filter(e -> e.generateFeature) + w.getGElementsOfType("plant")?filter(e -> e.generateFeature) + w.getGElementsOfType("feature")>

@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD) public class ${JavaModName}Features {

	public static final DeferredRegister<Feature<?>> REGISTRY = DeferredRegister.create(ForgeRegistries.FEATURES, ${JavaModName}.MODID);

    <#list featuresList as feature>
	public static final RegistryObject<Feature<?>> ${feature.getModElement().getRegistryNameUpper()} =
		REGISTRY.register("${feature.getModElement().getRegistryName()}", () -> new ${feature.getModElement().getName()}Feature());
	</#list>

	@SubscribeEvent public static void addToBiomes(BiomeLoadingEvent event) {
	<#list featuresList as feature>
		${feature.getModElement().getName()}Feature.addToBiomes(event);
	</#list>
	}

	@SubscribeEvent public static void init(RegistryEvent.Register<Feature<?>> event) {
	<#list featuresList as feature>
		register("${feature.getModElement().getRegistryName()}", ${feature.getModElement().getName()}Feature.configuredFeature());
		${feature.getModElement().getName()}Feature.CUSTOM_MATCH = registerRule("${feature.getModElement().getRegistryName()}_match", ${feature.getModElement().getName()}Feature.${feature.getModElement().getName()}FeatureRuleTest.CODEC);
	</#list>
	}

	private static <FC extends IFeatureConfig> void register(String registryname, ConfiguredFeature<FC, ?> configuredFeature) {
		Registry.register(WorldGenRegistries.CONFIGURED_FEATURE, new ResourceLocation("${modid}:" + registryname), configuredFeature);
	}

	private static <P extends RuleTest> RuleTestType<P> registerRule(String registryname,  Codec<P> codec) {
		Registry.register(Registry.RULE_TEST,  new ResourceLocation("${modid}:" + registryname), () -> codec);
	}
}
<#-- @formatter:on -->