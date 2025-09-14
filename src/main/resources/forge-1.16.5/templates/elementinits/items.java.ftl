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
<#include "../procedures.java.ftl">
<#include "../triggers.java.ftl">
/*
 *    MCreator note: This file will be REGENERATED on each build.
 */
package ${package}.init;

<#assign hasBlocks = false>
<#assign hasDoubleBlocks = false>
<#assign hasItemsWithProperties = w.getGElementsOfType("item")?filter(e -> e.customProperties?has_content)?size != 0
	|| w.getGElementsOfType("tool")?filter(e -> e.toolType == "Shield")?size != 0>
<#assign tabMap = w.getCreativeTabMap()>
<#assign orderedCustomItems = []>
<#assign orderedVanillaItems = []>
<#assign orderedNullItems = []>

<#assign itemsWithTabs = []>
<#list items as item>
    <#if item.creativeTabs == "[]">
        <#assign orderedNullItems = orderedNullItems + [item]>
    <#else>
        <#assign itemsWithTabs = itemsWithTabs + [item]>
    </#if>
</#list>

<#assign itemsByName = {}>
<#list itemsWithTabs as item>
    <#assign itemsByName = itemsByName + {item.getModElement().getName(): item}>
</#list>

<#assign processedItems = {}>
<#list tabMap.keySet() as tabType>
    <#assign isCustom = tabType?starts_with('CUSTOM:')>
    <#assign tab = isCustom?then("CUSTOM:" + w.getWorkspace().getModElementByName(tabType.replace("CUSTOM:", "")).getGeneratableElement().getModElement().getName(), tabType)>
    <#assign currentTabItems = tabMap.get(tab)>
    <#assign prevElement = "">

    <#list currentTabItems as tabElement>
        <#assign tabEName = tabElement?replace("CUSTOM:", "")?keep_before(".")>

        <#if tabEName != prevElement && itemsByName[tabEName]??>
            <#assign item = itemsByName[tabEName]>
            <#assign currentTabs><@CreativeTabs item.creativeTabs/></#assign>

            <#if currentTabs?trim == generator.map(tabType, "tabs")?trim>
                <#if isCustom>
                    <#assign orderedCustomItems = orderedCustomItems + [item]>
                <#else>
                    <#assign orderedVanillaItems = orderedVanillaItems + [item]>
                </#if>
                <#assign processedItems = processedItems + {tabEName: true}>
            </#if>
        </#if>
        <#assign prevElement = tabEName>
    </#list>
</#list>

<#assign orderedItems = orderedCustomItems + orderedVanillaItems + orderedNullItems>
<#if hasItemsWithProperties>
@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT)
</#if>
public class ${JavaModName}Items {

	public static final DeferredRegister<Item> REGISTRY = DeferredRegister.create(ForgeRegistries.ITEMS, ${JavaModName}.MODID);

	<#list orderedItems as item>
		<#if item.getModElement().getTypeString() == "armor">
			<#if item.enableHelmet>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_HELMET =
				REGISTRY.register("${item.getModElement().getRegistryName()}_helmet", ${item.getModElement().getName()}Item.Helmet::new);
			</#if>
			<#if item.enableBody>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_CHESTPLATE =
				REGISTRY.register("${item.getModElement().getRegistryName()}_chestplate", ${item.getModElement().getName()}Item.Chestplate::new);
			</#if>
			<#if item.enableLeggings>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_LEGGINGS =
				REGISTRY.register("${item.getModElement().getRegistryName()}_leggings", ${item.getModElement().getName()}Item.Leggings::new);
			</#if>
			<#if item.enableBoots>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_BOOTS =
				REGISTRY.register("${item.getModElement().getRegistryName()}_boots", ${item.getModElement().getName()}Item.Boots::new);
			</#if>
		<#elseif item.getModElement().getTypeString() == "livingentity">
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_SPAWN_EGG =
				REGISTRY.register("${item.getModElement().getRegistryName()}_spawn_egg", () -> new ForgeSpawnEggItem(${JavaModName}Entities.${item.getModElement().getRegistryNameUpper()},
						${item.spawnEggBaseColor.getRGB()}, ${item.spawnEggDotColor.getRGB()}, new Item.Properties().group(<@CreativeTabs item.creativeTabs/>)));
		<#elseif item.getModElement().getTypeString() == "dimension" && item.hasIgniter()>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				REGISTRY.register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
		<#elseif item.getModElement().getTypeString() == "fluid" && item.generateBucket>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()}_BUCKET =
				REGISTRY.register("${item.getModElement().getRegistryName()}_bucket", ${item.getModElement().getName()}Item::new);
		<#elseif item.getModElement().getTypeString() == "block" || item.getModElement().getTypeString() == "plant">
		    <#assign customProp = item.hasCustomItemProperties()>
			<#if item.isDoubleBlock()>
				<#assign hasDoubleBlocks = true>
				public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
					doubleBlock<#if !customProp>CMT</#if>(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()},
					<#if customProp><@blockItemProperties item/><#else><@CreativeTabs item.creativeTabs/></#if>);
			<#else>
				<#assign hasBlocks = true>
				public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
					block<#if !customProp>CMT</#if>(${JavaModName}Blocks.${item.getModElement().getRegistryNameUpper()},
					<#if customProp><@blockItemProperties item/><#else><@CreativeTabs item.creativeTabs/></#if>);
			</#if>
		<#else>
			public static final RegistryObject<Item> ${item.getModElement().getRegistryNameUpper()} =
				REGISTRY.register("${item.getModElement().getRegistryName()}", ${item.getModElement().getName()}Item::new);
		</#if>
	</#list>

	// Start of user code block custom items
	// End of user code block custom items

	<#if hasBlocks>
	private static RegistryObject<Item> blockCMT(RegistryObject<Block> block, ItemGroup tab) {
		return block(block, new Item.Properties().group(tab));
	}

	private static RegistryObject<Item> block(RegistryObject<Block> block, Item.Properties properties) {
		return REGISTRY.register(block.getId().getPath(), () -> new BlockItem(block.get(), properties));
	}
	</#if>

	<#if hasDoubleBlocks>
	private static RegistryObject<Item> doubleBlockCMT(RegistryObject<Block> block, ItemGroup tab) {
		return doubleBlock(block, new Item.Properties().group(tab));
	}

	private static RegistryObject<Item> doubleBlock(RegistryObject<Block> block, Item.Properties properties) {
		return REGISTRY.register(block.getId().getPath(), () -> new TallBlockItem(block.get(), properties));
	}
	</#if>

	<#if hasItemsWithProperties>
	<#compress>
	@SubscribeEvent @OnlyIn(Dist.CLIENT) public static void clientLoad(FMLClientSetupEvent event) {
		event.enqueueWork(() -> {
		<#compress>
		<#list items as item>
			<#if item.getModElement().getTypeString() == "item">
				<#list item.customProperties.entrySet() as property>
				ItemModelsProperties.registerProperty(${item.getModElement().getRegistryNameUpper()}.get(),
					new ResourceLocation("${modid}:${item.getModElement().getRegistryName()}_${property.getKey()}"),
					(itemStackToRender, clientWorld, entity) ->
						<#if hasProcedure(property.getValue())>
							(float) <@procedureCode property.getValue(), {
								"x": "entity != null ? entity.getPosX() : 0",
								"y": "entity != null ? entity.getPosY() : 0",
								"z": "entity != null ? entity.getPosZ() : 0",
								"world": "entity != null ? entity.world : clientWorld",
								"entity": "entity",
								"itemstack": "itemStackToRender"
							}, false/>
						<#else>0</#if>
				);
				</#list>
			<#elseif item.getModElement().getTypeString() == "tool" && item.toolType == "Shield">
				ItemModelsProperties.registerProperty(${item.getModElement().getRegistryNameUpper()}.get(), new ResourceLocation("minecraft:blocking"),
					ItemModelsProperties.func_239417_a_(Items.SHIELD, new ResourceLocation("minecraft:blocking")));
			</#if>
		</#list>
		</#compress>
		});
	}
	</#compress>
	</#if>
}
<#macro blockItemProperties block>
new Item.Properties()
<#if block.maxStackSize != 64>
	.maxStackSize(${block.maxStackSize})
</#if>
<#if block.rarity != "COMMON">
	.rarity(Rarity.${block.rarity})
</#if>
<#if block.immuneToFire>
	.isImmuneToFire()
</#if>
.group(<@CreativeTabs block.creativeTabs/>)
</#macro>
<#-- @formatter:on -->