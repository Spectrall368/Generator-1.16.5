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
<#assign hasTransparentBlocks = false>
<#assign hasTintedBlocks = false>
<#assign hasTintedBlockItems = false>
<#list blocks as block>
	<#if block.getModElement().getTypeString() == "block">
        <#if block.transparencyType != "SOLID" || block.hasTransparency || block.tintType != "No tint">
            <#assign hasTransparentBlocks = true>
        </#if>
		<#if block.tintType != "No tint">
			<#assign hasTintedBlocks = true>
			<#if block.isItemTinted && block.hasBlockItem>
				<#assign hasTintedBlockItems = true>
			</#if>
		</#if>
	<#elseif block.getModElement().getTypeString() == "plant">
	        <#assign hasTransparentBlocks = true> <#-- Plants always have cutout transparency -->
		<#if block.tintType != "No tint">
			<#assign hasTintedBlocks = true>
			<#if block.isItemTinted && block.hasBlockItem>
				<#assign hasTintedBlockItems = true>
			</#if>
		</#if>
	</#if>
</#list>

<#assign signs = w.getGElementsOfType("block")?filter(e -> e.isSign())>

<#assign chunks = blocks?chunk(2500)>
<#assign has_chunks = chunks?size gt 1>
<#assign noteBlockInstrument = blocks?filter(block -> block.noteBlockInstrument?? && block.noteBlockInstrument != "harp")>

<#if signs?size != 0>@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD)</#if>public class ${JavaModName}Blocks {

	public static final DeferredRegister<Block> REGISTRY = DeferredRegister.create(ForgeRegistries.BLOCKS, ${JavaModName}.MODID);

	<@javacompress>
	<#list blocks as block>
		<#if block.getModElement().getTypeString() == "dimension">
            public static <#if !has_chunks>final</#if> RegistryObject<Block> ${block.getModElement().getRegistryNameUpper()}_PORTAL;
		<#else>
			public static <#if !has_chunks>final</#if> RegistryObject<Block> ${block.getModElement().getRegistryNameUpper()};
			<#if (block.getModElement().getTypeString() == "block") && block.isSign()>
				public static <#if !has_chunks>final</#if> RegistryObject<Block> ${block.getWallRegistryNameUpper()};
			</#if>
		</#if>
	</#list>
	</@javacompress>

	<#list chunks as sub_blocks>
	<#if has_chunks>public static void register${sub_blocks?index}()<#else>static</#if> {
		<#list sub_blocks as block>
			<#if block.getModElement().getTypeString() == "dimension">
        	    ${block.getModElement().getRegistryNameUpper()}_PORTAL =
					REGISTRY.register("${block.getModElement().getRegistryName()}_portal", ${block.getModElement().getName()}PortalBlock::new);
			<#else>
				${block.getModElement().getRegistryNameUpper()} =
					REGISTRY.register("${block.getModElement().getRegistryName()}", ${block.getModElement().getName()}Block::new);
				<#if (block.getModElement().getTypeString() == "block") && block.isSign()>
					${block.getWallRegistryNameUpper()} =
						REGISTRY.register("${block.getWallRegistryName()}", ${block.getWallName()}Block::new);
				</#if>
			</#if>
		</#list>
	}
	</#list>

	<#if has_chunks>
	static {
		<#list 0..chunks?size-1 as i>register${i}();</#list>
	}
	</#if>

	// Start of user code block custom blocks
	// End of user code block custom blocks

	<#if hasTransparentBlocks || hasTintedBlocks || hasTintedBlockItems || (signs?size != 0)>
	@Mod.EventBusSubscriber(bus = Mod.EventBusSubscriber.Bus.MOD, value = Dist.CLIENT) public static class BlocksClientSideHandler {
        <#if hasTransparentBlocks>
	    @SubscribeEvent public static void clientSetup(FMLClientSetupEvent event) {
	    	<#list blocks as block>
                <#if block.getModElement().getTypeString() == "block">
                    <#if block.transparencyType != "SOLID" || block.hasTransparency>
                        ${block.getModElement().getName()}Block.registerRenderLayer();
                    </#if>
                <#elseif block.getModElement().getTypeString() == "plant">
                    ${block.getModElement().getName()}Block.registerRenderLayer();
                <#elseif block.getModElement().getTypeString() == "dimension">
                    ${block.getModElement().getName()}PortalBlock.registerRenderLayer();
                </#if>
            </#list>
		}
        </#if>

		<#if hasTintedBlocks>
		@SubscribeEvent public static void blockColorLoad(ColorHandlerEvent.Block event) {
			<#list blocks as block>
				<#if block.getModElement().getTypeString() == "block" || block.getModElement().getTypeString() == "plant">
					<#if block.tintType != "No tint">
						 ${block.getModElement().getName()}Block.blockColorLoad(event);
					</#if>
				</#if>
			</#list>
		}
		</#if>

		<#if hasTintedBlockItems>
		@SubscribeEvent public static void itemColorLoad(ColorHandlerEvent.Item event) {
			<#list blocks as block>
				<#if block.getModElement().getTypeString() == "block" || block.getModElement().getTypeString() == "plant">
					<#if block.tintType != "No tint" && block.isItemTinted && block.hasBlockItem>
						 ${block.getModElement().getName()}Block.itemColorLoad(event);
					</#if>
				</#if>
			</#list>
		}
		</#if>

		<#if signs?size != 0>
		@SubscribeEvent public static void clientSignSetup(FMLClientSetupEvent event) {
			<#list signs as block>
				Atlases.addWoodType(${JavaModName}WoodTypes.${block.getModElement().getRegistryNameUpper()}_WOOD_TYPE);
			</#list>
		}
		</#if>
	}
	</#if>

	<#if noteBlockInstrument?size != 0>
	@Mod.EventBusSubscriber public static class BlocksHandler {
        @SubscribeEvent public static void onNoteBlockPlay(NoteBlockEvent.Play event) {
            <#compress>
            Block below = event.getWorld().getBlockState(event.getPos().down()).getBlock();
            <#list noteBlockInstrument as block>
            if (below == ${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}.get()) {
                event.setInstrument(${generator.map(block.noteBlockInstrument, "noteblockinstruments")});
            }<#sep>else
            </#list>
            </#compress>
        }
    }
	</#if>

	<#if signs?size != 0>
	@SubscribeEvent public static void registerSigns(FMLCommonSetupEvent event) {
		event.enqueueWork(() -> {
            <#list signs as block>
                modify(TileEntityType.SIGN, ${block.getModElement().getRegistryNameUpper()}.get(), ${block.getWallRegistryNameUpper()}.get());
            </#list>
		});
	}

    private static void modify(TileEntityType<?> blockEntityType, Block... blocksToAdd) {
        Set<Block> currentValidBlocks = new HashSet<>(Collections.unmodifiableSet(((BlockEntityTypeAccessor) blockEntityType).getValidBlocks()));

        for (Block block : blocksToAdd)
            currentValidBlocks.add(block);

        ((BlockEntityTypeAccessor) blockEntityType).setValidBlocks(currentValidBlocks);
    }
	</#if>
}
<#-- @formatter:on -->